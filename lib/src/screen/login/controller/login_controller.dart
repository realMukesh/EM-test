import 'dart:io';

import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pinput.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../../../../restApi/api_service.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/ui_helper.dart';
import '../model/login_model.dart';
import '../model/new_usermodel.dart';
import '../../../auth/otp/otp_page.dart';
import '../../../auth/sign_up/signup_screen.dart';
import '../../bottom_nav/dashboard_page.dart';

class LoginController extends GetxController {
  var loading = false.obs;
  AuthenticationManager authenticationManager = Get.find();

  final defaultPinTheme = PinTheme(
    width: 39,
    height: 39,
    textStyle: const TextStyle(
      fontSize: 18,
      color: colorSecondary,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: indicatorColor),
    ),
  );

  /// send the OTP for the verify otp
  Future<void> sendOtp({required context, required mobile}) async {
    loading(true);
    Map requestBody = {
      "phone": mobile,
    };
    UserModel? response = await apiService.sendOtp(requestBody);
    loading(false);
    if (response?.result == 'success') {
      UiHelper.showSnakbarSucess(
          context, response?.message ?? "Something wrong");
      Get.to(() => OtpPage(
            mobile: mobile,
          ));
    } else {
      UiHelper.showSnakbarMsg(context, response?.message ?? "Something wrong");
    }
  }

  ///used for the normal login with mobile number
  Future<void> login(
      {required String email,
      required String phone,
      required String otp,
      required BuildContext context}) async {
    loading(true);

    FirebaseMessaging.instance.getToken().then((token) {
      authenticationManager.saveFcmToken(token);
      print('token: $token');
    }).catchError((err) {
      print("This is bug from FCM${err.message.toString()}");
    });
    Map requestBody = {
      "phone": phone,
      "email": email,
      "otp": otp,
      "deviceID": (await PlatformDeviceId.getDeviceId) ?? "",
      "deviceToken": authenticationManager.getFcmToken() ?? "3211",
      "deviceType": Platform.isAndroid ? "Android" : "IOS",
    };
    UserModel? response = await apiService.login(requestBody);
    loading(false);

    if (response?.status ?? false) {
      authenticationManager.setProfileData(
          name: response?.user?.name?.toString() ?? "",
          username: response?.user?.id?.toString() ?? "",
          email: email,
          profile: response?.user?.image ?? "",
          mobile: response?.user?.phone ?? "");
      authenticationManager.saveToken(response?.token.toString());
      Get.offNamedUntil(DashboardPage.routeName, (route) => false);
    } else {
      UiHelper.showFailureMsg(
          context, response?.message ?? "Your account has been disabled.");
    }
    Future.delayed(const Duration(seconds: 5), () {
      loading(false);
    });
  }

  ///used for the social login
  Future<void> handleSignIn(BuildContext context) async {
    try {
      authenticationManager.currentUser =
          await authenticationManager.googleSignIn.signIn();

      GoogleSignInAuthentication auth =
          await authenticationManager.currentUser!.authentication;
      String accessToken = auth.idToken!;
      print("access token ${accessToken}");

      print("social id ${authenticationManager.currentUser?.id}");
      print("token ${authenticationManager.currentUser}");
      if (authenticationManager.currentUser != null) {
        socialCheck(accessToken, authenticationManager.currentUser?.email ?? "",
            context);
      }
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  ///used for the social login api
  Future<void> socialCheck(
      String token, String email, BuildContext context) async {
    loading(true);
    Map req = {
      "id_token": token,
    };
    NewUserModel? model = await apiService.socialLogin(req);
    loading(false);
    if(model?.status==true){
      authenticationManager.setProfileData(
          name: model?.user?.name?.toString() ?? "",
          username: model?.user?.id?.toString() ?? "",
          email: email,
          profile: model?.user?.image ?? "",
          mobile: model?.user?.phone ?? "");
      authenticationManager.saveToken(model?.token.toString());
      Get.offNamedUntil(DashboardPage.routeName, (route) => false);
    }
    else{
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => RegisterScreen(
                email: email,
              )),
              (route) => false);
    }
  }
}
