import 'dart:convert';
import 'package:english_madhyam/src/screen/practice/model/graph_data_model.dart';
import 'package:english_madhyam/src/screen/exam/model/exam_detail_model.dart'
    as Quiz;
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:english_madhyam/restApi/api_service.dart';
import '../../../commonController/authenticationController.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../../widgets/dialog/animated_dialog.dart';
import '../model/exam_detail_model.dart';
import '../model/submit_exam_model.dart';
import '../page/attemptedExamPage.dart';
import '../../practice/widget/performance_report.dart';

class ExamDetailController extends GetxController {
  var examDetails = ExamDetailsModel().obs;
  RxString pauseMessage = "resume".obs;
  RxString message = "".obs;
  // var quizId = 0.obs;
  var loading = true.obs;
  var loadingQuestion = false.obs;
  var selectedQuestion = 0.obs;
  var selectedOption = 0.obs;
  var selectedOptionIndex = 0.obs;

  Rx<GraphDataModel> graphdata = GraphDataModel().obs;
  Rx<SubmitExamModel> submit = SubmitExamModel().obs;

  Rx<double> percentage = 0.0.obs;

  final AuthenticationManager _authManager = Get.find();

  ///navigation between questions
  goToQuestion(int i) {
    if (i < examDetails.value.content!.examQuestion!.length && i >= 0) {
      selectedQuestion.value = i;
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

  /// remove answer to particular question
  removeAnswer(int i) async {
    if (i < examDetails.value.content!.examQuestion!.length && i >= 0) {
      for (int k = 0;
          k < examDetails.value.content!.examQuestion![i].options!.length;
          k++) {
        examDetails.value.content!.examQuestion![i].options![k].checked = 0;
      }

      examDetails.value.content!.examQuestion![i].isAttempt = 0;
      examDetails.value.content!.examQuestion![i].ansType = 0;
      selectedOption.value = 0;
      selectedOptionIndex.value = 0;
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

  double pieChart() {
    int unanswered = (graphdata.value.content!.totalQuestion! -
        graphdata.value.content!.skipQuestion!);
    percentage.value =
        (unanswered / graphdata.value.content!.totalQuestion!) * 100;

    return percentage.value;
  }

  ///get the exam details
  Future<void> getExamDetail({int? attempted, String? title, required int id}) async {
    try {
      loading(true);
      var response = await apiService.getExamDetailApi(examId: id);
      loading(false);
      if (response != null) {
        examDetails.value = response;
        switch(attempted){
          case 1:
            Get.to(() => AttemptedExamPage(
              examDetails: examDetails.value,
              reviewExam: true,
              title: title ?? "",
              type: attempted??0,
            ));
            break;
        }
      } else {
        Fluttertoast.showToast(msg: response!.message.toString());
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  ///start Exam
  void startExam({required int id}) async {
    try {
      loading(true);
      var response = await apiService.startExam(examId: id);
      loading(false);
      if (response != null) {
        message.value = response.message!;
        pauseMessage.value = "resume";
      } else {
        return null;
      }
    } catch (e) {
    } finally {
      loading(false);
    }
  }

  ///pause Exam
  Future<Map> pauseExam({required String id, required int left}) async {
    var responseJson = {};
    var requestBody = {
      "exam_id": id.toString(),
      "time_left": left,
    };
    loading(true);
    var response = await apiService.pauseExam(jsonEncode(requestBody));
    loading(false);
    if (response != null) {
      pauseMessage.value = response.message!;
      UiHelper.showSuccessMsg(null, response.message ?? "");
      responseJson = {"message": response.message ?? "", "status": true};
    } else {
      responseJson = {"message": "", "status": false};
    }
    return responseJson;
  }

  ///submit Exam
  Future<void> submitControl(
      {required String catId,
      required List<ExamQuestion> examList,
      required String id,
      required String time,
      required int route,
      required String title}) async {
    List<Map<String, dynamic>> examListJson = [];
    for (int index = 0; index < examList.length; index++) {
      ExamQuestion data = examList[index];
      var formData = <String, dynamic>{};
      formData["id"] = data.id;
      formData["exam_id"] = id;
      formData["marks"] = data.marks;
      formData["q_id"] = data.id;
      formData["is_attempt"] = data.isAttempt;
      formData["is_select"] = data.isSelect;
      formData["options"] = data.options;
      formData["solutions"] = {
        "id": data.solutions?.id,
        "q_id": data.solutions?.qId
      };
      formData["guess"] = 0;
      formData["mark"] = 0;
      formData["ansType"] = 1;

      examListJson.add(formData);
    }
    Map requestBody = {
      "examId": id,
      "examData": jsonEncode(examListJson).toString(),
      "time_left": time,
    };
    debugPrint("fdf-: ${jsonEncode(requestBody)}", wrapWidth: 1024);
    loading(true);
    var response = await apiService.submitExam(requestBody: requestBody);
    loading(false);
    if (response != null) {
      await Get.dialog(
          barrierDismissible: false,
          CustomAnimatedDialogWidget(
            title: "",
            logo: "",
            description: response.message.toString(),
            buttonAction: "okay".tr,
            buttonCancel: "cancel".tr,
            isHideCancelBtn: true,
            onCancelTap: () {},
            onActionTap: () async {
              Get.offNamed(PerformanceReportPage.routeName,
                  arguments: {"exam_id": id,"title":examDetails.value.content?.title??""});
            },
          ));
      submit.value = response;
    } else {}
  }

  Future<GraphDataModel?> graphDataFetch({required String examId}) async {
    try {
      loading(true);
      var response = await apiService.graphData(examId: examId);

      if (response != null) {
        graphdata.value = response;
        pieChart();
        update();
        loading(false);
        return graphdata.value;
      } else {
        loading(false);
      }
    } catch (e) {
      loading(false);
    }
  }

  Future<bool> reportQuiz(dynamic requestBody) async {
    loading(true);
    bool? response = await apiService.reportQuestion(requestBody);
    loading(false);
    if (response == true) {
      Fluttertoast.showToast(msg: "Successfully reported");
    } else {
      Fluttertoast.showToast(msg: "Error Ocuured");
    }
    return response;
  }
}
