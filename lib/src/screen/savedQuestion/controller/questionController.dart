import 'dart:convert';

import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/src/screen/exam/model/exam_list_model.dart';
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:english_madhyam/restApi/api_service.dart';
import 'package:get_storage/get_storage.dart';
import '../../exam/model/exam_detail_model.dart';
import '../model/SaveQuestionExamListModel.dart';
import '../model/question_category_model.dart';
import '../model/save_question_model.dart';

class QuestionController extends GetxController {
  var loading = false.obs;
  var saveQuestionList = <QuestionData>[].obs;
  var selectedIndex = 0.obs;

  var filterItemList = <SqCategories>[].obs;
  var filterItemAllList = <SqCategories>[].obs;

  AuthenticationManager authenticationManager = Get.find();
  @override
  void onInit() {
    super.onInit();
    saveQuestionList.clear();
    getCategoryList();
    getSavedQuestionList(catId: "");
  }

  Future<void> getCategoryList() async {
    try {
      loading(true);
      apiService.getCategoryList().then((model) {
        loading(false);
        if (model?.data == "success") {
          filterItemList.clear();
          filterItemAllList.clear();
          filterItemList.addAll(model?.sqCategories ?? []);

          filterItemAllList.add(SqCategories(id: 0, name: "All"));
          filterItemAllList.addAll(model?.sqCategories ?? []);
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  Future<void> getSavedQuestionList({required catId}) async {
    try {
      loading(true);
      apiService.getSavedQuestionApi(jsonBody: {
        "sq_category_id": catId.toString() == "0" ? "" : catId.toString()
      }).then((model) {
        loading(false);
        if (model?.result == true) {
          saveQuestionList.clear();
          saveQuestionList.addAll(model?.questionList ?? []);
        } else {
          saveQuestionList.clear();
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  applyFilterToItem(filterCategory) {
    getSavedQuestionList(catId: filterCategory);
  }

  Future<void> bookmarkQuestion(
      {required BuildContext context,
      required jsonBody,
      required isBookmark}) async {
    try {
      loading(true);
      apiService
          .saveQuestionToListApi(jsonRequest: jsonBody, isBookmark: isBookmark)
          .then((resp) {
        loading(false);
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  Future<void> removeQuestion(
      {required BuildContext context,
      required jsonBody,
      required index}) async {
    try {
      loading(true);
      apiService
          .saveQuestionToListApi(jsonRequest: jsonBody, isBookmark: false)
          .then((resp) {
        loading(false);
        saveQuestionList.removeAt(index);
        saveQuestionList.refresh();
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }
}
