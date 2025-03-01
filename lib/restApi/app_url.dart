class AppUrl {
  //static const String baseUrl = 'https://englishmadhyam.info/api';

  static const String baseUrl = 'http://13.126.114.128/api';

  static const String send_otp = baseUrl + '/send_otp_v2';
  static const String login = baseUrl + '/login_v2';
  static const String signup = baseUrl + '/register_v2';
  static const String googleLogin = baseUrl + '/auth/google-login';

  static const String getAllCategories = baseUrl + '/getAllCategories';
  static const String getParentCategories = baseUrl + '/getParentCategories';
  static const String getSQParentCategories =
      baseUrl + '/getSQParentCategories';
  //get by post parent_category
  static const String getSubcategory = baseUrl + '/getSubCategories';
  static const String getSQSubcategory = baseUrl + '/getSQSubCategories';
  //get by post sub_category
  static const String getChildCategory = baseUrl + '/getChildCategories';
  static const String getSQChildCategory = baseUrl + '/getSQChildCategories';
  ////get by previous post sub_category
  static const String getPreviousChildCategory =
      baseUrl + '/getChildCategories';

  static const String attemtedExams = baseUrl + '/attemptedExams';
  static const String reportQuestion = baseUrl + "/report-question";


  /*manage the question list*/
  static const String getQuestionDetails = baseUrl + "/get_sq_question";
  static const String saveQuestionList = baseUrl + "/get_sq_questions_list";
  static const String save_question = baseUrl + "/save_question";
  static const String get_sq_categories = baseUrl + "/get_sq_categories";
  static const String remove_saved_question =
      baseUrl + "/rm_saved_question";

  static const String logout = baseUrl + "/logout";
  static const String getAppVersion = baseUrl + "/app_version";
  static const String getDeviceInfo = baseUrl + "/dev/device_info";
  static const String categoryTypeList = baseUrl + "/categoryTypeList";
  static const String subscriptionPlans = baseUrl + "/subscription_plans";
  static const String getEditorials = baseUrl + "/get_editorials";
  static const String startExam = baseUrl + "/startExam";
  static const String pauseExam = baseUrl + "/pause_exam";
  static const String attemptQuestion = baseUrl + "/attempt_question";
  static const String submitExam = baseUrl + "/submit_exam";
  static const String editorialDetails = baseUrl + "/editorial_details";
  static const String getPdfList = baseUrl + "/get-pdf-list";
  static const String get_editorials_by_category =
      baseUrl + "/get_editorials_by_category";
  static const String editorial_vocab = baseUrl + "/editorial_vocab";
  static const String editorial_vocabs_list =
      baseUrl + "/editorial_vocabs_list";
  static const String exam_details = baseUrl + "/exam_details";
  static const String daily_learnings_v2 = baseUrl + "/daily_learnings_v2";
  static const String graphData = baseUrl + "/graphData";
  static const String home = baseUrl + "/home";
  static const String check_payment = baseUrl + "/check_payment";
  static const String create_order = baseUrl + "/create-order";


  static const String apply_coupon = baseUrl + "/apply_coupon";
  static const String coupons_list = baseUrl + "/coupons_list";
  static const String purchase_history = baseUrl + "/purchase_history";
  static const String profile = baseUrl + "/profile";
  static const String StudentsLeadboard = baseUrl + "/StudentsLeadboard";
  static const String update_profile = baseUrl + "/update_profile";
  static const String exam_list = baseUrl + "/exam_list";

  static const String save_word = baseUrl + "/save_word";
  static const String words_list = baseUrl + "/words_list";
  static const String remove_word = baseUrl + "/remove_word";
  static const String cms_pages = baseUrl + "/cms_pages";
  static const String getYoutubeLinks = baseUrl + "/getYoutubeLinks";
  static const String getAllCategoriesVideoCount =
      baseUrl + "/getAllCategoriesVideoCount";
  static const String notification_list = baseUrl + "/notification_list";
  static const String read_notification = baseUrl + "/read_notification";
  static const String clear_notification = baseUrl + "/clear_notification";
}
