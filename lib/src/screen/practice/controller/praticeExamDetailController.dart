import 'dart:convert';

import 'package:english_madhyam/resrc/models/model/graph_data/graph_data_model.dart';
import 'package:english_madhyam/resrc/models/model/quiz_details.dart' as Quiz;
import 'package:english_madhyam/resrc/utils/ui_helper.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/screen/favorite/model/save_question_model.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import '../../../commonController/authenticationController.dart';
import '../attemptedQuizPage.dart';

class PraticeExamDetailController extends GetxController {
  Rx<Quiz.ExamDetails> quizDetail = Quiz.ExamDetails().obs;
  RxString pauseMessage = "resume".obs;
  RxString message = "".obs;
  // var quizId = 0.obs;
  var loading = true.obs;
  var loadingQuestion = false.obs;
  var selectedQuestion = 0.obs;
  var selectedOption = 0.obs;
  var selectedOptionIndex = 0.obs;
  var saveQuestionList = <QuestionsList>[].obs;

  Rx<GraphData> graphdata = GraphData().obs;
  Rx<double> percentage = 0.0.obs;

  List<MyExamData> myExamList = [];

  final AuthenticationManager _authManager = Get.find();

  Future<GraphData?> graphDataFetch({required String examId}) async {
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

  ///navigation between questions
  goToQuestion(int i) {
    if (i < quizDetail.value.content!.examQuestion!.length && i >= 0) {
      selectedQuestion.value = i;
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

  /// remove answer to particular question
  removeAnswer(int i) async {
    if (i < quizDetail.value.content!.examQuestion!.length && i >= 0) {
      for (int k = 0;
          k < quizDetail.value.content!.examQuestion![i].options!.length;
          k++) {
        quizDetail.value.content!.examQuestion![i].options![k].checked = 0;
      }

      quizDetail.value.content!.examQuestion![i].isAttempt = 0;
      quizDetail.value.content!.examQuestion![i].ansType = 0;
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

  void getQuizDetailApi(int? id) {
    if (id != null) {
      quizzesDetails(id: id!);
    }
  }

  void quizzesDetails({
    int? route,
    String? title,
   required int id
  }) async {
    try {
      loading(true);
      var response = await apiService.getQuizDetails(examId:id);
      loading(false);
      if (response != null) {
        print(response.result);
        quizDetail.value = response;

        if (route != null) {
          Get.to(() => AttemptedQuizPage(
                examDetails: quizDetail.value,
                reviewExam: true,
                title: title ?? "",
                type: route,
              ));
        }
      } else {
        Fluttertoast.showToast(msg: response!.message.toString());
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  //Start Exam
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

  //pause Exam
  Future<Map> pauseExam(
      {required int id,
      required int left,
      required List<Quiz.ExamQuestion> listData}) async {
    var responseJson = {};
    myExamList.clear();
    for (int i = 0; i < listData.length; i++) {
      if (listData[i].options != null && listData[i].isAttempt == 1) {
        myExamList.add(MyExamData(
            questionId: listData[i].id ?? 0,
            optionId: listData[i].isSelect ?? 0));
      } else {
        myExamList
            .add(MyExamData(questionId: listData[i].id ?? 0, optionId: 0));
      }
    }
    var list = MyExamData.getListMap(myExamList);
    var requestBody = {
      "token": _authManager.getToken(),
      "exam_id": id,
      "time_left": left,
      "exam_data": list
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

  void getSaveQuestionList({String? examId, String? title, int? catId,required BuildContext context}) async {
    try {
      loading(true);
      Quiz.ExamDetails? model =
          await apiService.getSavedQuestionList(examId: examId!);
      loading(false);

      if (model!.content!.examQuestion!.isNotEmpty) {
        // List<Quiz.ExamQuestion> exams = [];
        // for (int i = 0; i < model.questionsList!.length; i++) {
        //   exams.add(Quiz.ExamQuestion(
        //       isREAttmpted: 0,
        //       options: model.questionsList![i].options,
        //       eQuestion: model.questionsList![i].eQuestion,
        //       solutions: model.questionsList![i].solution,
        //       examId: model.questionsList![i].examId,
        //       id: model.questionsList![i].id));
        // }
        // Quiz.ExamDetails examDetails = Quiz.ExamDetails(
        //     result: "success",
        //     message: "Success",
        //     content: Quiz.Content(
        //         title: title,
        //         categoryId: catId!,
        //         isAttempt: 1,
        //         examQuestion: exams));
        Get.to(() => AttemptedQuizPage(
              examDetails: model,
              reviewExam: true,
              title: title ?? "",
              type: 6,
            ));


      }else{
        showDialog(context: context, builder: (c){
          return AlertDialog(
            backgroundColor: purplegrColor,
            title: Text("No Questions Exist",style: TextStyle(color: purpleColor,fontSize: 14),),

          );
        });
      }
    } catch (exception) {
      loading(false);
    }
  }

  //Question Attemopt
  Future<bool?> questionAttemptContr({
    required String id,
    required String left,
    required String questionId,
    required String oId,
  }) async {
    try {
      loadingQuestion(true);
      var response = await apiService.attemptQuestion(
          examId: id,
          timeLeft: left,
          questionId: questionId,
          optionSelect: oId);
      loadingQuestion(false);
      if (response != null) {
        message.value = response.message!;
        return true;
      } else {
        return false;
      }
    } catch (e) {
    } finally {
      loadingQuestion(false);
    }
  }
}

class MyExamData {
  int? questionId;
  int? optionId;

  MyExamData({required this.questionId, required this.optionId});

  Map<String, dynamic> toMap() {
    return {
      'question_Id': questionId,
      'option_id': optionId,
    };
  }

  static dynamic getListMap(List<dynamic> items) {
    if (items == null) {
      return null;
    }
    List<Map<String, dynamic>> list = [];
    items.forEach((element) {
      list.add(element.toMap());
    });
    return list;
  }
}
