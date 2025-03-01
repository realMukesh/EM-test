import 'package:english_madhyam/routes/my_constant.dart';
import 'package:english_madhyam/src/screen/home/model/home_model/home_model.dart';
import 'package:english_madhyam/src/screen/pages/page/setup.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../widgets/common_textview_widget.dart';

class Achieverstake extends StatefulWidget {
  final List<Achievers> achievers;
  const Achieverstake({Key? key, required this.achievers}) : super(key: key);

  @override
  State<Achieverstake> createState() => _AchieverstakeState();
}

class _AchieverstakeState extends State<Achieverstake> {
  final CarouselController _sliderController = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55.adaptSize,
      ),
      child: Container(
        decoration: BoxDecoration(
            //color: Colors.white70,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: purpleColor.withOpacity(0.13),
                  offset: const Offset(0, 4),
                  blurRadius: 1,
                  spreadRadius: 2)
            ]),
        child: achieverSlider(context),
      ),
      // child: achieverSlider(context),
    );
  }

  Widget achieverSlider(BuildContext ctx) {
    final List<Widget> imageSliders = widget.achievers
        .map((item) => Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonTextViewWidget(
                  text: "Our Achievers Take",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.14,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image:
                              NetworkImage((item.image).toString(), scale: 0.2),
                          fit: BoxFit.contain),
                      border: Border.all(color: gradientLigthblue, width: 1)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Flexible(
                  child: CommonTextViewWidget(
                    text: (item.userName).toString(),
                    fontSize: 18,
                    align: TextAlign.center,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: CommonTextViewWidget(
                    text:
                        item.exam_name == null ? "" : item.exam_name.toString(),
                    fontSize: 18,
                    align: TextAlign.center,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Divider(
                  color: greyColor,
                ),
                GestureDetector(
                  onTap: () {
                    UiHelper.showINfoDialog(item.description ?? "");
                  },
                  child: Html(
                    data: item.description ?? "",
                    style: {
                      "p": Style(
                          fontSize: FontSize(14.fSize),
                          textAlign: TextAlign.justify,
                          maxLines: 5,fontFamily: MyConstant.currentFont)
                    },
                  ),
                )
              ],
            ))
        .toList();

    return Column(mainAxisSize: MainAxisSize.min, children: [
      Expanded(
        child: CarouselSlider(
          items: imageSliders,
          carouselController: _sliderController,
          options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 1,
              autoPlay: true,
              aspectRatio: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.achievers.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () {
              _sliderController.animateToPage(
                entry.key,
              );
            },
            child: Container(
              width: 12,
              height: 12,
              margin: EdgeInsets.all(2),
              decoration: _current == entry.key
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      color: gradientBlue.withOpacity(0.9))
                  : BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: gradientBlue.withOpacity(0.9), width: 1.3),
                      color: whiteColor),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
