import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:english_madhyam/restApi/api_service.dart';
import '../model/wardDataModel.dart';

class FavoriteController extends GetxController {
  var saveWordsList = <WordData>[].obs;
  var savedQuestionList = <dynamic>[].obs;

  var loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSaveWordsList();
  }

  void getSaveWordsList() {
    try {
      loading(true);
      apiService.getSaveWordsListApi().then((resp) {
        loading(false);
        if (resp!.result ?? false) {
          saveWordsList.clear();
          saveWordsList.addAll(resp.wordsList ?? []);
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  Future<void> removeWordsFromList(
      {required BuildContext context, required String wordId}) async {
    try {
      loading(true);
      apiService.removeWordsFromListApi(wordId: wordId).then((resp) {
        getSaveWordsList();
        if (resp!.result ?? false) {
        } else {
          UiHelper.showSnakbarMsg(context, resp?.message ?? "");
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  Future<void> saveWordsToList(
      {required BuildContext context, required String wordId}) async {
    try {
      loading(true);
      apiService.saveWordsToListApi(wordId: wordId).then((resp) {
        loading(false);
        if (resp!.result == true) {
        } else {
          UiHelper.showSnakbarMsg(context, resp?.message ?? "");
        }
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }
}
