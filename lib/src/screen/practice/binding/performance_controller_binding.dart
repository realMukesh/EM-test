import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../exam/controller/result_exam_controller.dart';


class PerformanceControllerBiding extends Bindings {
  @override
  void dependencies() {
    Get.put<ExamResultController>(ExamResultController());

  }
}