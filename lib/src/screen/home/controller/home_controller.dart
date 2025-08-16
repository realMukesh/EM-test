import 'dart:io';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:english_madhyam/src/screen/home/model/birthdayModel.dart';
import 'package:english_madhyam/src/screen/home/model/home_model/home_model.dart';
import 'package:english_madhyam/src/screen/home/model/mandatoryupdate_model.dart';
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:english_madhyam/restApi/api_service.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../Notification_screen/controller/notification_controller.dart';
import '../../bottom_nav/controller/dashboard_controller.dart';
import '../../profile/controller/profile_controllers.dart';

const PLAY_STORE_URL =
    'https://play.google.com/store/apps/details?id=com.education.english_madhyam';

const APP_STORE_URL =
    'https://apps.apple.com/us/app/english-madhyam/id6443469637';

class HomeController extends GetxController {
  var loading = false.obs;
  var birthLoading = false.obs;
  Rx<MandatoryUpdate> mandatoryUpdateRx = MandatoryUpdate().obs;
  final AuthenticationManager authController = Get.find();
  final ProfileControllers profileControllers = Get.find();
  final DashboardController dashboardController = Get.find();

  CarouselSliderController sliderController = CarouselSliderController();
  final NotifcationController notficationController = Get.find();

  GlobalKey<NavigatorState>? NavigationKey;

  List<Banners> banner = <Banners>[].obs;
  List<Quizz> examList = <Quizz>[].obs;
  List<Achievers> achievers = <Achievers>[].obs;
  List<Editorials> editorialList = <Editorials>[].obs;

  var bannerIndex = 0.obs;

  var mentors = "".obs;
  var isSubscribed = false.obs;
  var successRate = "".obs;
  var greeting = "".obs;

  var name = "".obs;
  String userName = "";
  late String userImage;

  RxString students = "".obs;

  var _currAppVersion = "";
  get currAppVersion => _currAppVersion;
  var iosAppVersion = 10;

  @override
  void onInit() {
    super.onInit();
    initApiCall();
  }
  initApiCall() {
    userDetails();
  }

  @override
  void onReady() {
    super.onReady();
    greetings();
  }

  forceDownloadTheApp() {
    Future.delayed(const Duration(seconds: 2), () {
      if (Platform.isAndroid) {
        //versionCheck();
      } else {
        //versionCheckIOs();
      }
    });
  }

  userDetails() async {
    getHomeData();
    name.value = authController.getName() ?? "";
    /*authController.getBirthday() == true && authController.getShowed() != true
        ? _openSubmitDialog(context)
        : null;*/
  }

  Future<void> getHomeData() async {
    loading(true);
    HomeApiModel? response = await apiService.homeApi();
    loading(false);
    if (response != null) {
      banner = response.homeDetails!.banners!;
      examList = response.homeDetails!.quizz!;
      achievers = response.homeDetails!.achievers!;
      editorialList = response.homeDetails!.editorials!;
      isSubscribed.value = response.homeDetails!.isSubscribed!;
      mentors.value = response.homeDetails!.mentors.toString();
      successRate.value = response.homeDetails!.successRate.toString();
      students.value = response.homeDetails!.students.toString();
      //birthdayData();
    }
  }

  Future<void> versionCheck() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      double currentAppVersion =
          double.parse(info.buildNumber.trim().replaceAll(".", ""));

      var response = await apiService.mandatoryUpdate();
      if (response != null) {
        mandatoryUpdateRx.value = response;
        if (response.version!.androidMan! > currentAppVersion) {
          var result = await UiHelper.showInfoDialog();
          if (result) {
            _launchURL(PLAY_STORE_URL);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> versionCheckIOs() async {
    try {
      var response = await apiService.mandatoryUpdate();
      if (response != null) {
        mandatoryUpdateRx.value = response;
        if (response.version!.iosMan! > iosAppVersion) {
          var result = await UiHelper.showInfoDialog();
          if (result) {
            _launchURL(PLAY_STORE_URL);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      var result = await launchUrl(Uri.parse(url));
      if (Platform.isAndroid) {
        versionCheck();
      } else {
        versionCheckIOs();
      }
    } else {
      throw 'Could not launch $url';
    }
  }

  greetings() {
    DateTime now = DateTime.now();
    int hours = now.hour;
    if (hours >= 1 && hours <= 12) {
      greeting.value = "Good Morning";
    } else if (hours >= 12 && hours <= 16) {
      greeting.value = "Good Afternoon";
    } else if (hours >= 16 && hours <= 21) {
      greeting.value = "Good Evening";
    } else if (hours >= 21 && hours <= 24) {
      greeting.value = "Good Night";
    }
    return "";
  }

  ///temp is not used
  _openSubmitDialog(BuildContext context) async {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/img/birthImg.png",
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    )),
                CommonTextViewWidget(
                  text: userName,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CommonTextViewWidget(
                    text:
                        "May God Bless you with health, wealth and prosperity in your life",
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ]),
            ));
    authController.setBirthdayAndShowed(false, true);
  }
}
