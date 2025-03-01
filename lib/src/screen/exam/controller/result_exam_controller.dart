import 'dart:convert';

import 'package:english_madhyam/src/screen/exam/model/submit_exam_model.dart';
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:english_madhyam/src/screen/practice/widget/performance_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:english_madhyam/restApi/api_service.dart';

import '../../../widgets/dialog/animated_dialog.dart';
import '../../leader_Board/page/leader_board.dart';
import '../model/exam_detail_model.dart';
import '../../practice/model/graph_data_model.dart';
import 'examDetailController.dart';

class ExamResultController extends GetxController {
  var loading = false.obs;
  var graphData = GraphData().obs;
  var percentage = 0.0.obs;

  var examId;
  var title;

  final examDetailController = Get.put(ExamDetailController());

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      examId = Get.arguments["exam_id"];
      title=Get.arguments["title"]??"";
      graphDataFetch(examId: examId);
    }
  }

  graphDataFetch({required String examId}) async {
    try {
      loading(true);
      var response = await apiService.graphData(examId: examId);
      loading(false);
      if (response?.status == true) {
        graphData(response?.content);
        pieChart();
        update();
        loading(false);
      } else {
        loading(false);
      }
    } catch (e) {
      loading(false);
    }
  }

  openExamPag() async {
    loading(true);
    await examDetailController.getExamDetail(
      id: int.parse(examId),
      attempted: 1,
      title: title??"",
    );
    loading(false);

  }

  openLeaderboard() {
    Get.toNamed(LeaderboardPage.routeName, arguments: {"examId": examId});
  }

   pieChart() {
    try{
      int incorrectQuestion = graphData.value!.totalQuestion ?? 0;
      int skipQuestion = graphData.value!.skipQuestion ?? 0;
      int unanswered =
      (incorrectQuestion - skipQuestion);
      percentage.value = (unanswered / skipQuestion) * 100;
      print("percentage ${percentage.value}");
      if(percentage.isInfinite || percentage.isFinite || percentage.isNaN){
        percentage(0.0);
      }
    }
    catch(e){
      percentage(0.0);
    }

  }
}
