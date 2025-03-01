import 'package:english_madhyam/src/screen/videos_screen/model/video_cat_model.dart';
import 'package:english_madhyam/src/screen/videos_screen/model/youtube_list.dart';
import 'package:get/get.dart';
import 'package:english_madhyam/restApi/api_service.dart';

class VideoController extends GetxController {
  RxBool loading = true.obs;
  RxBool catLoading = true.obs;
  Rx<YoutubeListModel> videoList = YoutubeListModel().obs;
  var freeVideoList = <VideoData>[].obs;
  var paidVideoList = <VideoData>[].obs;

  @override
  void onInit() {
    super.onInit();
    initApiCall();
  }

  Future<bool> videoDetail({required String id}) async {
    var dataNotEmpty = false;
    loading(true);
    try {
      var response = await apiService.videoListPro(
        id: id,
      );
      loading(false);
      if (response != null) {
        dataNotEmpty = true;
        videoList.value = response;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      loading(false);
    }
    return dataNotEmpty;
  }

  void initApiCall() async {
    loading(true);
    try {
      var response = await apiService.videoCatPro();
      loading(false);
      if (response != null && response.categories?.data != null) {
        freeVideoList.clear();
        paidVideoList.clear();
        if (response.categories!.data!.isNotEmpty) {
          freeVideoList.addAll(
              response.categories!.data!.where((i) => i.type == 0).toList());
          paidVideoList.addAll(
              response.categories!.data!.where((i) => i.type == 1).toList());
        }
      } else {
        print("size_data nof fon}");
        return null;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      loading(false);
    }
  }
}
