import 'dart:convert';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/material/model/pdf_list_model.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/editorial_detail_controler.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/src/screen/pages/page/pdf_viewer.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:english_madhyam/restApi/api_service.dart';
import '../../../utils/colors/colors.dart';
import '../../../widgets/free_paid_widget.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';
import '../../profile/controller/profile_controllers.dart';
import '../controller/pdf_list_control.dart';
import 'material_editorial_listpage.dart';

class MaterialListTabPage extends StatefulWidget {
  final String catid;
  final String subCateId;
  final String title;
  final String type;

  const MaterialListTabPage({
    Key? key,
    required this.catid,
    required this.subCateId,
    required this.type,
    required this.title,
  }) : super(key: key);

  @override
  _MaterialListTabPageState createState() => _MaterialListTabPageState();
}

class _MaterialListTabPageState extends State<MaterialListTabPage>
    with TickerProviderStateMixin {
  final PdfController _pdfController = Get.put(PdfController());
  final _catEditorialContr = Get.put(EditorialDetailController());
  late String _localPath;
  final GlobalKey<SfPdfViewerState> _allContentsKey = GlobalKey();
  int? downloadStarted;
  final ProfileControllers _profileController = Get.find();

  bool? _permissionReady;
  late TabController tabController;

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final PermissionHandlerPlatform _permissionHandler =
      PermissionHandlerPlatform.instance;

  @override
  void initState() {
    super.initState();
    _catEditorialContr.editorialByCat.clear();
    _catEditorialContr.categoryId(int.parse(widget.catid));

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/logo_round');
    final initSettings = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin!.initialize(initSettings);

    tabController = TabController(length: 2, vsync: this);
    if (tabController.index == 0) {
      _catEditorialContr.getTask(1, int.parse(widget.catid));
    }
    tabController.addListener(() {
      if (tabController.index == 1) {
        _pdfController.pdfListController(type: widget.type, id: widget.catid);
      }
    });
  }

  Future<bool> _requestPermissions() async {
    var permission =
        await _permissionHandler.checkPermissionStatus(Permission.storage);
    if (permission != PermissionStatus.granted) {
      await _permissionHandler.requestPermissions([Permission.storage]);
      permission =
          await _permissionHandler.checkPermissionStatus(Permission.storage);
    }
    return permission == PermissionStatus.granted;
  }

  Future<Directory?> _getDownloadDirectory() async {
    try {
      return Platform.isAndroid
          ? await getExternalStorageDirectory() // FOR ANDROID
          : await getApplicationSupportDirectory();
    } catch (e) {
      return await getExternalStorageDirectory();
    }
  }

  Future<void> _download(String? file, int? index) async {
    setState(() {
      downloadStarted = index;
    });

    try {
      final dir = await _getDownloadDirectory();
      final isPermissionGranted = await _requestPermissions();
      if (isPermissionGranted || dir != null) {
        final savePath = path.join(dir!.path, widget.title + ".pdf");
        cancel();
        await _startDownload(savePath, file!);
      } else {
        // Handle permission denied case here
      }
    } catch (e) {
      // Handle error here
    }
  }

  Future<void> _startDownload(String savePath, String file) async {
    try {
      final result =
          await apiService.downloadPdfFile(filePath: file, savePath: savePath);
      if (result['isSuccess'] == true) {
        await _showNotification(result);
        Fluttertoast.showToast(msg: "PDF Downloaded in your app folder");
        setState(() {
          downloadStarted = null;
        });
      }
    } catch (ex) {
      // Handle download error here
    }
  }

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    const android = AndroidNotificationDetails('1', 'channel name',
        priority: Priority.high, importance: Importance.max);
    final platform = NotificationDetails(android: android);
    final json = jsonEncode(downloadStatus);

    await flutterLocalNotificationsPlugin!.show(
      0,
      downloadStatus['isSuccess'] ? 'Success' : 'Failure',
      downloadStatus['isSuccess']
          ? 'File has been downloaded successfully!'
          : 'There was an error while downloading the file.',
      platform,
      payload: json,
    );
    await _onSelectNotification(json);
  }

  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);
    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _allContentsKey,
      appBar: AppBar(
          elevation: 0.0,
          centerTitle: false,
          title: ToolbarTitle(
            title: widget.title,
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const SizedBox(height: 6),
              buildTabWidget(),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    MaterialEditorialListPage(title: widget.title),
                    GetX<PdfController>(
                      builder: (_) {
                        if (_.loading.value == false) {
                          return _.pdfList.value.pdfs == null
                              ? Lottie.asset(
                                  "assets/animations/49993-search.json",
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                )
                              : pdfListWidgetTab(_.pdfList.value.pdfs!);
                        } else {
                          return Center(
                            child: Lottie.asset(
                              "assets/animations/loader.json",
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pdfListWidgetTab(List<Pdfs> pdff) {
    pdff.sort((a, b) => b.publishAt!.compareTo(a.publishAt!));
    return ListView.builder(
      itemCount: pdff.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (widget.type == "1") {
              if (_profileController.isSubscriptionActive) {
                Get.to(() => PdfViewer(
                    link: pdff[index].file!, title: pdff[index].title!));
              } else {
                _profileController.getProfileData();
                Platform.isAndroid
                    ? Get.toNamed(ChoosePlanDetails.routeName)
                    : Get.to(InAppPlanDetail());
              }
            } else {
              Get.to(() => PdfViewer(
                  link: pdff[index].file!, title: pdff[index].title!));
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 15.adaptSize, vertical: 10.adaptSize),
            padding: EdgeInsets.all(12.adaptSize),
            decoration: UiHelper.pdfDecoration(context, index % 6),
            child: Row(
              children: [
                Container(
                  height: 70.adaptSize,
                  width: 70.adaptSize,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: purpleColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: SvgPicture.asset("assets/icon/clock_timer.svg")),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextViewWidget(
                          text: pdff[index].title.toString(),
                          color: colorSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CommonTextViewWidget(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  text: pdff[index].publishAt!.substring(0, 10),
                                  color: colorGray),
                              const SizedBox(
                                width: 12,
                              ),
                              FreePaidWidget(type: widget.type)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                downloadStarted == index
                    ? CircularProgressIndicator(
                        strokeWidth: 2, color: blackColor)
                    : Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => _download(pdff[index].file, index),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/icon/downloadicon.svg"),
                              CommonTextViewWidget(text: "PDF")
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTabWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55.adaptSize,
      child: TabBar(
          unselectedLabelColor: colorGray,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: tabController,
          padding: EdgeInsets.symmetric(horizontal: 6.adaptSize),
          dividerColor: Colors.transparent,
          unselectedLabelStyle:
              TextStyle(fontSize: 18.fSize, fontWeight: FontWeight.w500),
          labelStyle: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.w500,
              color: Colors.white),
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: purpleColor),
          tabs: const [
            Tab(
              text: "Reading",
            ),
            Tab(
              text: "PDF",
            )
          ]),
    );
  }
}
