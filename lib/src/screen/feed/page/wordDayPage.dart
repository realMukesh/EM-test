import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/screen/feed/controller/feed_controller.dart';
import 'package:english_madhyam/src/screen/feed/page/cardSlider_widget.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordDayPage extends StatefulWidget {
  final Function(int pageCount) paginationCallback;
  final FeedController controller;

  const WordDayPage({Key? key, required this.paginationCallback,required this.controller}) : super(key: key);

  @override
  _WordDayPageState createState() => _WordDayPageState();
}

class _WordDayPageState extends State<WordDayPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: purpleColor.withOpacity(0.001),
      body: GetX<FeedController>(
        init: widget.controller,
        builder: (controller) {

          return child(controller);
        },
      ),
    );
  }

  Widget child(FeedController controller) {
    if (controller.loading.value) {
      return Loading();
    } else {
      if (controller.wordOfDayList.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset('assets/animations/49993-search.json',
                  height: MediaQuery.of(context).size.height * 0.15),
            ),
            CommonTextViewWidget(text: "No Words Today")
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CardSliderWidget(
              feedData: controller.currentData.value.wordOfDay!,
              list: controller.wordOfDayList,

              paginationCallback: (page) {
                widget.paginationCallback(page);

                  controller.pageCounter.value=page;
              },
              currentPageCount: controller.pageCounter.value,
            ),
          ],
        );
      }
    }
  }


}
