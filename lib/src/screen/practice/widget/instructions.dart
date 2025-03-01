import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/exam/page/startExamPage.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../widgets/rounded_button.dart';
import '../../exam/controller/examDetailController.dart';
import '../../pages/page/converter.dart';

class TestInstructions extends StatefulWidget {
  final int examid;
  final String title;
  final String catTitle;
  final int type;

  const TestInstructions({
    Key? key,
    required this.type,
    required this.catTitle,
    required this.examid,
    required this.title,
  }) : super(key: key);

  @override
  _TestInstructionsState createState() => _TestInstructionsState();
}

class _TestInstructionsState extends State<TestInstructions> {
  final ExamDetailController controller = Get.find();
  final HtmlConverter _htmlConverter = HtmlConverter();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: false,
        title: const ToolbarTitle(title: "Instructions"),
      ),
      body: widget.examid == 0
          ? _buildNoQuestionsAvailable(mediaQuery)
          : _buildExamInstructions(mediaQuery),
    );
  }

  Widget _buildNoQuestionsAvailable(Size mediaQuery) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Lottie.asset('assets/animations/49993-search.json',
              height: mediaQuery.height * 0.14),
        ),
        CommonTextViewWidget(
          text: "No Questions Available",
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildExamInstructions(Size mediaQuery) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: Colors.greenAccent,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: GetX<ExamDetailController>(
            init: ExamDetailController(),
            builder: (controller) {
              if (controller.loading.value) {
                return Center(
                  child: Lottie.asset("assets/animations/loader.json",
                      height: mediaQuery.height * 0.1),
                );
              }

              final content = controller.examDetails.value.content;
              if (content?.examQuestion == null ||
                  content!.examQuestion!.isEmpty) {
                return _buildNoQuestionsAvailable(mediaQuery);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextViewWidget(
                    text:
                        "${content.title ?? ''}   : ${content.publishAt?.substring(0, 10) ?? ''}",
                    color: redColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 15),
                  CommonTextViewWidget(
                    text: "General instructions",
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 15),
                  CommonTextViewWidget(
                    text:
                        "Please read the following instructions very carefully",
                    color: blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 10),
                  CommonTextViewWidget(
                      text:
                          "Negative Marking : - ${content.negativeMark ?? ''}"),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: CommonTextViewWidget(
                      text: _htmlConverter
                          .removeAllHtmlTags(content.instruction ?? ''),
                      fontSize: 14,
                      color: blackColor,
                      letterspace: 0.1,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ..._buildInstructionIcons(),
                  const SizedBox(height: 20),
                  _buildStartButton(mediaQuery),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInstructionIcons() {
    final instructions = [
      {
        'color': lightGreyColor,
        'text': "You have not Visited the Question Yet.",
      },
      {
        'color': redColor,
        'text': "You have not answered the Question.",
      },
      {
        'color': greenColor,
        'text':
            "You have NOT answered the question but have marked the question for review.",
      },
      {
        'color': magenttaColor,
        'text': "You have answered the question but marked it for review.",
      },
    ];

    return instructions.map((instruction) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: instruction['color'] as Color,
                borderRadius: instruction['color'] == magenttaColor
                    ? BorderRadius.circular(60)
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CommonTextViewWidget(
                text: instruction['text'] as String,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildStartButton(Size mediaQuery) {
    return RoundedButton(
      press: () {
        controller.startExam(id: widget.examid);
        Get.off(() => StartExamPage(
              reviewExam: false,
              examDetails: controller.examDetails.value,
              title: controller.examDetails.value.content!.isDailyQuiz == 1
                  ? widget.catTitle
                  : widget.title,
              type: widget.type,
            ));
      },
      text: controller.examDetails.value.content!.isAttempt == 1
          ? "Resume Test"
          : 'Start Test',
    );
  }
}
