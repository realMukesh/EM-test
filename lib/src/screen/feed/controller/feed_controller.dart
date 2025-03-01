import 'package:english_madhyam/restApi/api_service.dart';
import 'package:english_madhyam/src/screen/feed/model/feed_model.dart'as feed;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FeedController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var loading = true.obs;
  var wordOfDayList = <feed.Dataum>[].obs;
  var phraseList = <feed.Dataum>[].obs;
  Rx<int> pageCounter = 1.obs;
 Rx<feed.Data> currentData=feed.Data().obs;

  // Rx<FeedModel> feeds = FeedModel().obs;
  late AnimationController _feedAnimation;
  late Animation _animation;

  Animation get animation => _animation;
  late PageController _pageController;

  PageController get pageController => _pageController;

  //var isFirstLoadRunning = false.obs;
  var isLoadMoreRunning = false.obs;
  late bool hasNextPage;

  //late int _pageNumber;
  int pageNumber = 1;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    _feedAnimation =
        AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _animation = Tween<double>(begin: 0, end: 1).animate(_feedAnimation)
      ..addListener(() {
        update();
      });
    _pageController = PageController();
    _feedAnimation.forward();
    super.onInit();
  }
  //
  Future<void> feedApiFetch(
      {required String type,
      required String date,
      required int currentPage}) async {
    try {
      loading(true);
      feed.FeedModel? response = await apiService.getFeed(
          type: type, date: date, currentPage: currentPage);

      if (response != null) {

        if (type == "word" && response.data?.wordOfDay != null) {
          currentData.value=response.data!;
          phraseList.clear();
          wordOfDayList.insertAll(wordOfDayList.length, response.data!.wordOfDay!.data!);
          Future.delayed(Duration(seconds: 2),(){
            loading(false);
          });

        } else {
          currentData.value=response.data!;
          wordOfDayList.clear();
          phraseList.insertAll(phraseList.length, response.data!.phrase!.data!);
          Future.delayed(Duration(seconds: 2),(){
            loading(false);
          });
        }
      }
    } catch (e) {
      loading(false);
    } finally {
      loading(false);
    }
  }
//end
}
