import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import 'package:english_madhyam/src/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/screen/leader_Board/controller/leaderboardController.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/ui_helper.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../../widgets/loading.dart';
import '../../../custom/toolbarTitle.dart';
import '../model/LeadboardModel.dart';

class LeaderboardPage extends GetView<LeaderboardController> {
  LeaderboardPage({Key? key}) : super(key: key);

  static const routeName = "/LeaderboardPage";

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final leaderboardController = Get.put(LeaderboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const ToolbarTitle(
          title: "Leader Board",
          color: Colors.black,
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(12),
          child: GetX<LeaderboardController>(builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      color: Colors.white,
                      backgroundColor: colorPrimary,
                      strokeWidth: 4.0,
                      triggerMode: RefreshIndicatorTriggerMode.anywhere,
                      onRefresh: () async {
                        return Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            controller.getLeaderboardApi(isRefresh: true);
                          },
                        );
                      },
                      child: buildListView(context),
                    )),
                  ],
                ),
                // when the first load function is running
                _progressEmptyWidget()
              ],
            );
          })),
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.loading.value
          ? const Loading()
          : !controller.isFirstLoadRunning.value &&
                  controller.leaderBoardData.isEmpty
              ? ShowLoadingPage(refreshIndicatorKey: _refreshIndicatorKey)
              : const SizedBox(),
    );
  }

  Widget buildListView(BuildContext context) {
    return Skeleton(
        //themeMode: ThemeMode.light,
        isLoading: controller.isFirstLoadRunning.value,
        skeleton: SkeletonListView(),
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 6,
              child: Container(
                color: Colors.transparent,
              ),
            );
          },
          itemCount: controller.leaderBoardData.length,
          itemBuilder: (context, index) {
            Leadboard leadboard = controller.leaderBoardData[index];

            return Container(
              margin: const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 0),
              padding: const EdgeInsets.all(10),
              decoration: UiHelper.pdfDecoration(context, index),
              child: ListTile(
                leading:
                    avtarBuild(shortName: '# ${leadboard.rank ?? ""}', url: ""),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextViewWidget(
                      text: leadboard.name.toString().capitalize ?? "",
                      color: accentColor,
                    ),
                    CommonTextViewWidget(
                      text:
                          "Marks: ${leadboard.marks ?? ""}/${leadboard.totalMarks ?? ""}",
                    ),
                  ],
                ),
                trailing: SizedBox(
                  width: 80.adaptSize,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer),
                      const SizedBox(width: 12,),
                      CommonTextViewWidget(
                        text: leadboard.time.toString() ?? "",
                      ),
                    ],
                  ),
                )

              ),
            );
          },
        ));
  }

  Widget avtarBuild({url, shortName}) {
    return url.isNotEmpty
        ? FittedBox(
            fit: BoxFit
                .fill, // the picture will acquire all of the parent space.
            child: SizedBox(
                height: 70,
                width: 70,
                child: CircleAvatar(backgroundImage: NetworkImage(url))),
          )
        : Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: colorPrimary,
            ),
            child: Center(
                child: CommonTextViewWidgetDarkMode(
              text: shortName,
              color: white,
              align: TextAlign.center,
            )),
          );
  }

  Future<void> _launchInWebViewWithoutDomStorage(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      throw 'Could not launch $url';
    }
  }
}
