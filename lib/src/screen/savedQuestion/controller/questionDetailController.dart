import 'package:english_madhyam/main.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:english_madhyam/restApi/api_service.dart';
import '../../../commonController/authenticationController.dart';
import '../model/questionDataModel.dart';


class QuestionDetailController extends GetxController {
  var examDetails = <QuestionDetail>[].obs;

  var loading = false.obs;
  var loadingQuestion = false.obs;
  var selectedQuestion = 0.obs;
  var selectedOption = 0.obs;
  var selectedOptionIndex = 0.obs;

  Rx<double> percentage = 0.0.obs;

  final AuthenticationManager _authManager = Get.find();

  Future<void> getQuestionDetails({required catId, required questionId}) async {
    try {
      loading(true);
      apiService.getQuestionDetailsApi(jsonBody: {
        "sq_category_id": catId,
        "question_id": questionId
      }).then((model) {
        loading(false);
        if (model?.result == true) {
          examDetails.addAll(model?.content??[]);
        } else {}
      }, onError: (err) {});
    } catch (exception) {
      loading(false);
    }
  }

  ///navigation between questions
  goToQuestion(int i) {
    if (i < examDetails.length && i >= 0) {
      selectedQuestion.value = i;
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

  /// remove answer to particular question
  removeAnswer(int i) async {
    if (i < examDetails!.length && i >= 0) {
      for (int k = 0; k < examDetails[i].options!.length; k++) {
        examDetails[i].options![k].checked = 0;
      }

      examDetails[i].isAttempt = 0;
      examDetails[i].ansType = 0;
      selectedOption.value = 0;
      selectedOptionIndex.value = 0;
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }
}
