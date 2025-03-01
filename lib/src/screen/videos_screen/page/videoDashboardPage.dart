import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/src/screen/videos_screen/model/video_cat_model.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import 'package:english_madhyam/src/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/screen/videos_screen/controller/videoController.dart';
import 'package:english_madhyam/src/screen/videos_screen/page/videoListPage.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../routes/my_constant.dart';
import '../../../../utils/ui_helper.dart';
import '../../../utils/colors/colors.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../../widgets/loading.dart';
import '../../../custom/toolbarTitle.dart';
import '../../profile/controller/profile_controllers.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';

class VideoDashboardPage extends StatefulWidget {
  VideoDashboardPage({Key? key}) : super(key: key);

  @override
  State<VideoDashboardPage> createState() => _VideoDashboardPageState();
}

class _VideoDashboardPageState extends State<VideoDashboardPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  final VideoController _videoController = Get.put(VideoController());
  final ProfileControllers _profileController = Get.find();

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> _refreshPaidKey =
      GlobalKey<RefreshIndicatorState>();

  void loadData() {
    _videoController.initApiCall();
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: const ToolbarTitle(
            title: 'Videos',
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: GetX<VideoController>(
            builder: (controller) {
              return Column(
                children: [
                  buildTabWidget(),
                  Expanded(
                    child: TabBarView(
                        controller: tabController,
                        children: [loadFreeCategory(), loadPaidCategory()]),
                  )
                ],
              );
            },
          ),
        ));
  }

  Widget buildTabWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: tabController,
          unselectedLabelStyle:  TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.w500),
          labelStyle:  TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.w500,
              color: white),
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: purpleColor),
          tabs: const [
            Tab(
              text: "Free",
            ),
            Tab(
              text: "Paid",
            ),
          ]),
    );
  }

  loadFreeCategory() {
    return RefreshIndicator(
        key: _refreshKey,
        onRefresh: () async {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              loadData();
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
          child: Stack(
            children: [
              GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 4),
                  itemCount: _videoController.freeVideoList.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return loadVideoItemData(
                        _videoController.freeVideoList[index], index, false);
                  }),
              _progressEmptyWidget(false, _videoController.freeVideoList),
            ],
          ),
        ));
  }

  loadPaidCategory() {
    return RefreshIndicator(
      key: _refreshPaidKey,
      onRefresh: () async {
        return Future.delayed(
          const Duration(seconds: 1),
          () {
            loadData();
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
        child: Stack(
          children: [
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 4),
                itemCount: _videoController.paidVideoList.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return loadVideoItemData(
                      _videoController.paidVideoList[index], index, true);
                }),
            _progressEmptyWidget(true, _videoController.paidVideoList),
          ],
        ),
      ),
    );
  }

  loadVideoItemData(VideoData videoData, index, bool isPaid) {
    return InkWell(
      onTap: () async {
        if (isPaid) {
          if (_profileController.profileGet.value.user != null &&
              _profileController.isSubscriptionActive &&
              isPaid) {
            var result =
                await _videoController.videoDetail(id: videoData.id.toString());
            if (result) {
              Get.to(() => VideoListPage(
                    id: videoData.id.toString(),
                    title: videoData.name ?? "",
                  ));
            }
          } else {
            if (Platform.isAndroid) {
              Get.toNamed(ChoosePlanDetails.routeName);
            } else {
              Get.to(() => InAppPlanDetail());
            }
          }
        } else {
          var result =
              await _videoController.videoDetail(id: videoData.id.toString());
          if (result) {
            Get.to(() => VideoListPage(
                  id: videoData.id.toString(),
                  title: videoData.name ?? "",
                ));
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration: UiHelper.gridCommonDecoration(index: index,context: context),
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: greyColor.withOpacity(0.7),
                      blurRadius: 5,
                      spreadRadius: 0.0,
                      offset: const Offset(-3, 3),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(
                      videoData.image ??
                          MyConstant.banner_image,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 90.h),
            const SizedBox(height: 5),
            Positioned(bottom: 3,left: 0,right: 0,child: CommonTextViewWidget(
              text: videoData.name ?? "",
              maxLine: 2,
              align: TextAlign.center,
              fontSize: 14,
              color: colorSecondary,
              fontWeight: FontWeight.w500,
            ),)
          ],
        ),
      ),
    );
  }

  Widget _progressEmptyWidget(isPaid, list) {
    return Center(
      child: _videoController.loading.value
          ? const Loading()
          : list.isEmpty
              ? ShowLoadingPage(
                  refreshIndicatorKey: isPaid ? _refreshPaidKey : _refreshKey)
              : const SizedBox(),
    );
  }
}
