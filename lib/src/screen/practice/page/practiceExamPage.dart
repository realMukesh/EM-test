import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/exam/controller/examDetailController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import '../../../custom/loadMoreItem.dart';
import '../../../skeletonView/examSkeletonList.dart';
import '../../../widgets/comm_exam_list_widget.dart';
import '../../exam/controller/examListController.dart';

class PracticeExamListPage extends GetView<ExamListController> {
  final String title;
  final String id;
  final bool saveQuestion;
  // Use constructor initializer list to improve performance
  PracticeExamListPage({
    Key? key,
    required this.title,
    required this.id,
    required this.saveQuestion,
  }) : super(key: key);

  // Initialize controllers directly without creating multiple instances
  final ExamDetailController praticeExamDetailController =
      Get.put(ExamDetailController());

  final GlobalKey<RefreshIndicatorState> _refreshTab1Key =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        title: ToolbarTitle(title: title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: GetX<ExamListController>(
          builder: (controller) {
            return Container(
              color: Colors.transparent,
              width: context.width,
              padding: const EdgeInsets.all(12),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          key: _refreshTab1Key,
                          onRefresh: () => Future.delayed(
                            const Duration(seconds: 1),
                            () async => getExamList(isRefresh: true),
                          ),
                          child: buildChildList(context),
                        ),
                      ),
                      // Only show loading indicator when it's actually loading
                      if (controller.isLoadMoreRunning.value)
                        const LoadMoreLoading(),
                    ],
                  ),
                  _progressEmptyWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildChildList(BuildContext context) {
    return Skeleton(
      ///themeMode: ThemeMode.light,
      isLoading: controller.isFirstLoadRunning.value,
      skeleton: const ListAgendaSkeleton(),
      child: ListView.separated(
        controller: controller.scrollCtr,
        itemCount: controller.praticeExamList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) => buildListViewBody(
            controller.praticeExamList[index], context, index),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 12,
          );
        },
      ),
    );
  }

  Widget buildListViewBody(data, BuildContext context, index) {
    return CommExamListWidget(
        title: title,
        index: index,
        cateId: id,
        data: data,
        isSavedQuestion: saveQuestion);
  }

  void getExamList({required bool isRefresh}) {
    controller.getExamListByCategory(
      cat: id,
      isRefresh: isRefresh,
      saveQuestionExamList: saveQuestion,
    );
  }

  Widget _progressEmptyWidget() {
    return Center(
      child: controller.isLoading.value
          ? const Loading()
          : controller.praticeExamList.isEmpty &&
                  !controller.isFirstLoadRunning.value
              ? ShowLoadingPage(refreshIndicatorKey: _refreshTab1Key)
              : const SizedBox(),
    );
  }
}
