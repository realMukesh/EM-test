import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/screen/favorite/page/attemptedExamList.dart';
import 'package:english_madhyam/src/screen/home/controller/home_controller.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/editorials_page.dart';
import 'package:english_madhyam/src/screen/home/achievers.dart';
import 'package:english_madhyam/src/screen/home/daily_quiz.dart';
import 'package:english_madhyam/src/screen/home/drawer_screen.dart';
import 'package:english_madhyam/src/screen/editorials_page/widgets/editorial_listView_widget.dart';
import 'package:english_madhyam/src/screen/home/refer_and_earn.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../../widgets/loading.dart';
import '../../Notification_screen/page/Notifications.dart';

class HomePage extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    controller.getHomeData();
    controller.profileControllers.getProfileData();
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerNavigation(),
      appBar: _buildAppBar(context),
      body: GetX<HomeController>(builder: (homeController) {
        return Stack(
          children: [
            SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: _buildBody(context, homeController),
              ),
            ),
            if (homeController.loading.value) const Loading(),
          ],
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 55.adaptSize,
      elevation: 0.0,
      centerTitle: false,
      title: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextViewWidget(
                text: "Hi, ${controller.name.value}",
                fontSize: 18,
                color: colorSecondary,
                fontWeight: FontWeight.w500,
              ),

              CommonTextViewWidget(
                text: controller.greeting.value,
                fontSize: 16,
                color: colorSecondary,
                fontWeight: FontWeight.normal,
              ),
            ],
          )),
      leading: IconButton(
        icon: const Icon(Icons.menu, size: 35),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        InkWell(
          onTap: () async {
            Get.toNamed(NotificationScreen.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 20),
            child: Stack(
              children: [
                SvgPicture.asset("assets/icon/bell.svg", color: colorPrimary),
                if (controller.notficationController.unread_notification > 0)
                  const Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: Icon(Icons.brightness_1,
                        size: 8.0, color: Colors.redAccent),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, HomeController homeController) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/bg.png"),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (homeController.banner.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: slider(context),
              ),
            ),
          const SizedBox(height: 12),
          if (homeController.editorialList.isNotEmpty) recentPostWidget(),
          if (homeController.examList.isNotEmpty) loadQuizData(context),
          attemptedExamWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: Achieverstake(achievers: homeController.achievers),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: InkWell(
              onTap: () => onShare(context),
              child: const RefferEarn(),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: purpleColor.withOpacity(0.13),
            child: bottom(),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget loadQuizData(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonTextViewWidget(
                text: "Daily Quiz",
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              InkWell(
                onTap: () => controller.dashboardController.changeTabIndex(1),
                child: CommonTextViewWidget(
                  text: "View All >",
                  fontSize: 18,
                  color: colorPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
                child: DailyExamWidget(
                  onBackPress: (v) => _onRefresh(),
                  quiz: controller.examList,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget recentPostWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 10),
              child: CommonTextViewWidget(
                  text: "Recent Posts",
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            InkWell(
              onTap: () => Get.to(() => EditorialsPage()),
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0, bottom: 10),
                child: CommonTextViewWidget(
                  text: "View All >",
                  color: colorPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        EditorialListViewWidget(
          type: 0,
          editorials: controller.editorialList,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget attemptedExamWidget() {
    return InkWell(
      onTap: () => Get.to(AttemptedExamList()),
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: colorPrimary,
        ),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CommonTextViewWidgetDarkMode(
              text: "Attempted Exam",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: white,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 20, color: white),
        ),
      ),
    );
  }

  Widget slider(BuildContext context) {
    final imageSliders = controller.banner.map((item) {
      return Container(
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          child: CachedNetworkImage(
            imageUrl: item.banner.toString(),
            placeholder: (context, url) =>
                Image.asset("assets/img/banner.jpeg", fit: BoxFit.cover),
            errorWidget: (context, url, error) =>
                Image.asset("assets/img/banner.jpeg", fit: BoxFit.cover),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: CarouselSlider(
            items: imageSliders,
            carouselController: controller.sliderController,
            options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 0.9,
              autoPlay: true,
              aspectRatio: 1.9,
              onPageChanged: (index, reason) =>
                  controller.bannerIndex.value = index,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: controller.banner.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => controller.sliderController.animateToPage(entry.key),
              child: Container(
                width: 6.0,
                height: 6.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gradientBlue.withOpacity(
                    controller.bannerIndex.value == entry.key ? 0.9 : 0.4,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      "Share English Madhyam App with your friends ,https://play.google.com/store/search?q=english%20madhyam&c=apps",
      subject: "Share English Madhyam App",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  Widget bottom() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatsColumn("${controller.students} +", "Students"),
          _buildStatsColumn(controller.successRate.toString(), "Success Rate"),
          _buildStatsColumn("${controller.mentors} +", "Mentors"),
        ],
      ),
    );
  }

  Widget _buildStatsColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonTextViewWidget(
          text: value,
          color: purplegrColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        CommonTextViewWidget(text: label, fontSize: 15),
      ],
    );
  }
}
