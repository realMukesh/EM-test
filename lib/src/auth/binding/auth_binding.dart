import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../../restApi/api_service.dart';
import '../../commonController/authenticationController.dart';
import '../../screen/Splash/splash_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthenticationManager>(AuthenticationManager());
    Get.putAsync<ApiService>(() => ApiService().init());
    //Connectivity connectivity = Connectivity();
    //Get.put(NetworkInfo(connectivity));
  }
}