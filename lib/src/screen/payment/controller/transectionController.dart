import 'package:dio/dio.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/screen/payment/model/apply_coupon_model.dart';
import 'package:english_madhyam/src/screen/payment/model/coupon_list_ldel.dart';
import 'package:english_madhyam/src/screen/payment/model/purchase_history_model.dart';
import 'package:english_madhyam/src/screen/payment/model/succes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';
import 'package:english_madhyam/restApi/exceptions.dart' as apiExceptions;

import 'package:english_madhyam/restApi/api_service.dart';

import '../../material/model/plan_detial.dart';
import '../model/choose_plan_model.dart';

class TransactionController extends GetxController {
  RxBool loading = false.obs;

  var planHistoryList = <PurchaseHistory>[].obs;
  var tabIndex = 0;
  Rx<ChoosePlanModel> choosePlan = ChoosePlanModel().obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
  Future<void> purchaseHistory() async {
    try {
      loading(true);
      PurchaseHistoryModel? response = await apiService.purchaseHistory();
      loading(false);
      if (response != null) {
        if (response.result == "success") {
          planHistoryList.clear();
          planHistoryList.addAll(response.purchaseHistory ?? []);
        } else {
          Fluttertoast.showToast(msg: response.message.toString());
          cancel();
        }
      } else {
        loading(false);
        return null;
      }
    } catch (e) {
      loading(false);
    } finally {
      loading(false);
    }
  }

}
