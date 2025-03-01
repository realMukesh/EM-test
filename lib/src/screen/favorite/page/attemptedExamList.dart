import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/favorite/controller/attemptedExamController.dart';
import 'package:english_madhyam/src/screen/favorite/model/attemptedExamData.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeController.dart';
import 'package:english_madhyam/src/screen/practice/page/practiceExamPage.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../utils/ui_helper.dart';
import '../../../skeletonView/examSkeletonList.dart';
import '../../../utils/progress_bar_report/progress_bar.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../exam/controller/examListController.dart';
import '../../practice/widget/performance_report.dart';

class AttemptedExamList extends StatefulWidget {
  const AttemptedExamList({Key? key}) : super(key: key);

  @override
  State<AttemptedExamList> createState() => _AttemptedExamListState();
}

class _AttemptedExamListState extends State<AttemptedExamList> {
  final AttemptedExamController _controller =
      Get.put(AttemptedExamController());

  final ExamListController _praticeExamListController =
      Get.put(ExamListController());

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  void loadData() async {
    _controller.getAttemptedExam(isRefresh: true);
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
          title: 'Attempted Exam',
        ),
      ),
      body: GetX<PraticeController>(
        builder: (_controller) {
          return getMockTestCategories();
        },
      ),
    );
  }

  Widget getMockTestCategories() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
      child: Stack(
        children: [
          RefreshIndicator(
              key: _refreshKey,
              onRefresh: () async {
                return Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    loadData();
                  },
                );
              },
              child: Skeleton(
                isLoading: _controller.isFirstLoadRunning.value,
                skeleton: const ListAgendaSkeleton(),
                child: ListView.builder(
                    controller: _controller.preScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _controller.previousExamList.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      var praticeQuizData = _controller.previousExamList[index];
                      return buildCategoryItem(praticeQuizData, false, index);
                    }),
              )),
          _progressEmptyWidget(true, _controller.previousExamList)
        ],
      ),
    );
  }

  Widget buildCategoryItem(ExamParent examData, isPaid, index) {
    return Container(
      margin: const EdgeInsets.only(left: 0, right: 0, top: 15, bottom: 0),
      padding: const EdgeInsets.all(10),
      decoration: UiHelper.pdfDecoration(context, index % 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Row(
              children: [
                examData.categoryDetails?.type == 0
                    ? freeWidget()
                    : paidWidget(),
                const SizedBox(
                  width: 6,
                ),
                Icon(
                  Icons.category,
                  color: greyColor,
                  size: 15,
                ),
                const SizedBox(
                  width: 6,
                ),
                CommonTextViewWidget(
                  text: examData.categoryDetails?.name ?? "",
                  color: colorSecondary,
                  fontSize: 12,
                  align: TextAlign.start,
                )
              ],
            ),
            subtitle: CommonTextViewWidget(
              text: examData.examDetails?.title ?? "",
              color: colorSecondary,
              fontSize: 16,
              align: TextAlign.start,
            ),
          ),
          attemptedWidget(examData, context)
        ],
      ),
    );
  }

  Widget freeWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: Colors.blue),
      child: CommonTextViewWidget(
        text: "FREE",
        color: white,
        fontSize: 12,
      ),
    );
  }

  Widget paidWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          color: Colors.green),
      child: CommonTextViewWidget(
        text: "PAID",
        color: white,
        fontSize: 12,
      ),
    );
  }

  Widget attemptedWidget(ExamParent data, BuildContext contxt) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonTextViewWidget(
                  text:
                      "${data?.marks.toString()}/${data?.totalMarks.toString()} Score",
                  color: colorSecondary,
                ),
                TextButton(
                    onPressed: () {
                      openExamDetailPage(data);
                    },
                    child: CommonTextViewWidget(
                      text: "View Result",
                      color: Colors.blue,
                    ))
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            progressWidget(data, contxt),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      openDetailPage(
                          name: data.categoryDetails?.name ?? "",
                          id: data.categoryDetails?.id);
                    },
                    child: CommonTextViewWidget(
                      text: "More test",
                      color: Colors.blue,
                    )),
                CommonTextViewWidget(
                  text:
                      "Attempted on ${UiHelper.getFormattedChatDate(date: data.createdAt)}",
                  fontSize: 14,
                ),
              ],
            )
          ],
        ));
  }

  Widget progressWidget(ExamParent data, BuildContext contxt) {
    int incorrectQuestion = data.incorrectQuestion ?? 0;

    int correctQuestion = data.correctQuestion ?? 0;

    int totalQuestion = data.totalQuestion ?? 0;

    double redSize =
        double.parse((incorrectQuestion / totalQuestion).toString());
    double greenSize =
        double.parse((correctQuestion / totalQuestion).toString());

    if (redSize.toString() == "NaN") {
      redSize = 0.0;
    }
    if (greenSize.toString() == "NaN") {
      greenSize = 0.0;
    }

    return SizedBox(
      height: 10,
      width: contxt.width * .85,
      child: ProgressBar(
          redSize: redSize,
          greenSize: greenSize),
    );
  }

  openDetailPage({name, id}) {
    _praticeExamListController.getExamListByCategory(
        cat: id.toString(), isRefresh: false, saveQuestionExamList: false);
    Get.to(
      () => PracticeExamListPage(
        title: name,
        id: id.toString(),
        saveQuestion: false,
      ),
    );
  }

  Widget _progressEmptyWidget(isMock, list) {
    return Center(
      child: _controller.isLoading.value
          ? const Loading()
          : list.isEmpty && !_controller.isFirstLoadRunning.value
              ? ShowLoadingPage(
                  refreshIndicatorKey: isMock ? _refreshKey : _refreshKey)
              : const SizedBox(),
    );
  }

  openExamDetailPage(ExamParent data) {
    Get.toNamed(PerformanceReportPage.routeName, arguments: {
      "exam_id": data.examId.toString(),
      "title": data.examDetails?.title.toString(),
      "route": 1,
      "cate_id": data.categoryDetails!.id!.toString()
    });
  }
}
