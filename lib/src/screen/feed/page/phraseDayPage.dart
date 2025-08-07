import 'package:english_madhyam/src/screen/feed/controller/feed_controller.dart';
import 'package:english_madhyam/src/screen/feed/page/cardSlider_widget.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../resrc/widgets/loading.dart';
import '../../../../resrc/helper/bindings/feed_bindings/feed_bind.dart';
import '../../pages/page/converter.dart';

class PhraseDayPge extends StatefulWidget {
  final Function(int pageCount) paginationCallback;
  final FeedController controller;

  const PhraseDayPge({Key? key,required this.paginationCallback,required this.controller}) : super(key: key);

  @override
  _PhraseDayPgeState createState() => _PhraseDayPgeState();
}

class _PhraseDayPgeState extends State<PhraseDayPge> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: purpleColor.withOpacity(0.001),
        body: GetX<FeedController>(
          init: widget.controller,
          builder: (controller) {
            return child(controller);
          },
        ));
  }

  Widget child(FeedController controller) {
    if (controller.loading.value) {
      return Loading();
    } else {
      if (controller.phraseList.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset('assets/animations/49993-search.json',
                  height: MediaQuery.of(context).size.height * 0.15),
            ),
            CustomDmSans(text: "No Phrase Today")
          ],
        );
      } else {
        return Column(
          children: [
            CardSliderWidget(
              feedData: controller.currentData.value.phrase!,

              list: controller.phraseList,
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
