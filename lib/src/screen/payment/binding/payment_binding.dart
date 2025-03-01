import 'package:english_madhyam/src/screen/payment/controller/paymentController.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PaymentController>(PaymentController());

  }
}