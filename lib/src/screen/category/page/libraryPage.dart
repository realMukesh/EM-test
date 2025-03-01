import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/screen/category/controller/libraryController.dart';
import 'package:english_madhyam/src/screen/favorite/controller/favoriteController.dart';
import 'package:english_madhyam/src/screen/practice/page/praticeCategoryPage.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletons/skeletons.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../../widgets/loading.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';

import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import '../../../../routes/my_constant.dart';
import '../../../custom/toolbarTitle.dart';
import '../../../skeletonView/gridViewSkeleton.dart';
import '../../../utils/colors/colors.dart';
import '../../material/controller/materialController.dart';
import '../../material/page/materialParentCategory.dart';
import '../../practice/controller/praticeController.dart';

class LibraryDashboard extends GetView<LibraryController> {
  LibraryDashboard({Key? key}) : super(key: key);

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  

  LibraryController controller = Get.put(LibraryController());

  // Handles the refresh action
  void _onRefresh() async {
    controller.getParentCategory(
      isRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const ToolbarTitle(
          title: "Library",
        ),
      ),
      body: GetX<LibraryController>(
        builder: (controller) {
          return Container(
            width: context.width,
            height: context.height,
            padding: const EdgeInsets.all(12),
            child: Stack(
              children: [
                RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: () async {
                    await Future.delayed(
                      const Duration(seconds: 1),
                      _onRefresh,
                    );
                  },
                  child: Skeleton(
                    isLoading: controller.loading.value,
                    skeleton: const GridViewSkeleton(),
                    child: _buildMenuList(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Builds the grid menu list
  Widget _buildMenuList(BuildContext context) {
    return GetX<LibraryController>(
      builder: (controller) {
        if (controller.parentCategories.isEmpty) {
          return ShowLoadingPage(
            refreshIndicatorKey: _refreshKey,
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.parentCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) => _buildChildMenuBody(index, context),
        );
      },
    );
  }

  // Builds each grid item
  Widget _buildChildMenuBody(int index, BuildContext context) {
    return InkWell(
      onTap: () => _handleMenuTap(index),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(8),
        decoration:UiHelper.gridCommonDecoration(index: index,context: context),
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
                    controller.parentCategories[index].image ??
                        MyConstant.banner_image,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 90.h),
            const SizedBox(height: 5),
            Positioned(bottom: 3,left: 0,right: 0,child: CommonTextViewWidget(
              text: controller.parentCategories[index].name ?? "",
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

  // Handles the menu item tap logic
  void _handleMenuTap(int index) {
    final parentCategory = controller.parentCategories[index];
    if (parentCategory.id == 1) {
      controller.materialController.getMaterialCategory(
        parentCategory.id.toString()
      );
      Get.to(
        MaterialParentCategory(
          parentcateId: parentCategory.id.toString(),
        ),
      );
    } else {
      controller.praticeController.getPracticeCategory(
        parentCategory.id.toString()
      );
      Get.to(
        PraticeCategoryPage(
          parentcateId: parentCategory.id.toString(),
        ),
      );
    }
  }
}
