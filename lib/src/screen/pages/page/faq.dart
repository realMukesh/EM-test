import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';

import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/pages/controller/cms_controller.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'converter.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  bool tap = false;
  final CMSSController _cmsController = Get.put(CMSSController());
  HtmlConverter _htmlConverter = HtmlConverter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: whiteColor,
        appBar: AppBar(
            elevation: 0.0,
            title: const ToolbarTitle(
              title: "FAQ's",
            )),
        body: Obx(() {
          if (_cmsController.loading.value) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(
                child: Lottie.asset(
                  "assets/animations/loader.json",
                  height: MediaQuery.of(context).size.height * 0.14,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: _cmsController.cmsData.value.cmsPages!.faqs!.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              return Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: homeColor),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      trailing: const Icon(
                        Icons.arrow_drop_down_outlined,
                        color: Colors.black,
                      ),
                      textColor: blackColor,
                      //collapsedBackgroundColor: lightGreyColor,
                      // collapsedIconColor: blackColor,
                      iconColor: blackColor,
                      title: CommonTextViewWidget(
                        text: _cmsController
                            .cmsData.value.cmsPages!.faqs![index].question
                            .toString(),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,maxLine: 4,
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 14.0, right: 14, bottom: 10),
                          child: CommonTextViewWidget(
                            text: _htmlConverter.parseHtmlString(_cmsController
                                .cmsData.value.cmsPages!.faqs![index].answer
                                .toString()),fontWeight: FontWeight.normal,fontSize: 14,
                            maxLine: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }));
  }
}
