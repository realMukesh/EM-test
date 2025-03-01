import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/src/screen/home/controller/home_controller.dart';
import 'package:english_madhyam/src/screen/videos_screen/controller/videoController.dart';
import 'package:get/get.dart';
import '../../Notification_screen/controller/notification_controller.dart';
import '../../category/controller/libraryController.dart';
import '../../feed/controller/feed_controller.dart';
import '../../payment/controller/paymentController.dart';
import '../../payment/controller/transectionController.dart';

class DashboardController extends GetxController {
  var dashboardTabIndex = 0;
  AuthenticationManager authController = Get.find();

  void changeTabIndex(int index) {
    dashboardTabIndex = index;
    apiCallAccordingIndex();
    update();
  }

  ///call the api on tab click
  apiCallAccordingIndex() {
    switch (dashboardTabIndex) {
      case 0:
        if (Get.isRegistered<HomeController>()) {
          HomeController homeController = Get.find();
          homeController.initApiCall();
        }
        break;
      case 1:
        if (Get.isRegistered<LibraryController>()) {
          LibraryController controller = Get.find();
          controller.initApiCall();
        }
        break;
      case 3:
        if (Get.isRegistered<VideoController>()) {
          VideoController controller = Get.find();
          controller.initApiCall();
        }
        break;
      case 4:
        if (Get.isRegistered<TransactionController>()) {
          TransactionController controller = Get.find();
        }
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    authController.initPlatformState();
  }

  @override
  void onReady() {
    super.onReady();
    authController = Get.find();
  }
}
