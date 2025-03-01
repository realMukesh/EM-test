import 'package:get/get.dart';
import 'package:english_madhyam/restApi/api_service.dart';
import '../model/LeadboardModel.dart';

class LeaderboardController extends GetxController {
  var loading = false.obs;
  var isFirstLoadRunning = false.obs;
  var leaderBoardData = <Leadboard>[].obs;
  var examId = "";
  var cateID = "";

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      examId = Get.arguments["examId"];
    }
    getLeaderboardApi(isRefresh: false);
  }

  Future<void> getLeaderboardApi({required isRefresh}) async {
    if (!isRefresh) {
      isFirstLoadRunning(true);
    }
    LeadboardModel? model = await apiService.getLeaderboardPage(examId: examId);
    isFirstLoadRunning(false);
    if (model?.data == "success") {
      leaderBoardData.clear();
      leaderBoardData.addAll(model?.leadboard ?? []);
    }
  }

  @override
  void dispose() {
    super.dispose();
    loading(false);
  }
}
