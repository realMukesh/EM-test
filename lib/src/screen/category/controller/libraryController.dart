import 'dart:async';
import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:get/get.dart';
import '../model/parentCategoryModel.dart';

class LibraryController extends GetxController {
  var loading = false.obs;
  final AuthenticationManager _authManager = Get.find();
  var parentCategories = <dynamic>[].obs;
  var isSavedQuestions=false.obs;

  @override
  void onInit() {
    super.onInit();
 getParentCategory(isRefresh: false,isSavedQuestions: isSavedQuestions.value);


  }

  Future<void> getParentCategory({required bool isRefresh,bool ?isSavedQuestions}) async {
    // if(!isRefresh){
    //   loading(true);
    // }
    loading(true);
    ParentCategoryModel model = await apiService.getParentCategory(page: "",isSavedQuestions: isSavedQuestions??false);
    loading(false);
    if (model?.data=="success") {
      parentCategories.clear();
      parentCategories.addAll(model.parentCategories ?? []);
      update();
    }else{
      parentCategories.clear();
      update();

    }
  }

}


