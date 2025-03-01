import 'package:dio/dio.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/screen/payment/model/apply_coupon_model.dart';
import 'package:english_madhyam/src/screen/payment/model/coupon_list_ldel.dart';
import 'package:english_madhyam/src/screen/payment/model/purchase_history_model.dart';
import 'package:english_madhyam/src/screen/payment/model/succes.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:vibration/vibration.dart';
import 'package:english_madhyam/restApi/exceptions.dart' as apiExceptions;

import 'package:english_madhyam/restApi/api_service.dart';

import '../../../../utils/ui_helper.dart';
import '../../../commonController/authenticationController.dart';
import '../../../widgets/dialog/animated_dialog.dart';
import '../../material/model/plan_detial.dart';
import '../model/choose_plan_model.dart';

class PaymentController extends GetxController {
  var loading = false.obs;
  var checkPayment = Success().obs;

  var couponCode = "".obs;
  var selectedCouponId = "".obs;

  var couponList = <CouponsData>[].obs;
  var selectedCouponDetails = CouponDetails().obs;

  ///plan details
  var planIdOneMonth = "";
  var planIdThreeMonth = "";
  var planIdOneYear = "";
  var planIdSixMonth = "";

  var selectedPlanIndex = 0.obs;

  var planList = <PlanData>[].obs;

  late Razorpay _razorpay;
  var _razorPayTxnId = "";

  final AuthenticationManager authController = Get.find();
  final ProfileControllers profileController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    selectedPlanIndex.value = 0;

    getPlanDetails();
  }

  ///get the plan details
  Future<void> getPlanDetails() async {
    loading(true);
    PlanDetailModel? response = await apiService.getPlanDetails();
    loading(false);
    if (response != null) {
      planList.clear();
      planList.addAll(response.list ?? []);
      if (planList.isNotEmpty) {
        planIdOneMonth =
            planList.firstWhere((plan) => plan.duration == 1).id.toString();
        planIdThreeMonth =
            planList.firstWhere((plan) => plan.duration == 3).id.toString();
        planIdSixMonth =
            planList.firstWhere((plan) => plan.duration == 6).id.toString();
        planIdOneYear =
            planList.firstWhere((plan) => plan.duration == 12).id.toString();
      }
    } else {
      //isLoading(false);
      return null;
    }
  }

  ///get the coupon list
  Future<void> getCouponListApi() async {
    try {
      loading(true);
      CouponModel? response = await apiService.couponList();
      loading(false);
      if (response != null && response.result == true) {
        couponList.clear();
        couponList.addAll(response.couponsList ?? []);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      loading(false);
    }
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    UiHelper.showFailureMsg(null, "ERROR: Payment not completed");
    await profileController.getProfileData();
    Get.back();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName!}",
        timeInSecForIosWeb: 10);
    cancel();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _razorPayTxnId = response.paymentId!;
    confirmPayment(
        pay: response.paymentId!,
        amount: couponCode.value == ""
            ? planList[selectedPlanIndex.value].fee!.toString()
            : selectedCouponDetails.value.finalAmount.toString(),
        planID: planList[selectedPlanIndex.value].id.toString(),
        paymentMethod: "razorpay");
    await profileController.getProfileData();
    await Get.dialog(
        barrierDismissible: false,
        CustomAnimatedDialogWidget(
          title: "",
          logo: "",
          description: "You have Successfully purchased Subscription",
          buttonAction: "okay".tr,
          buttonCancel: "cancel".tr,
          isHideCancelBtn: true,
          onCancelTap: () {},
          onActionTap: () async {
            Get.back();
          },
        ));
  }

  void openCheckout({required double amount, required String orderId}) async {
    // rzp_test_4Q31IbUFwyd9ie test key
    // rzp_live_YJ3XTbIRf8bjeQ  it is live key

    var options = {
      //'key': "rzp_test_4Q31IbUFwyd9ie",
      'key': "rzp_live_YJ3XTbIRf8bjeQ",
      'amount': (amount.toInt()) * 100,
      'order_id': orderId,
      'image': "https://razorpay.com/assets/razorpay-glyph.svg",
      'currency': 'INR',
      "theme": {"color": "#0033FD", "backdrop_color": "#FFBE00"},
      'retry': {'enabled': true, 'max_count': 3},
      'send_sms_hash': true,
      "display": {
        "widget": {
          "main": {
            "heading": {"color": "#FFBE00", "fontSize": "12px"}
          }
        }
      },
      'name': authController.getName(),
      'description': "English Madhyam",
      'prefill': {
        'contact': authController.getMobile(),
        'email': authController.getEmail()
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {}
  }

  Future<Success?> confirmPayment(
      {required String amount,
      required String pay,
      required String planID,
      required String paymentMethod}) async {
    Map requestBody = {
      "amount": amount,
      "txn_id": pay,
      /*'orderId': orderId,
      "plan_id": planID,
      "payment_method": paymentMethod*/
    };
    loading(true);
    var response = await apiService.checkPayment(requestBody: requestBody);
    loading(false);
    if (response?.result == true) {
      checkPayment.value = response!;
      return response;
    } else {
      Fluttertoast.showToast(msg: response?.message ?? "");
      cancel();
      return response;
    }
  }

  Future<String> getOrderId() async {
    Map requestBody = {
      "coupon_id": selectedCouponId.value.toString(),
      "plan_id": planList[selectedPlanIndex.value].id.toString(),
    };
    loading(true);
    var response = await apiService.getOrderId(requestBody: requestBody);
    loading(false);
    if (response?.status == "success") {
      return response?.orderId.toString() ?? "";
    } else {
      return "";
    }
  }

  void applyCouponApi(
      {required String planId,
      required String coupon,
      required String couponId}) async {
    Map requestBody = {
      "coupon_code": coupon,
      "plan_id": planId,
    };
    try {
      loading(true);
      ApplyCouponModel? response =
          await apiService.applyCoupon(requestBody: requestBody);
      loading(false);
      if (response?.result == true && response != null) {
        selectedCouponDetails(response.couponDetails);
        couponCode.value = coupon;
        selectedCouponId.value = couponId;
        await Get.dialog(
            barrierDismissible: false,
            CustomAnimatedDialogWidget(
              title: "",
              logo: "",
              description: response.message ?? "",
              buttonAction: "okay".tr,
              buttonCancel: "cancel".tr,
              isHideCancelBtn: true,
              onCancelTap: () {},
              onActionTap: () async {
                Get.back();
              },
            ));
      } else {
        _vibrateDevice();
        _showCouponNotAppliedPopup(response?.message ?? "");
      }
    } on DioError catch (e) {
      // Handle Dio-specific errors, including 400 responses
      if (e.response != null && e.response!.statusCode == 400) {
        print('Bad Request: ${e.response!.data}');
        // Handle the 400 response accordingly
        _vibrateDevice();
        _showCouponNotAppliedPopup(e.response!.data['message'].toString());
        loading(false);
      } else {
        print('Error during HTTP request: $e');
        _vibrateDevice();
        _showCouponNotAppliedPopup(e.response!.data['message'].toString());
        loading(false);
        // Handle other Dio errors
      }
    } catch (e) {
      // Handle any other exceptions that occur during the request
      print('Error during HTTP request: $e');
      apiExceptions.ClientException error = e as apiExceptions.ClientException;
      _vibrateDevice();
      _showCouponNotAppliedPopup(e.message.toString());
      loading(false);
    }
  }

  void _vibrateDevice() async {
    if (await Vibration.hasVibrator() != null) {
      Vibration.vibrate(duration: 500);
    }
  }

  void _showCouponNotAppliedPopup(String message) {
    UiHelper.showFailureMsg(null, message);
  }
}
