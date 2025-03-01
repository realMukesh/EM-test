import 'dart:io';

import 'package:english_madhyam/src/screen/home/model/home_model/home_model.dart';
import 'package:english_madhyam/src/screen/payment/page/in_app_plan_page.dart';
import 'package:english_madhyam/src/screen/exam/controller/examDetailController.dart';
import 'package:english_madhyam/src/screen/practice/widget/instructions.dart';
import 'package:english_madhyam/src/screen/practice/widget/performance_report.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/common_textview_widget.dart';
import '../../widgets/free_paid_widget.dart';
import '../profile/controller/profile_controllers.dart';
import '../payment/page/choose_plan_details.dart';

class DailyExamWidget extends StatefulWidget {
  final List<Quizz> quiz;
  final Function(bool) onBackPress;
  const DailyExamWidget({Key? key, required this.quiz, required this.onBackPress})
      : super(key: key);

  @override
  _DailyExamWidgetState createState() => _DailyExamWidgetState();
}

class _DailyExamWidgetState extends State<DailyExamWidget> {
  final ExamDetailController quizController = Get.put(ExamDetailController());
  final ProfileControllers profileControllers = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.quiz.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext ctx, int index) {
          return InkWell(
            onTap: () {
              if (widget.quiz[index].completed == 0) {
                quizController.getExamDetail(id: widget.quiz[index].id ?? 0);
                if (widget.quiz![index].type == 1 &&
                    profileControllers.isSubscriptionActive) {
                  Get.to(() => TestInstructions(
                        examid: widget.quiz[index].id!,
                        title: widget.quiz[index].title.toString(),
                        catTitle: widget.quiz[index].categoryName!,
                        type: 2,
                      ));
                } else if (widget.quiz![index].type == 1 &&
                    profileControllers.isSubscriptionActive==false) {
                  //pay page
                  if (Platform.isAndroid) {
                    Get.toNamed(ChoosePlanDetails.routeName);

                  } else {
                    Get.to(() => TestInstructions(
                          examid: widget.quiz[index].id!,
                          title: widget.quiz[index].title.toString(),
                          catTitle: widget.quiz[index].categoryName!,
                          type: 2,
                        ));
                    Get.to(() => InAppPlanDetail());
                  }
                } else {
                  Get.to(() => TestInstructions(
                        examid: widget.quiz[index].id!,
                        title: widget.quiz[index].title.toString(),
                        catTitle: widget.quiz[index].categoryName!,
                        type: 2,
                      ));
                }
              } else {
                Get.toNamed(PerformanceReportPage.routeName,
                    arguments: {"exam_id": widget.quiz[index].id.toString(),
                      "title": widget.quiz[index].title.toString(),
                      "route": 1,
                      "cate_id": widget.quiz[index].id.toString()});
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.88,
              margin: const EdgeInsets.only(right: 10, bottom: 4),
              padding:
                  const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: greyColor.withOpacity(0.2), width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 70.adaptSize,
                    width: 70.adaptSize,
                    //width: MediaQuery.of(context).size.width * 0.25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeYellowColor.withOpacity(0.15),
                        image: widget.quiz[index].image != ""
                            ? DecorationImage(
                                image: NetworkImage(
                                  widget.quiz[index].image.toString(),
                                ),
                                scale: 1.2,
                                fit: BoxFit.cover)
                            : const DecorationImage(
                                image:
                                    AssetImage("assets/img/place_holder.png"),
                                scale: 1.2,
                                fit: BoxFit.cover)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonTextViewWidget(
                          text: widget.quiz[index].title??"",
                          fontSize: 16,maxLine: 1,
                          fontWeight: FontWeight.w500,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              CommonTextViewWidget(
                                text: "${widget.quiz[index].totalQuestion!} Question.",
                                fontSize: 14,color: colorGray,
                                fontWeight: FontWeight.normal,maxLine: 1,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              widget.quiz[index].duration != ""
                                  ? CommonTextViewWidget(
                                      text: "${widget.quiz[index].duration}  Mins",
                                      fontSize: 14,maxLine: 1,
                                      fontWeight: FontWeight.normal,color: colorGray,
                                    )
                                  : const Text(""),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: CommonTextViewWidget(
                            text: widget.quiz[index].categoryName ?? "",
                            maxLine: 1,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: colorGray,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FreePaidWidget(
                              type: widget.quiz[index].type,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
