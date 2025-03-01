import 'dart:convert';
import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_madhyam/restApi/api_service.dart';
import 'package:english_madhyam/src/screen/editorials_page/model/editorial_task_model.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';

import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/audio_player.dart';
import 'package:english_madhyam/src/screen/editorials_page/widgets/quiz_button.dart';
import 'package:english_madhyam/src/screen/practice/widget/performance_report.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/storage/cache_manager.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../utils/colors/colors.dart';
import '../../exam/controller/examDetailController.dart';
import '../../favorite/controller/favoriteController.dart';
import '../../pages/page/converter.dart';
import '../../practice/widget/instructions.dart';

class EditorialsDetailsPage extends StatefulWidget {
  final int editorial_id;
  final String editorial_title;

  const EditorialsDetailsPage(
      {Key? key, required this.editorial_id, required this.editorial_title})
      : super(key: key);

  @override
  _EditorialsDetailsPageState createState() => _EditorialsDetailsPageState();
}

class _EditorialsDetailsPageState extends State<EditorialsDetailsPage>
    with SingleTickerProviderStateMixin, CacheManager {
  final FavoriteController _favoriteController = Get.put(FavoriteController());

  final HtmlConverter _htmlConverter = HtmlConverter();
  final EditorialDetailController controller =
      Get.put(EditorialDetailController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ItemScrollController itemScrollController = ItemScrollController();
  bool didDownloadPDF = false;
  String type = "";
  int CurrentVideo = 0;
  double custFontSize = 18;
  double progress = 0;

  late bool _permissionReady;
  String TaskID = "";
  bool editable = false;
  int startingPoint = -1;
  int endingPoint = -1;

  final fileName = '/English-madhyam.pdf';
  int position = 0;

  // int bookmark = -1;
  List<Gradient> color = [
    learning1,
    learning2,
    learning3,
    learning4,
    learning5,
    learning6
  ];
  bool darkmode = false;
  bool downloadStart = false;

  /// pdf download section
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  final PermissionHandlerPlatform _permissionHandler =
      PermissionHandlerPlatform.instance;

  /// permission for downloading pdf
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
      Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory() //FOR ANDROID
          : await getApplicationSupportDirectory();
      return directory!;
    } catch (e) {
      return await getExternalStorageDirectory();
    }
  }

  ///download pdf
  Future<void> _download(String? file) async {
    setState(() {
      downloadStart = true;
    });
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();

    final hasExisted = dir?.existsSync() ?? false;
    if (!hasExisted) {
      await dir?.create();
    }

    if (isPermissionStatusGranted || dir != null) {
      // print(file!.length.toString() + "FILE LENGTH");
      final savePath = path.join(dir!.path, widget.editorial_title + ".pdf");

      await _startDownload(savePath, file!);
    }
    // else if (dir != null) {
    //   final savePath = path.join(dir.path, widget.editorial_title + ".pdf");
    //
    //   await _startDownload(savePath, file!);
    // }
    else {
      // print("user decline download permission");
      // handle the scenario when user declines the permissions
    }
  }

  ///dio for start downloading
  Future<void> _startDownload(String savePath, String file) async {
    try {
      Map<String, dynamic> result =
          await apiService.downloadPdfFile(filePath: file, savePath: savePath);
      setState(() {
        downloadStart = false;
      });
      await _showNotification(result);
      Fluttertoast.showToast(msg: "Pdf Downloaded in your app folder");
    } catch (ex) {
      print(ex);
    }
  }

  /// local notification
  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    const android = AndroidNotificationDetails('1', 'channel name',
        // 'channel description',
        priority: Priority.high,
        importance: Importance.max);

    final platform = const NotificationDetails(android: android);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];
    // print("${platform.iOS!.subtitle}" + "platform information");

    await flutterLocalNotificationsPlugin!.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'File has been downloaded successfully!'
            : 'There was an error while downloading the file.',
        platform,
        payload: json);
    // print("Notification Shown ===================================");
    await _onSelectNotification(json);
  }

  ///when user tap on notification
  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: CommonTextViewWidget(text: 'Error'),
          content: CommonTextViewWidget(text: '${obj['error']}'),
        ),
      );
    }
  }

  /// for decreasing and increasing font size in editorial
  void increaseFontSize() async {
    if (custFontSize >= 30.0) {
      Fluttertoast.showToast(msg: "Maximum Size");
      cancel();
    } else {
      setState(() {
        custFontSize += 2;
      });
    }
  }

  void decreaseFontSize() async {
    if (custFontSize <= 17.0) {
      Fluttertoast.showToast(msg: "Minimum Size");
      cancel();

      setState(() {
        custFontSize = 17;
      });
    } else {
      setState(() {
        custFontSize -= 1;
      });
    }
  }

  AnimationController? _recordAnimCtrl;
  List<EditorialDescription> readingData = [];

  @override
  void initState() {
    super.initState();
    readingData = getEditorialDescriptions(widget.editorial_id.toString());
    if (readingData.isNotEmpty) {
      editable = true;
    }

    ///for listing of meaning list in drawer and highlighted word meanings
    controller.meaningList(id: widget.editorial_id.toString());

    /// pdf download initialization
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = const AndroidInitializationSettings('@mipmap/logo_round');

    if (Platform.isAndroid) {
      final initSettings = InitializationSettings(android: android);
      flutterLocalNotificationsPlugin!.initialize(initSettings);
    }
    _permissionReady = false;

    /// audio record animation initialization
    _recordAnimCtrl =
        AnimationController(duration: const Duration(seconds: 10), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    controller.pageManager.value.dispose();
    _recordAnimCtrl!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.9,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
          child: Drawer(
            child: Obx(() {
              if (controller.loading.value) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Center(
                    child: Lottie.asset(
                      "assets/animations/loader.json",
                      height: MediaQuery.of(context).size.height * 0.14,
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    (controller.meaningListModel.value.result == false)
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                      'assets/animations/49993-search.json',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1),
                                  CommonTextViewWidget(
                                    text: "No meanings Available",
                                    color: whiteColor,
                                    fontWeight: FontWeight.w600,
                                  )
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            child: ScrollablePositionedList.builder(
                                itemScrollController: itemScrollController,
                                initialScrollIndex: position,
                                addAutomaticKeepAlives: true,
                                itemCount: controller
                                    .meaningListModel.value.editorials!.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  String resultText =
                                      _htmlConverter.parseHtmlString(controller
                                          .meaningListModel
                                          .value
                                          .editorials![index]
                                          .meaning
                                          .toString());
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        position = index;
                                      });
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                position == index
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.bookmark,
                                                            color: redColor,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                TextButton(
                                                  child: CommonTextViewWidget(
                                                    text: controller
                                                        .meaningListModel
                                                        .value
                                                        .editorials![index]
                                                        .title,
                                                  ),
                                                  onPressed: () async {
                                                    if (controller
                                                            .meaningListModel
                                                            .value
                                                            .editorials![index]
                                                            .title ==
                                                        "SAVE") {
                                                      await _favoriteController.saveWordsToList(
                                                          context: context,
                                                          wordId: _htmlConverter
                                                              .parseHtmlString(controller
                                                                  .meaningListModel
                                                                  .value
                                                                  .editorials![
                                                                      index]
                                                                  .id
                                                                  .toString()));
                                                      controller
                                                          .meaningListModel
                                                          .value
                                                          .editorials![index]
                                                          .title = "SAVED";
                                                    } else {
                                                      await _favoriteController
                                                          .removeWordsFromList(
                                                              context: context,
                                                              wordId: _htmlConverter
                                                                  .parseHtmlString(controller
                                                                      .meaningListModel
                                                                      .value
                                                                      .editorials![
                                                                          index]
                                                                      .id
                                                                      .toString()));
                                                      controller
                                                          .meaningListModel
                                                          .value
                                                          .editorials![index]
                                                          .title = "SAVE";
                                                    }
                                                    setState(() {});
                                                  },
                                                )
                                              ],
                                            ),
                                            CommonTextViewWidget(
                                              text:
                                                  "${controller.meaningListModel.value.editorials![index].word} : ",
                                            ),
                                            CommonTextViewWidget(
                                              text: resultText,
                                              maxLine: 10,
                                            ),
                                          ],
                                        )),
                                  );
                                }),
                          ),
                  ],
                );
              }
            }),
          ),
        ),
      ),
      appBar: AppBar(
        titleSpacing: 0.0,
        title: ToolbarTitle(
          title: widget.editorial_title.length > 35
              ? "${widget.editorial_title.substring(0, 35)}.."
              : widget.editorial_title,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              increaseFontSize();
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(top: 13, bottom: 13),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(2),
                    bottomLeft: Radius.circular(2)),
                color: const Color(0xffccccff).withOpacity(0.6),
              ),
              child: const Icon(Icons.add),
            ),
          ),
          GestureDetector(
            onTap: () {
              decreaseFontSize();
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(top: 13, bottom: 13, left: 6),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(2),
                    bottomRight: Radius.circular(2)),
                color: const Color(0xffccccff).withOpacity(0.6),
              ),
              child: const Icon(Icons.remove),
            ),
          ),
          IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              icon: const Icon(
                Icons.list,
              ))
        ],
        centerTitle: false,
      ),
      body: Container(
          padding: const EdgeInsets.all(15.0),
          child: GetBuilder<EditorialDetailController>(
            init: EditorialDetailController(),
            builder: (_controller) {
              if (_controller.loading.value) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: Lottie.asset(
                      "assets/animations/loader.json",
                      height: MediaQuery.of(context).size.height * 0.14,
                    ),
                  ),
                );
              } else {
                if (_controller
                        .editorials.value.editorialDetails!.description !=
                    null) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CommonTextViewWidget(
                                      text: _controller.editorials.value
                                          .editorialDetails!.title
                                          .toString(),
                                      color: colorPrimary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      editable = !editable;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration: Duration(seconds: 2),
                                            content: CommonTextViewWidget(
                                                text: editable
                                                    ? "Reading along text enable"
                                                    : "Reading along text disable")));
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(5.adaptSize),
                                      decoration: BoxDecoration(
                                          color:
                                              editable ? purplegrColor : white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                offset: Offset(-2, 3),
                                                spreadRadius: 3,
                                                blurRadius: 3)
                                          ]),
                                      child: Icon(
                                        Icons.edit,
                                        color: editable ? white : purpleColor,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              padding: const EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                                child: CachedNetworkImage(
                                  imageUrl: _controller.editorials.value
                                      .editorialDetails!.image!,
                                  placeholder: (context, url) => Container(
                                    child: Image.asset(
                                        "assets/img/noimage.png",
                                        fit: BoxFit.cover),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: colorPrimary,
                                        height: context.height,
                                        width: context.width,
                                        child: Image.asset("assets/img/noimage.png",
                                            fit: BoxFit.cover),
                                      ),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: blackColor,
                                          size: 8.adaptSize,
                                        ),
                                        Icon(
                                          Icons.arrow_back_ios,
                                          color: blackColor,
                                          size: 8.adaptSize,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        CommonTextViewWidget(
                                          text: "Swipe",
                                          color: purpleColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      readingData != null
                                          ? GestureDetector(
                                              onTap: () {
                                                setReadingData(
                                                    widget.editorial_id, null);
                                                for (int i = 0;
                                                    i <
                                                        _controller
                                                            .descritionColorlist
                                                            .length;
                                                    i++) {
                                                  setState(() {
                                                    _controller
                                                        .descritionColorlist[i]
                                                        .selected = false;
                                                  });
                                                }
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration: Duration(
                                                            seconds: 2),
                                                        content:
                                                            CommonTextViewWidget(
                                                                text:
                                                                    "All data removed")));
                                              },
                                              child: Container(
                                                  padding:
                                                       EdgeInsets.all(8.adaptSize),
                                                  decoration: BoxDecoration(
                                                      color: editable
                                                          ? purplegrColor
                                                          : white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            offset:
                                                                Offset(-2, 3),
                                                            spreadRadius: 3,
                                                            blurRadius: 3)
                                                      ]),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: editable
                                                        ? white
                                                        : purpleColor,
                                                  )),
                                            )
                                          : SizedBox(),
                                      _controller.editorials.value
                                              .editorialDetails!.pdf!.isNotEmpty
                                          ? downloadStart == true
                                              ? Container(
                                                  height: 20.adaptSize,
                                                  width: 20.adaptSize,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1.4,
                                                    color: lightYellowColor,
                                                  ),
                                                )
                                              : Align(
                                                  alignment: Alignment.topRight,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      /// for downloading the pdf on tap
                                                      _download(_controller
                                                          .editorials
                                                          .value
                                                          .editorialDetails!
                                                          .pdf![0]
                                                          .file!);
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icon/downloadicon.svg",
                                                        ),
                                                        CommonTextViewWidget(
                                                            text: "PDF")
                                                      ],
                                                    ),
                                                  ),
                                                )
                                          : const SizedBox(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(children: <InlineSpan>[
                                for (int i = 0;
                                    i < _controller.descritionColorlist.length;
                                    i++) ...[
                                  TextSpan(
                                      text:
                                          "${_controller.descritionColorlist[i].word} ",
                                      style: TextStyle(
                                          wordSpacing: 10.0,
                                          backgroundColor: _controller
                                                  .descritionColorlist[i]
                                                  .selected
                                              ? Colors.yellow
                                              : Colors.transparent,
                                          color: _controller
                                                      .descritionColorlist[i]
                                                      .status ==
                                                  true
                                              ? const Color(0XFF1BC169)
                                              : AdaptiveTheme.of(context)
                                                      .mode
                                                      .isDark
                                                  ? whiteColor
                                                  : blackColor,
                                          fontSize: custFontSize.fSize),
                                      recognizer:
                                          _controller.descritionColorlist[i]
                                                      .status ==
                                                  true
                                              ? (TapGestureRecognizer()
                                                ..onTap = () {
                                                  setState(() {});
                                                  _controller.wordMeaning(
                                                      word: _controller
                                                          .descritionColorlist[
                                                              i]
                                                          .word,
                                                      eId: widget.editorial_id
                                                          .toString());
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            content: Obx(() {
                                                              if (_controller
                                                                      .meaningLoading
                                                                      .value ==
                                                                  true) {
                                                                return Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          darkGreyColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                  height: 30,
                                                                  // width: 20,
                                                                  child: Lottie
                                                                      .asset(
                                                                    "assets/animations/loader.json",
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.08,
                                                                  ),
                                                                );
                                                              } else if (_controller
                                                                      .meaning
                                                                      .value
                                                                      .vocab ==
                                                                  null) {
                                                                return Container(
                                                                  // height: 200,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          darkGreyColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                  child: CommonTextViewWidget(
                                                                      text:
                                                                          "No meaning available",
                                                                      fontSize:
                                                                          custFontSize.fSize,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color:
                                                                          whiteColor),
                                                                );
                                                              } else {
                                                                return Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          darkGreyColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              _speak(_controller.meaning.value.word.toString());
                                                                            },
                                                                            child: CircleAvatar(
                                                                              radius: 23,
                                                                              backgroundColor: purpleColor,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Icon(
                                                                                  Icons.volume_up_outlined,
                                                                                  color: whiteColor,
                                                                                ),
                                                                              ),
                                                                            )),
                                                                      ),
                                                                      CommonTextViewWidget(
                                                                          text:
                                                                              "${_controller.meaning.value.word.toString()} :${_htmlConverter.parseHtmlString(controller.meaning.value.vocab!.meaning!)} ",
                                                                          fontSize:
                                                                              custFontSize.fSize,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              whiteColor.withOpacity(0.8)),
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                            }));
                                                      });
                                                })
                                              : (LongPressGestureRecognizer()
                                                ..onLongPress = () {
                                                  setState(() {
                                                    if (editable) {
                                                      if (startingPoint == -1) {
                                                        startingPoint = i;
                                                        _controller
                                                            .descritionColorlist[
                                                                startingPoint]
                                                            .selected = true;

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content:
                                                                    CommonTextViewWidget(
                                                                        text:
                                                                            "Now Select the end of the bookmark")));
                                                      } else {
                                                        endingPoint = i;

                                                        for (int j =
                                                                startingPoint;
                                                            j <= endingPoint;
                                                            j++) {
                                                          if (_controller
                                                                      .descritionColorlist[
                                                                          startingPoint]
                                                                      .selected ==
                                                                  true &&
                                                              _controller
                                                                      .descritionColorlist[
                                                                          endingPoint]
                                                                      .selected ==
                                                                  true) {
                                                            startingPoint =
                                                                startingPoint +
                                                                    1;
                                                            _controller
                                                                .descritionColorlist[
                                                                    j]
                                                                .selected = false;
                                                          } else {
                                                            _controller
                                                                .descritionColorlist[
                                                                    j]
                                                                .selected = true;
                                                          }
                                                        }

                                                        startingPoint = -1;

                                                        /// setting the selected editorial data to cache
                                                        setReadingData(
                                                            widget.editorial_id,
                                                            jsonEncode(EditorialDescription
                                                                .listToJson(
                                                                    _controller
                                                                        .descritionColorlist)));
                                                      }
                                                    }
                                                  });
                                                })),
                                ]
                              ]),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.0),
                            ExamButtonWidget(
                              editorialDetails:
                                  controller.editorials.value.editorialDetails!,
                            ),
                            SizedBox(height: context.height * 0.2),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _controller.editorials.value.editorialDetails!
                                .audio!.isNotEmpty
                            ? const EditorialAudioPlayer()
                            : const Text(""),
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: CommonTextViewWidget(text: "NO DATA NOW!!"),
                  );
                }
              }
            },
          )),
    );
  }

  FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setVolume(5);
    await flutterTts.setSpeechRate(0.4);

    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }
}
