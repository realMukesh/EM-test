import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/screen/editorials_page/model/editorial_detail.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/screen/exam/controller/examDetailController.dart';
import 'package:english_madhyam/src/screen/practice/widget/instructions.dart';
import 'package:english_madhyam/src/screen/practice/widget/performance_report.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../../widgets/rounded_button.dart';

class ExamButtonWidget extends GetView<EditorialDetailController> {
  final EditorialDetails editorialDetails;

  ExamButtonWidget({required this.editorialDetails, super.key});

  final ExamDetailController quizController = Get.put(ExamDetailController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: _quizButton(),
    );
  }

  Widget _quizButton() {
    if (editorialDetails.quizAvailable != 1) {
      return const SizedBox();
    }

    String buttonText;
    VoidCallback onTap;

    if (editorialDetails.isAttempt == 0 && editorialDetails.isCompleted == 0) {
      buttonText = 'Start Quiz';
      onTap = _startQuiz;
    } else if (editorialDetails.isAttempt == 1 &&
        editorialDetails.isCompleted == 0) {
      buttonText = 'Resume Quiz';
      onTap = _resumeQuiz;
    } else {
      buttonText = 'Show Report';
      onTap = _showReport;
    }

    return RoundedButton(text: buttonText, press: onTap);
  }

  void _startQuiz() {
    if (editorialDetails.examId != null) {
      quizController.getExamDetail(id: editorialDetails.examId!);
      Get.off(() => TestInstructions(
            title: editorialDetails.title.toString(),
            type: 0,
            examid: editorialDetails.examId!,
            catTitle: "",
          ));
    } else {
      Fluttertoast.showToast(msg: "No Quiz Available");
    }
  }

  void _resumeQuiz() {
    if (editorialDetails.examId != null) {
      controller.editorialid(editorialDetails.id!);
      quizController.getExamDetail(id: editorialDetails.examId!);
      Get.off(() => TestInstructions(
            title: editorialDetails.title.toString(),
            type: 0,
            catTitle: "",
            examid: editorialDetails.examId!,
          ));
    } else {
      Fluttertoast.showToast(msg: "No Quiz Available");
    }
  }

  void _showReport() {
    Get.toNamed(PerformanceReportPage.routeName, arguments: {
      "exam_id": editorialDetails.examId!.toString(),
      "title": editorialDetails.title,
      "route": 0,
      "cate_id": editorialDetails.id!.toString()
    });
  }
}
