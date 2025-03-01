import 'package:english_madhyam/src/screen/exam/model/exam_list_model.dart';
import 'package:english_madhyam/src/screen/savedQuestion/model/SaveQuestionExamListModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:english_madhyam/restApi/api_service.dart';

class ExamListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool catLoading = false.obs;
  RxInt selectedPageIndex = 0.obs;

  var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  late bool hasNextPage;
  //late int _pageNumber;
  int pageNumber = 1;
  ScrollController scrollController = ScrollController();
  ScrollController scrollCtr = ScrollController();

  var praticeExamList = [].obs;

  var subCategoryId = "";

  RxString categoryy = "".obs;

  @override
  void onInit() {
    super.onInit();
    // if(Get.arguments!=null){
    //   getQuizListByCategory(isRefresh: false,cat: Get.arguments["childCategories"]);
    // }
  }

  //start
  Future<void> getExamListByCategory(
      {required String cat,
      required bool isRefresh,
      required bool saveQuestionExamList}) async {
    subCategoryId = cat;
    print("@@@  subCategoryId ${subCategoryId}");
    pageNumber = 1;
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }
    ExamListModel? model = await apiService.getPracticeListExam(
        type: "daily", id: subCategoryId, page: pageNumber);
    if (model!.result == "success") {
      praticeExamList.clear();
      praticeExamList.addAll(model.content?.data ?? []);
      if (model.content?.total != null && pageNumber < model.content!.total!) {
        pageNumber = pageNumber + 1;
        hasNextPage = true;
      } else {
        hasNextPage = false;
      }
      if (hasNextPage) {
        getPracticeChildLoadMore();
      }
      Future.delayed(Duration(seconds: 1), () {
        isLoading(false);
        isFirstLoadRunning(false);
      });
    } else {
      isFirstLoadRunning(false);
    }
  }

  Future<void> getPracticeChildLoadMore() async {
    scrollCtr.addListener(() async {
      if (hasNextPage == true &&
          isFirstLoadRunning.value == false &&
          isLoadMoreRunning.value == false &&
          scrollCtr.position.maxScrollExtent == scrollCtr.position.pixels) {
        isLoadMoreRunning(true);
        try {
          ExamListModel? model = await apiService.getPracticeListExam(
              type: "daily", id: subCategoryId, page: pageNumber);
          if (model!.result == "success") {
            print("load more---");
            print(model.content?.total);
            print(model.content?.lastPage);
            print(model.content?.currentPage);
            if (model.content?.total != null &&
                pageNumber < model.content!.total!) {
              pageNumber = pageNumber + 1;
              hasNextPage = true;
            } else {
              hasNextPage = false;
            }
            print("has next page$hasNextPage");
            praticeExamList.addAll(model.content?.data ?? []);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }
//end
}
