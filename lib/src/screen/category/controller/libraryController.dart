import 'dart:async';
import 'package:english_madhyam/restApi/api_service.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:get/get.dart';
import '../../favorite/controller/favoriteController.dart';
import '../../material/controller/materialController.dart';
import '../../practice/controller/praticeController.dart';
import '../model/parentCategoryModel.dart';

class LibraryController extends GetxController {
  var loading = false.obs;
  final AuthenticationManager _authManager = Get.find();
  var parentCategories = <dynamic>[].obs;
  late final MaterialController materialController;
  late final PraticeController praticeController;


  @override
  void onInit() {
    super.onInit();
    initApiCall();
    initOtherController();
  }

  initApiCall(){
    getParentCategory(
        isRefresh: false);
  }
  initOtherController() {
    materialController = Get.put(MaterialController());
    praticeController = Get.put(PraticeController());
  }

  Future<void> getParentCategory(
      {required bool isRefresh}) async {
    loading(!isRefresh);
    ParentCategoryModel model = await apiService.getParentCategory(
        page: "");
    loading(false);
    if (model?.data == "success") {
      parentCategories.clear();
      parentCategories.addAll(model.parentCategories ?? []);
      update();
    } else {
      parentCategories.clear();
      update();
    }
  }
}
