import 'package:english_madhyam/resrc/helper/api_repository/api_service.dart';
import 'package:english_madhyam/resrc/models/model/feed_model/feed_model.dart'as feed;
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
          /// if current page is greater than 2 then reorder list
          /// and add first 20 data at last
          /// list=d,e,f,a,b,c
          /// new list =g,h,i
          /// list=g,h,i,a,b,c,d,e,f
          ///
          // if (currentPage > 2) {
          //   var reorderList = wordOfDayList.sublist(0, 20);
          //   wordOfDayList.removeRange(0, 20);
          //
          //   wordOfDayList.insertAll(wordOfDayList.length, reorderList);
          // }

          phraseList.clear();
          wordOfDayList.insertAll(wordOfDayList.length, response.data!.wordOfDay!.data!);
          Future.delayed(Duration(seconds: 2),(){
            loading(false);
          });

        } else {
          // if (currentPage > 2) {
          //   var reorderList = phraseList.sublist(0, 20);
          //   phraseList.removeRange(0, 20);
          //
          //   phraseList.insertAll(phraseList.length, reorderList);
          // }
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

  //start
  Future<void> getFeedListApi({required bool isRefresh}) async {
    if (!isRefresh) {
      loading(true);
    }
    feed.FeedModel? model = await apiService.getFeedPagination(
      page: pageNumber,
    );
    if (model!.result == true) {
      wordOfDayList.clear();
      wordOfDayList.addAll(model.data?.wordOfDay?.data ?? []);
      if (model.data?.wordOfDay?.total != null &&
          pageNumber < model.data!.wordOfDay!.total!) {
        pageNumber = pageNumber + 1;
        hasNextPage = true;
      } else {
        hasNextPage = false;
      }
      if (hasNextPage) {
        //getPracticeChildLoadMore();
      }
      loading(false);
    } else {
      loading(false);
    }
  }

  Future<void> getPracticeChildLoadMore() async {
    pageController.addListener(() async {
      if (hasNextPage == true &&
          loading.value == false &&
          isLoadMoreRunning.value == false &&
          pageController.position.maxScrollExtent ==
              pageController.position.pixels) {
        isLoadMoreRunning(true);
        try {
          feed.FeedModel? model =
              await apiService.getFeedPagination(page: pageNumber);
          if (model!.result == true) {
            if (model.data?.wordOfDay?.total != null &&
                pageNumber < model.data!.wordOfDay!.total!) {
              pageNumber = pageNumber + 1;
              hasNextPage = true;
            } else {
              hasNextPage = false;
            }
            print("has next page$hasNextPage");
            wordOfDayList.addAll(model.data?.wordOfDay?.data ?? []);
            update();
          }
        } catch (e) {
          print(e.toString());
        }
        isLoadMoreRunning(false);
      }
    });
  }
//end
}
