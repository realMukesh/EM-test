import 'package:english_madhyam/src/screen/Notification_screen/controller/notification_controller.dart';
import 'package:get/get.dart';
import '../home/controller/home_controller.dart';
import '../profile/controller/profile_controllers.dart';
import 'controller/dashboard_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
    Get.put<ProfileControllers>(ProfileControllers());
    Get.put<NotifcationController>(NotifcationController(),);
    Get.put<HomeController>(HomeController());
  }
}