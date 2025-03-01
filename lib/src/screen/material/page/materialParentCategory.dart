import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/material/controller/materialController.dart';
import 'package:english_madhyam/src/skeletonView/gridViewSkeleton.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../routes/my_constant.dart';
import '../../../../utils/ui_helper.dart';
import '../../../utils/colors/colors.dart';
import '../../../widgets/common_textview_widget.dart';
import 'material_child_list.dart';


class MaterialParentCategory extends GetView<MaterialController> {
  final String parentcateId;
  final bool? isSavedQuestions;

  MaterialParentCategory({
    Key? key,
    required this.parentcateId,
    this.isSavedQuestions,
  }) : super(key: key);

  final ScrollController scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
  GlobalKey<RefreshIndicatorState>();
  final MaterialController _materialController = Get.find();

  // Refreshes the material category data
  Future<void> _onRefresh() async {
    _materialController.getMaterialCategory(
      parentcateId,
    );
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const ToolbarTitle(title: 'Reading Category'),
      ),
      body: GetX<MaterialController>(
        builder: (_controller) {
          return Stack(
            children: [
              RefreshIndicator(
                key: _refreshKey,
                onRefresh: _onRefresh,
                child: Skeleton(
                 // themeMode: ThemeMode.light,
                  isLoading: _controller.isFirstLoadRunning.value,
                  skeleton: const GridViewSkeleton(),
                  child: _buildGridView(context),
                ),
              ),
              _buildProgressEmptyWidget(_controller.materialCategoryList),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    return _materialController.materialCategoryList.isEmpty
        ? _buildNoDataWidget(context)
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: _materialController.materialCategoryList.length,
        itemBuilder: (context, index) {
          final data = _materialController.materialCategoryList[index];
          return InkWell(
            onTap: () async {
              var subCateId = data.id.toString();
              var name = data.name.toString();

              await controller.getMaterialList(1, subCateId);
              Get.to(MaterialChilList(subCateId: subCateId, name: name));
            },
            child: _buildCategoryWidget(index, data, context),
          );
        },
      ),
    );
  }

  Widget _buildNoDataWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _onRefresh,
            child: Icon(
              Icons.refresh,
              size: context.height * 0.08,
            ),
          ),
           CommonTextViewWidget(text: "Data not found."),
        ],
      ),
    );
  }

  Widget _buildProgressEmptyWidget(List list) {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : list.isEmpty && !controller.isFirstLoadRunning.value
          ? ShowLoadingPage(refreshIndicatorKey: _refreshKey)
          : const SizedBox(),
    );
  }

  Widget _buildCategoryWidget(int index, dynamic data, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration:UiHelper.gridCommonDecoration(index: index,context: context)
    ,
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
                    data.image ??
                        MyConstant.banner_image,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 90.h),
          const SizedBox(height: 5),
          Positioned(bottom: 3,left: 0,right: 0,child: CommonTextViewWidget(
            text: data.name ?? "",
            maxLine: 2,
            align: TextAlign.center,
            fontSize: 14,
            color: colorSecondary,
            fontWeight: FontWeight.w500,
          ),)
        ],
      ),
    );
  }
}
