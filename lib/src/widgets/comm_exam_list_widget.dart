import 'dart:io';

import 'package:english_madhyam/src/screen/exam/model/exam_list_model.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../screen/payment/page/choose_plan_details.dart';
import '../screen/payment/page/in_app_plan_page.dart';
import '../screen/exam/controller/examDetailController.dart';
import '../screen/exam/controller/examListController.dart';
import '../screen/practice/widget/instructions.dart';
import '../screen/practice/widget/performance_report.dart';
import '../screen/profile/controller/profile_controllers.dart';
import '../utils/progress_bar_report/progress_bar.dart';
import 'common_textview_widget.dart';
import 'free_paid_widget.dart';

class CommExamListWidget extends GetView<ExamListController> {
  dynamic data;
  int index;
  bool isSavedQuestion;
  String title;
  String cateId;
  CommExamListWidget(
      {super.key,
      required this.data,
      required this.index,
      required this.isSavedQuestion,
      required this.title,
      required this.cateId});

  final ExamDetailController praticeExamDetailController =
      Get.put(ExamDetailController());
  final ProfileControllers _profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return buildListViewBody(data, context, index);
  }

  Widget buildListViewBody(data, BuildContext context, index) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: UiHelper.pdfDecoration(context, index % 6),
      child:  (data.completed == true
              ? attemptedWidget(data, context)
              : notAttemptedWidget(data, context)),
    );
  }


  Widget notAttemptedWidget(data, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.type == 1 && _profileController.isSubscriptionActive) {
          startAndResumeExam(data);
        } else if (data.type == 1 && !_profileController.isSubscriptionActive) {
          navigateToSubscriptionPage(data);
        } else {
          startAndResumeExam(data);
        }
      },
      child: Container(
          color: Colors.transparent,
          child: buildExamDetailsWidget(
              data, context, data.attempted == true ? "Pause" : "Start")),
    );
  }

  Widget attemptedWidget(ExamData data, BuildContext context) {
    return GestureDetector(
      onTap: () => viewResultPage(data),
      child: Container(
          color: Colors.transparent,
          child: buildExamDetailsWidget(data, context, "View Result")),
    );
  }

  Widget buildExamDetailsWidget(data, BuildContext context, String buttonText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextViewWidget(
          text: data.title ?? "",
          color: colorSecondary,
          fontSize: 18,
          maxLine: 3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonTextViewWidget(
                text: "${data.totalQuestions} Ques", color: colorSecondary),
            CircleAvatar(backgroundColor: greyColor, maxRadius: 2),
            CommonTextViewWidget(
                text: "${data.duration} Mins", color: colorSecondary),
            CircleAvatar(backgroundColor: greyColor, maxRadius: 2),
            CommonTextViewWidget(
                text: "${data.mark} Marks", color: colorSecondary),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FreePaidWidget(
              type: data.type,
            ),
            UiHelper.viewActionButton(buttonText),
          ],
        ),
        if (data.completed == true) progressWidget(data.examResult, context),
      ],
    );
  }

  Widget progressWidget(ExamResult data, BuildContext contxt) {
    int incorrectQuestion = data.incorrectQuestion ?? 5;

    int correctQuestion = data.correctQuestion ?? 5;

    int totalQuestion = data.totalQuestion ?? 10;

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 10,
        width: contxt.width * .85,
        child: ProgressBar(redSize: redSize, greenSize: greenSize),
      ),
    );
  }

  void startAndResumeExam(data) {
    praticeExamDetailController.getExamDetail(id: data.id);
    Get.to(() => TestInstructions(
          catTitle: title,
          examid: data.id!,
          title: data.title.toString(),
          type: 1,
        ));
  }

  void viewResultPage(data) {
    Get.toNamed(PerformanceReportPage.routeName, arguments: {
      "exam_id": data.id.toString(),
      "title": title,
      "route": 1,
      "cate_id": cateId.toString()
    });
  }

  void navigateToSubscriptionPage(data) {
    _profileController.getProfileData();
    if (Platform.isAndroid) {
      Get.toNamed(ChoosePlanDetails.routeName);
    } else {
      Get.to(() => InAppPlanDetail());
    }
  }

  void getExamList({required bool isRefresh}) {
    controller.getExamListByCategory(
      cat: cateId,
      isRefresh: isRefresh,
      saveQuestionExamList: isSavedQuestion,
    );
  }
}
