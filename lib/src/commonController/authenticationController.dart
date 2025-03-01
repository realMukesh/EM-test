import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:english_madhyam/restApi/api_service.dart';
import 'package:english_madhyam/storage/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../../fcm/push_notification_service.dart';
import '../screen/login/model/login_model.dart';
import '../screen/login/model/new_usermodel.dart';
import '../auth/otp/otp_page.dart';
import '../auth/sign_up/signup_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../screen/bottom_nav/dashboard_page.dart';
import '../screen/savedQuestion/model/SaveQuestionExamListModel.dart';
import '../screen/savedQuestion/model/save_question_model.dart';
import '../setting/page/DarkThemePreference.dart';

class AuthenticationManager extends GetxController with CacheManager {
  GoogleSignInAccount? currentUser;
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    update();
  }

  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> handleSignOut() async {
    loading(true);
    googleSignIn.signOut();
    loading(false);
  }
  late FirebaseMessaging _firebaseMessaging;

  FirebaseMessaging get firebaseMessaging => _firebaseMessaging;
  Rx<bool>loading=false.obs;

  var commonQuestionList = <SaveQuestionModel>[].obs;///temp used



  @override
  void onInit() {
    super.onInit();
    _firebaseMessaging = FirebaseMessaging.instance;
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();
    getFcmTokenFrom();
  }

  /*get device token from firebase service*/
  void getFcmTokenFrom() async {
    _firebaseMessaging.getToken().then((token) {
      saveFcmToken(token);
      print('token: $token');
    }).catchError((err) {
      print("This is bug from FCM${err.message.toString()}");
    });
    FirebaseMessaging.onMessage.listen(
      (event) {
        // notificationCount=notificationCount+1;
        print('Notification is come');
      },
    );
  }
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  ///finding device type
  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo)!;
        /*apiService.saveDeviceInfo(
            deviceToken: getFcmToken() ?? "",
            deviceName: deviceData['model'],
            deviceType: "Android",
            ipAddress: "",
            osVersion: deviceData['version.release']);*/

      }
    } on PlatformException {
      Fluttertoast.showToast(msg: "Failed to get Platform version");
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  ///Getting Device Info
  Map<String, dynamic>? _readAndroidBuildData(AndroidDeviceInfo build) {
    try {
      return <String, dynamic>{
        'version.release': build.version.release,
        'model': build.model,
        'androidId': build.id,
      };
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to get Platform version" + e.toString());
    }
  }

  final isLogged = false.obs;

  bool isLogin() {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
    } else {
      isLogged.value = false;
    }
    return isLogged.value;
  }
}
