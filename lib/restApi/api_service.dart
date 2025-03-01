import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:english_madhyam/src/screen/Notification_screen/model/NotificationModel.dart';
import 'package:english_madhyam/src/screen/practice/model/all_category.dart';
import 'package:english_madhyam/src/screen/payment/model/apply_coupon_model.dart';
import 'package:english_madhyam/src/screen/editorials_page/model/categoryEditorial.dart';
import 'package:english_madhyam/src/screen/payment/model/choose_plan_model.dart';
import 'package:english_madhyam/src/screen/pages/model/cms.dart';
import 'package:english_madhyam/src/screen/payment/model/coupon_list_ldel.dart';
import 'package:english_madhyam/src/auth/model/deviceinfo_model.dart';
import 'package:english_madhyam/src/screen/editorials_page/model/editorial_detail.dart';
import 'package:english_madhyam/src/screen/editorials_page/model/getcoursesmodel.dart';
import 'package:english_madhyam/src/screen/feed/model/feed_model.dart';
import 'package:english_madhyam/src/screen/practice/model/graph_data_model.dart';
import 'package:english_madhyam/src/screen/home/model/home_model/home_model.dart';
import 'package:english_madhyam/src/screen/home/model/mandatoryupdate_model.dart';
import 'package:english_madhyam/src/screen/home/model/meaning_list.dart';
import 'package:english_madhyam/src/screen/editorials_page/model/meaning_model.dart';
import 'package:english_madhyam/src/screen/material/model/pdf_list_model.dart';
import 'package:english_madhyam/src/screen/material/model/plan_detial.dart';
import 'package:english_madhyam/src/screen/profile/model/profile_model.dart';
import 'package:english_madhyam/src/screen/payment/model/purchase_history_model.dart';
import 'package:english_madhyam/src/screen/exam/model/exam_list_model.dart';
import 'package:english_madhyam/src/screen/exam/model/submit_exam_model.dart';
import 'package:english_madhyam/src/screen/payment/model/succes.dart';
import 'package:english_madhyam/src/screen/profile/model/update_profile_model.dart';
import 'package:english_madhyam/src/screen/videos_screen/model/video_cat_model.dart';
import 'package:english_madhyam/src/screen/videos_screen/model/youtube_list.dart';
import 'package:english_madhyam/src/screen/category/model/subCategoryModel.dart';
import 'package:english_madhyam/src/screen/savedQuestion/model/SaveQuestionExamListModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../src/commonController/authenticationController.dart';
import '../src/auth/log_out/log_out_model.dart';
import '../src/screen/login/model/login_model.dart';
import '../src/screen/login/model/new_usermodel.dart';
import '../src/auth/otp/send_otp_model/send_otp.dart';
import '../src/auth/sign_up/model/signup_model.dart';
import '../src/chatGpt/model/chatGptModel.dart';
import '../src/screen/category/model/parentCategoryModel.dart';
import '../src/screen/favorite/model/attemptedExamData.dart';
import '../src/screen/favorite/model/wardDataModel.dart';
import '../src/screen/favorite/saveDataModel.dart';
import '../src/screen/leader_Board/model/LeadboardModel.dart';
import '../src/screen/exam/model/exam_detail_model.dart';
import '../src/screen/payment/model/create_payment_order_model.dart';
import '../src/screen/savedQuestion/model/questionDataModel.dart';
import '../src/screen/savedQuestion/model/question_category_model.dart';
import '../src/screen/savedQuestion/model/save_question_model.dart';
import 'app_url.dart';
import 'base_client.dart';
import 'package:dio/src/form_data.dart' as Form;
import 'package:dio/src/multipart_file.dart' as Multi;
import 'package:dio/dio.dart' as dIo;
import 'package:http_parser/http_parser.dart';
import 'exceptions.dart';

ApiService apiService = Get.find<ApiService>();

class ApiService extends GetxService {
  late RestClient _restClient;
  Map<String, dynamic>? headers;
  late final AuthenticationManager _authManager;

  Future<ApiService> init() async {
    _authManager = Get.find();
    if (_authManager.getToken() != null) {
      headers = {
        "Accept": "application/json",
        "Authorization": "Bearer ${_authManager.getToken()!}",
      };
    } else {
      headers = {
        "Accept": "application/json",
      };
    }
    _restClient = RestClient();
    _restClient.init();
    return this;
  }

  Map<String, dynamic> getHeaders() {
    if (_authManager.getToken() != null) {
      headers = {
        "Accept": "application/json",
        "Authorization": "Bearer " + _authManager.getToken()!,
      };
    } else {
      headers = {
        "Accept": "application/json",
      };
    }
    return headers!;
  }

  Future<UserModel?> sendOtp(dynamic map) async {
    try {
      var response = await _restClient.postData(
          url: AppUrl.send_otp,
          payload: jsonEncode(map),
          headers: getHeaders());
      return UserModel.fromJson(response);
    } catch (exception) {
      checkException(exception);
      rethrow;
    }
  }

  Future<NewUserModel?> socialLogin(dynamic map) async {
    try {
      var response = await _restClient.postData(
          url: AppUrl.googleLogin,
          payload: jsonEncode(map),
          headers: getHeaders());
      print("@@ ${jsonEncode(response)}");
      return NewUserModel.fromJson(response);
    } catch (exception) {
      checkException(exception);
      rethrow;
    }
  }

  Future<UserModel?> login(dynamic map) async {
    try {
      var response = await _restClient.postData(
          url: AppUrl.login, payload: jsonEncode(map), headers: getHeaders());
      return UserModel.fromJson(response);
    } catch (exception) {
      return UserModel(
          status: false, message: "something went wrong try again");
      checkException(exception);
      rethrow;
    }
  }

  Future<SignUpModel?> signup(dynamic map) async {
    try {
      var response = await _restClient.postData(
          url: AppUrl.signup, payload: jsonEncode(map), headers: getHeaders());
      return SignUpModel.fromJson(response);
    } catch (exception) {
      return SignUpModel(
          result: "failure", message: "something went wrong try again");

      checkException(exception);
      return null;
    }
  }

  Future<bool> reportQuestion(dynamic map) async {
    try {
      var response = await _restClient.postData(
          url: AppUrl.reportQuestion,
          payload: jsonEncode(map),
          headers: getHeaders());
      return response['status'];
    } catch (exception) {
      checkException(exception);
      rethrow;
    }
  }

  Future<LogOutModel?> logOutApi() async {
    var response =
        await _restClient.getData(url: AppUrl.logout, headers: getHeaders());
    try {
      return LogOutModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  } //Log OUT

  Future<MandatoryUpdate?> mandatoryUpdate() async {
    var response = await _restClient.getData(
        url: AppUrl.getAppVersion, headers: getHeaders());
    try {
      return MandatoryUpdate.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<DeviceInfo?> saveDeviceInfo(
      {required String deviceType,
      required String deviceName,
      required String ipAddress,
      required String osVersion,
      required String deviceToken}) async {
    Map requestBody = {
      "device_type": deviceType,
      "device_name": deviceName,
      "ip_address": ipAddress,
      "os_version": osVersion,
      "device_token": deviceToken
    };
    final response = await _restClient.postData(
        url: AppUrl.getDeviceInfo, payload: requestBody, headers: getHeaders());

    try {
      return DeviceInfo.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //plan list
  Future<ChoosePlanModel?> getCourseList(
      {required String page, required String subCateId}) async {
    Map requestBody = {"page": page, "sub_category": subCateId ?? ""};

    final response = await _restClient.postData(
        url: AppUrl.getChildCategory,
        payload: requestBody,
        headers: getHeaders());
    try {
      return ChoosePlanModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ChoosePlanModel?> getCourseListOld(
      {required String page, required String subCateId}) async {
    Map requestBody = {"page": page, "sub_category": subCateId ?? ""};
    final response = await _restClient.postData(
        url: "${AppUrl.categoryTypeList}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return ChoosePlanModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //plan list
  Future<PlanDetailModel?> getPlanDetails() async {
    final response = await _restClient.getData(
        url: AppUrl.subscriptionPlans, headers: getHeaders());
    print("@@@ ${response}");
    try {
      return PlanDetailModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<GetCoursesModel?> getCoursesList(
      {String? date, required String page}) async {
    Map requestBody = {"date": date, "page": page};
    final response = await _restClient.postData(
        url: "${AppUrl.getEditorials}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return GetCoursesModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

// Start Exam
  Future<Success?> startExam({required int examId}) async {
    Map requestBody = {"exam_id": examId};
    final response = await _restClient.postData(
        url: AppUrl.startExam, payload: requestBody, headers: getHeaders());

    try {
      return Success.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //Pause Exam
  Future<Success?> pauseExam(dynamic requestBody) async {
    jsonEncode(requestBody);
    final response = await _restClient.postData(
        url: AppUrl.pauseExam, payload: requestBody, headers: getHeaders());
    try {
      return Success.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //question Attempt
  Future<Success?> attemptQuestion(
      {required String examId,
      required String timeLeft,
      required String questionId,
      required String optionSelect}) async {
    Map requestBody = {
      "exam_id": examId,
      "time_left": timeLeft,
      "question_id": questionId,
      "selected_option": optionSelect
    };
    final response = await _restClient.postData(
        url: "${AppUrl.attemptQuestion}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return Success.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<SubmitExamModel?> submitExam({required dynamic requestBody}) async {
    final response = await _restClient.postData(
        url: AppUrl.submitExam,
        payload: jsonEncode(requestBody),
        headers: getHeaders());
    try {
      return SubmitExamModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //
  Future<EditorialDetailsModel?> getEditorialDetails({String? courseId}) async {
    Map requestBody = {"editorial_id": courseId};
    final response = await _restClient.postData(
        url: AppUrl.editorialDetails,
        payload: requestBody,
        headers: getHeaders());

    try {
      return EditorialDetailsModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<Map<String, dynamic>> downloadPdfFile(
      {dynamic filePath, dynamic savePath}) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    final response = await _restClient.downloadData(
        filePath: filePath, savePath: savePath, headers: getHeaders());

    result['isSuccess'] = response.statusCode == 200;
    result['filePath'] = savePath;
    try {
      return result;
    } catch (e) {
      checkException(e);
      return result;
    }
  }

  Future<PdfList?> pdfListProv(
      {required String type, required String id}) async {
    Map requestBody = {
      "type": type,
      "category_id": id,
    };

    final response = await _restClient.postData(
        url: "${AppUrl.getPdfList}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return PdfList.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //Editorials by category
  Future<EditorialCat?> getEditorialDetailsByCat(
      {String? catId, required String page}) async {
    Map requestBody = {
      "category_id": catId,
      "page": page,
    };
    final response = await _restClient.postData(
        url: "${AppUrl.get_editorials_by_category}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return EditorialCat.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //word meaning

  Future<MeaningModel?> wordMeaning({String? word, required String id}) async {
    Map requestBody = {"word": word, "editorial_id": id};
    final response = await _restClient.postData(
        url: "${AppUrl.editorial_vocab}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return MeaningModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<TextCompletionModel?> wordMeaningGpt({dynamic body}) async {
    final encodedParams = json.encode(body);

    /*final response = await _restClient.postData(
        url: endPoint("completions"), payload: encodedParams,headers: headerBearerOption(OPEN_AI_KEY));
    try {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));

      return TextCompletionModel.fromJson(responseJson);
    } catch (e) {
      checkException(e);
      return null;
    }*/
  }

  // word meaning list
  Future<MeaningList?> wordMeaningList({String? id}) async {
    Map requestBody = {"editorial_id": id};
    final response = await _restClient.postData(
        url: "${AppUrl.editorial_vocabs_list}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return MeaningList.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ExamDetailsModel?> getExamDetailApi({required int examId}) async {
    Map requestBody = {"examId": examId};
    final response = await _restClient.postData(
        url: AppUrl.exam_details, payload: requestBody);
    try {
      return ExamDetailsModel.fromJson(response);
    } catch (e) {
      print('kye ah isme ${e.toString()}');
      checkException(e);
      return null;
    }
  }

  Future<GraphDataModel?> graphData({required String examId}) async {
    Map requestBody = {
      "examId": examId,
    };

    final response = await _restClient.postData(
        url: AppUrl.graphData, payload: requestBody, headers: getHeaders());

    try {
      return GraphDataModel.fromJson(response);
    } catch (e) {
      print(e.toString());
      checkException(e);
    }
    return null;
  }

  Future<FeedModel?> getFeed(
      {String? type, required String date, required int currentPage}) async {
    Map requestBody = {"type": type, "date": date, "page": currentPage};
    final response = await _restClient.postData(
        url: "${AppUrl.daily_learnings_v2}",
        payload: requestBody,
        headers: getHeaders());

    try {
      return FeedModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<HomeApiModel?> homeApi() async {
    final response =
        await _restClient.getData(url: AppUrl.home, headers: getHeaders());
    print("home api ${response}");

    try {
      return HomeApiModel.fromJson(response);
    } catch (e) {
      checkException(e);
      print(e.toString());
      return null;
    }
  }

  Future<Success?> checkPayment({requestBody}) async {
    final response = await _restClient.postData(
        url: AppUrl.check_payment, payload: requestBody, headers: getHeaders());
    try {
      return Success.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<CreatePaymentOrderModel?> getOrderId({requestBody}) async {
    final response = await _restClient.postData(
        url: AppUrl.create_order, payload: requestBody, headers: getHeaders());
    try {
      return CreatePaymentOrderModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  //Apply Coupon
  Future<ApplyCouponModel?> applyCoupon({requestBody}) async {
    final response = await _restClient.postData(
        url: AppUrl.apply_coupon, payload: requestBody, headers: getHeaders());
    try {
      return ApplyCouponModel.fromJson(response);
    } on dIo.DioError catch (e) {
      checkException(e);
      return null;
    }
  }

  //Coupon List
  Future<CouponModel?> couponList() async {
    final response = await _restClient.getData(
        url: AppUrl.coupons_list, headers: getHeaders());
    print("response ${response}");
    try {
      return CouponModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<PurchaseHistoryModel?> purchaseHistory() async {
    final response = await _restClient.getData(
        url: "${AppUrl.purchase_history}", headers: getHeaders());
    try {
      return PurchaseHistoryModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ProfileModel?> profileGetApi() async {
    final response =
        await _restClient.getData(url: AppUrl.profile, headers: getHeaders());
    try {
      return ProfileModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<LeadboardModel?> getLeaderboardPage({examId}) async {
    Map requestBody = {"exam_id": examId};
    final response = await _restClient.postData(
        url: "${AppUrl.StudentsLeadboard}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return LeadboardModel.fromJson(response);
    } catch (e) {
      print(e);
      checkException(e);
      return null;
    }
  }

  Future<UpdateProfileModel?> updateProfile(
      {String? name,
      String? username,
      String? dateBirthday,
      String? image,
      String? emailId}) async {
    var dio = dIo.Dio();
    if (image != null) {
      String fileName = image.split('/').last;
      Form.FormData formData = Form.FormData.fromMap({
        "name": name,
        "username": username,
        "email": emailId,
        "image": await Multi.MultipartFile.fromFile(image,
            filename: fileName, contentType: MediaType("image", "jpg")),
      });
      try {
        dIo.Response response = await dio.post(AppUrl.update_profile,
            data: formData, options: Options(headers: getHeaders()));

        return UpdateProfileModel.fromJson(response.data);
      } catch (e) {
        checkException(e);
        return null;
      }
    } else {
      Form.FormData formData = Form.FormData.fromMap({
        "name": name,
        "username": username,
        "email": emailId,
      });

      try {
        dIo.Response response = await dio.post(AppUrl.update_profile,
            data: formData, options: Options(headers: getHeaders()));

        return UpdateProfileModel.fromJson(response.data);
      } catch (e) {
        checkException(e);
      }
    }
  }

  Future<ExamListModel?> getPracticeListExam(
      {required String type,
      int? editorialId,
      required String id,
      int? page}) async {
    Map requestBody = {"type": type, "category_id": id, "page": page};
    try {
      final response = await _restClient.postData(
          url: "${AppUrl.exam_list}",
          payload: requestBody,
          headers: getHeaders());
      return ExamListModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<SaveDataModel?> saveQuestionToListApi({jsonRequest,isBookmark}) async {
    final response = await _restClient.postData(
        url: isBookmark?AppUrl.save_question:AppUrl.remove_saved_question,
        payload: jsonRequest,
        headers: getHeaders());
    try {
      return SaveDataModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<QuestionCategoryModel?> getCategoryList() async {
    final response = await _restClient.getData(
        url: "${AppUrl.get_sq_categories}",
        headers: getHeaders());
    try {
      return QuestionCategoryModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<SaveDataModel?> saveWordsToListApi({wordId}) async {
    Map requestBody = {"word_id": wordId};

    final response = await _restClient.postData(
        url: "${AppUrl.save_word}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return SaveDataModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<WordDataModel?> getSaveWordsListApi() async {
    final response = await _restClient.getData(
        url: "${AppUrl.words_list}", headers: getHeaders());
    try {
      return WordDataModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<SaveDataModel?> removeWordsFromListApi({wordId}) async {
    Map requestBody = {
      "word_id": wordId,
    };

    final response = await _restClient.postData(
        url: "${AppUrl.remove_word}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return SaveDataModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<GetAllQuizCategory?> getQuizCategoryList(
      {required String page}) async {
    final response = await _restClient.getData(
        url: AppUrl.getAllCategories, headers: getHeaders());
    try {
      return GetAllQuizCategory.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ParentCategoryModel> getParentCategory(
      {String? page}) async {
    final response = await _restClient.getData(
        url: AppUrl.getParentCategories,
        headers: getHeaders());
    try {
      return ParentCategoryModel.fromJson(response);
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<SubCategoryModel> getSubcategory(
      {required String parentId}) async {
    Map requestBody = {"parent_category": parentId};
    final response = await _restClient.postData(
        url: AppUrl.getSubcategory,
        payload: requestBody,
        headers: getHeaders());
    try {
      return SubCategoryModel.fromJson(response);
    } catch (e) {
      checkException(e);
      rethrow;
    }
  }

  Future<GetAllQuizCategory?> getChildCategory(
      {required String page,
      required String subCategoryId,
      required bool isSavedQuestions}) async {
    Map requestBody = {"page": page, "sub_category": subCategoryId ?? ""};

    final response = await _restClient.postData(
        url: isSavedQuestions
            ? AppUrl.getSQChildCategory
            : AppUrl.getChildCategory,
        payload: requestBody,
        headers: getHeaders());
    try {
      return GetAllQuizCategory.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<GetAllQuizCategory?> getPreviousChildCategories(
      {required String page, required String subCategoryId}) async {
    Map requestBody = {"page": page, "sub_category": subCategoryId ?? ""};
    final response = await _restClient.postData(
        url: AppUrl.getPreviousChildCategory,
        payload: requestBody,
        headers: getHeaders());
    try {
      return GetAllQuizCategory.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<SaveQuestionModel?> getSavedQuestionApi(
      {required dynamic jsonBody}) async {
    final response = await _restClient.postData(
        url: AppUrl.saveQuestionList,
        payload: jsonBody,
        headers: getHeaders());
    try {
      return SaveQuestionModel.fromJson(response);
    } catch (e) {
      checkException(e);
      print(e.toString());
      return null;
    }
  }

  Future<QuestionDetailModel?> getQuestionDetailsApi(
      {required dynamic jsonBody}) async {
    final response = await _restClient.postData(
        url: AppUrl.getQuestionDetails,
        payload: jsonBody,
        headers: getHeaders());
    print("response ${response}");
    try {
      return QuestionDetailModel.fromJson(response);
    } catch (e) {
      checkException(e);
      print(e.toString());
      return null;
    }
  }

  Future<AttemptedExamModel?> getAttemptedExam({required String page}) async {
    Map requestBody = {
      "page": page,
    };
    final response = await _restClient.getData(
        url: AppUrl.attemtedExams,
        /* payload: requestBody*/ headers: getHeaders());
    try {
      return AttemptedExamModel.fromJson(response);
    } catch (e) {
      print(e);
      checkException(e);
      return null;
    }
  }

  Future<CMSPAGES?> cmsPages() async {
    final response = await _restClient.getData(
        url: "${AppUrl.cms_pages}", headers: getHeaders());
    try {
      return CMSPAGES.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<YoutubeListModel?> videoListPro({required String id}) async {
    Map requestBody = {"category_id": id};

    print(requestBody);
    final response = await _restClient.postData(
        url: AppUrl.getYoutubeLinks,
        payload: requestBody,
        headers: getHeaders());
    try {
      return YoutubeListModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<VideoCategoriesModel?> videoCatPro() async {
    final response = await _restClient.getData(
        url: AppUrl.getAllCategoriesVideoCount, headers: getHeaders());

    try {
      return VideoCategoriesModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<NotificationRespoModel?> notificationList() async {
    final response = await _restClient.getData(
        url: "${AppUrl.notification_list}", headers: getHeaders());

    try {
      return NotificationRespoModel.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ReadedNotification?> notificationRead(
      {required String notificationId}) async {
    Map requestBody = {"notification_id": notificationId};

    final response = await _restClient.postData(
        url: "${AppUrl.read_notification}",
        payload: requestBody,
        headers: getHeaders());
    try {
      return ReadedNotification.fromJson(response);
    } catch (e) {
      checkException(e);
      return null;
    }
  }

  Future<ReadedNotification> clearALlNotificationProvider() async {
    final response = await _restClient.postData(
        url: "${AppUrl.clear_notification}", headers: getHeaders());
    return ReadedNotification.fromJson(response);
  }
}

void checkException(Object exception) {
  if (exception is ServerException) {
    Get.snackbar(
      "Http status error [500]",
      (exception).message.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else if (exception is ClientException) {
    Fluttertoast.showToast(
        msg: (exception as ClientException).message.toString());
    Get.snackbar(
      "Http status error [500]",
      (exception as ClientException).message.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } else if (exception is HttpException) {
    Get.snackbar(
      "Network",
      "Please check your internet connection.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
