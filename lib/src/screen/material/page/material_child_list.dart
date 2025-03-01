import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/material/controller/materialController.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';
import 'package:english_madhyam/src/screen/material/page/materialListTabPage.dart';
import 'package:english_madhyam/src/skeletonView/gridViewSkeleton.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../routes/my_constant.dart';
import '../../../../utils/ui_helper.dart';
import '../../../utils/colors/colors.dart';
import '../../../widgets/common_textview_widget.dart';

class MaterialChilList extends GetView<MaterialController> {
  String subCateId = "";
  String name = "";
  MaterialChilList({Key? key, required this.subCateId, required this.name})
      : super(key: key);

  late TabController tabController;
  ScrollController scrollController = ScrollController();
  final ProfileControllers _profileController = Get.find();

  bool isLoading = false;
  int page = 1;
  int freepage = 1;

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final MaterialController materialController = Get.find();

  void _onRefresh() async {
    // monitor network fetch
    _profileController.getProfileData();
    materialController.getMaterialList(page, subCateId);
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: purpleColor.withOpacity(0.15),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        title: ToolbarTitle(
          title: name ?? 'Editorial',
        ),
      ),
      body: GetX<MaterialController>(builder: (controller) {
        return Stack(
          children: [
            RefreshIndicator(
              key: _refreshKey,
              onRefresh: () async {
                return Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    _onRefresh();
                  },
                );
              },
              child: materialListView(context),
            ),
            _progressEmptyWidget(false, controller.materialChildList),
          ],
        );
      }),
    );
  }

  Widget materialListView(BuildContext context) {
    return Skeleton(
        isLoading: controller.isFirstLoadRunning.value,
        // themeMode: ThemeMode.light,
        skeleton: const GridViewSkeleton(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7),
              controller: materialController.freeScrollController,
              itemCount: materialController.materialChildList.length,
              itemBuilder: (BuildContext ctx, int index) {
                if (index == materialController.materialChildList.length - 1 &&
                    materialController.isMoreDataAvailable.value == true) {
                  return const Center(child: CircularProgressIndicator());
                }
                return InkWell(
                  onTap: () {
                    Get.to(() => MaterialListTabPage(
                          catid: materialController.materialChildList[index].id
                              .toString(),
                          subCateId: subCateId,
                          type: materialController.materialChildList[index].type
                              .toString(),
                          title:
                              materialController.materialChildList[index].name!,
                        ));
                  },
                  child: buildCategoryWidget(index,
                      materialController.materialChildList[index], context),
                );
              }),
        ));
  }

  Widget _progressEmptyWidget(isMock, list) {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : list.isEmpty && !controller.isFirstLoadRunning.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshKey)
              : const SizedBox(),
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Container(
        padding: const EdgeInsets.all(30),
        color: homeTopColor,
        child: Stack(
          children: [
            Column(
              children: [
                CommonTextViewWidget(
                    fontSize: 24,
                    text:
                        "${materialController.materialChildList.length} Total Editorials"),
                CommonTextViewWidget(
                    fontSize: 24,
                    text:
                        "${materialController.materialChildList.length} Free Editorials")
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(
                  Icons.language,
                  color: colorPrimary,
                ),
                title: CommonTextViewWidget(
                  text: "Available In English",
                  fontSize: 18,
                  color: colorPrimary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCategoryWidget(index, data, context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: UiHelper.gridCommonDecoration(index: index, context: context),
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
                    data.image ?? MyConstant.banner_image,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 90.h),
          const SizedBox(height: 5),
          Positioned(
            bottom: 3,
            left: 0,
            right: 0,
            child: CommonTextViewWidget(
              text: data.name ?? "",
              maxLine: 2,
              align: TextAlign.center,
              fontSize: 14,
              color: colorSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: data.type != null && data.type == 1
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.star,
                          color: colorPrimary,
                          size: 12.fSize,
                        ),
                      ),
                    )
                  : const SizedBox())
        ],
      ),
    );
  }
}
