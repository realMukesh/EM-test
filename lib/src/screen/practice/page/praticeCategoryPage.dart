import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import 'package:english_madhyam/src/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeController.dart';
import 'package:english_madhyam/src/screen/practice/page/praticeTabListPage.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../utils/ui_helper.dart';
import '../../../utils/colors/colors.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../../widgets/loading.dart';
import '../../../../routes/my_constant.dart';
import '../../../custom/toolbarTitle.dart';
import '../../../skeletonView/examSkeletonList.dart';

class PraticeCategoryPage extends GetView<PraticeController> {
  final bool? isSavedQuestions;
  final String parentcateId;

  PraticeCategoryPage({
    Key? key,
    required this.parentcateId,
    this.isSavedQuestions,
  }) : super(key: key);

  final PraticeController _controller = Get.find();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  // Loads data from the API
  void _loadData() async {
    _controller.getPracticeCategory(
      parentcateId,
    );
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const ToolbarTitle(
          title: 'Practice Category',
        ),
      ),
      body: GetX<PraticeController>(
        builder: (_) {
          return Column(
            children: [
              Expanded(
                child: _loadPraticeCategory(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _loadPraticeCategory(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: Stack(
        children: [
          RefreshIndicator(
            key: _refreshKey,
            onRefresh: () async {
              await Future.delayed(
                const Duration(seconds: 1),
                _loadData,
              );
            },
            child: Skeleton(
              //themeMode: ThemeMode.light,
              isLoading: _controller.isFirstLoadRunning.value,
              skeleton: const ListAgendaSkeleton(),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _controller.practiceCategoryList.length,
                itemBuilder: (context, index) {
                  final practiceQuizData =
                      _controller.practiceCategoryList[index];
                  return _buildCategoryItem(practiceQuizData, index,context);
                },
              ),
            ),
          ),
          _progressEmptyWidget(_controller.practiceCategoryList),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(dynamic practiceQuizData, int index, BuildContext context) {
    return InkWell(
      onTap: () async {
        _controller.getPracticeChildListData(
          subCategoryId: practiceQuizData.id.toString(),
          isRefresh: false,
          isSavedQuestions: isSavedQuestions ?? false,
        );
        Get.to(PracticeListTabPage(
          subCategoryId: practiceQuizData.id.toString(),
          isSavedQuestions: isSavedQuestions ?? false,
        ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: 7.adaptSize, horizontal: 8.adaptSize),
        padding: EdgeInsets.all(12.adaptSize),
        decoration: UiHelper.gridCommonDecoration(index: index,context: context),
        child: ListTile(
          leading: CustomSqureImageWidget(
            imageUrl: practiceQuizData.image ?? MyConstant.banner_image,
            size: 70.adaptSize,
          ),
          title: CommonTextViewWidget(
            text: practiceQuizData.name!.length > 20
                ? "${practiceQuizData.name!.substring(0, 18)}.."
                : practiceQuizData.name!,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: colorSecondary,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextViewWidgetDarkMode(
                text: "English",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorGray,
              ),
            ],
          ),
          trailing: Icon(
            color: colorPrimary,
            Icons.arrow_forward_ios,
            size: 15.adaptSize,
          ),
        ),
      ),
    );
  }

  Widget _progressEmptyWidget(List list) {
    return Center(
      child: _controller.isLoading.value
          ? const Loading()
          : list.isEmpty && !_controller.isFirstLoadRunning.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshKey)
              : const SizedBox(),
    );
  }
}
