import 'package:english_madhyam/restApi/api_service.dart';
import 'package:english_madhyam/src/screen/payment/model/choose_plan_model.dart';
import 'package:english_madhyam/src/screen/material/model/plan_detial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../commonController/authenticationController.dart';

class MaterialController extends GetxController {
  Rx<bool> isLoading= false.obs;

  ScrollController freeScrollController=ScrollController();
  ScrollController paidScrollController=ScrollController();

  final AuthenticationManager authController=Get.find();
  int page = 1;
  var materialCategoryList = [].obs;
  var materialChildList = [].obs;

  var isFirstLoadRunning = false.obs;
  var isMoreDataAvailable = true.obs;

  String subCateId="";

  @override
  void onInit()async {
    super.onInit();
  }
  void getMaterialCategory(String parentId) {
    try {
      isFirstLoadRunning(true);
      apiService.getSubcategory(parentId: parentId).then((resp) {
        isFirstLoadRunning(false);
        materialCategoryList.clear();
        materialCategoryList.addAll(resp?.subCategories??[]);
      }, onError: (err) {
        isFirstLoadRunning(false);
      });
    } catch (exception) {
      isFirstLoadRunning(false);
    }
  }

  void paginateTask() {
    freeScrollController.addListener(() {
      if (freeScrollController.position.pixels ==
          freeScrollController.position.maxScrollExtent) {
        page++;
        getLoadMoreMaterialList(page);
      }
    });
  }
  //used for load the material List
  void getLoadMoreMaterialList(int page) {
    try {
      apiService.getCourseList(page: page.toString(),subCateId:subCateId).then((resp) {
        if (resp?.childCategories!=null && resp!.childCategories!.isNotEmpty) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
        }
        materialChildList.addAll(resp?.childCategories??[]);
      }, onError: (err) {
        isMoreDataAvailable(false);
      });
    } catch (exception) {
      isMoreDataAvailable(false);
    }
  }

  Future<void> getMaterialList(int page,String subCateId) async {
    this.subCateId=subCateId;
    try {
      isMoreDataAvailable(false);
      isFirstLoadRunning(true);
      apiService.getCourseList(page: page.toString(),subCateId:subCateId).then((resp) {
        isFirstLoadRunning(false);
        materialChildList.clear();
        materialChildList.addAll(resp?.childCategories??[]);
        paginateTask();
      }, onError: (err) {
        isFirstLoadRunning(false);
      });
    } catch (exception) {
      isFirstLoadRunning(false);
    }
  }

}
