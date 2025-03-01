import 'package:english_madhyam/src/screen/savedQuestion/controller/questionController.dart';
import 'package:english_madhyam/src/screen/savedQuestion/controller/questionDetailController.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';

import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/src/widgets/question_widget.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../custom/rounded_button.dart';
import '../../pages/page/converter.dart';

const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

class SavedQuestionDetailPage extends StatefulWidget {
  static const routeName = "/SavedQuestionDetailPage";
  SavedQuestionDetailPage({Key? key}) : super(key: key);

  @override
  _SavedQuestionDetailPageState createState() =>
      _SavedQuestionDetailPageState();
}

class _SavedQuestionDetailPageState extends State<SavedQuestionDetailPage> {
  TextEditingController reportQuestionController = TextEditingController();
  final QuestionDetailController controller = Get.find();
  final QuestionController questionController = Get.find();

  final HtmlConverter _htmlConverter = HtmlConverter();

  bool valueUpdated = false;
  int selectedQuestion = 0;
  int selectedOption = 0;
  int selectedOptionIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: const ToolbarTitle(
          title: 'Saved Exam',
        ),
      ),
      body: GetX<QuestionDetailController>(
        builder: (controller) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(15.adaptSize),
                child: controller.examDetails.isNotEmpty && controller.examDetails.length>selectedQuestion
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  questionWidget(),
                                  optionsWidget(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            CommonTextViewWidget(
                                              text: "Solutions :",
                                              color: greenColor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Html(
                                                data: controller.examDetails[
                                                selectedQuestion]
                                                    .solutions!
                                                    .eSolutions ??
                                                    "",
                                                style: {
                                                  "body": Style(
                                                      fontSize: FontSize(14.0),
                                                      fontFamily:
                                                      GoogleFonts.poppins()
                                                          .fontFamily),
                                                  "p": Style(
                                                      fontSize: FontSize(16.0))
                                                },
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    height: 150.adaptSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: bottomButtons(),
              ),
              controller.loading.value ? const Loading() : const SizedBox()
            ],
          );
        },
      ),
    );
  }

// View Next Question
  Future<void> viewNextQuestion() async {
    if (selectedQuestion + 1 < questionController.saveQuestionList.length) {

      _incrementQuestion();
      controller.getQuestionDetails(
          catId:
              questionController.saveQuestionList[selectedQuestion]?.sqCatId ??
                  "",
          questionId: questionController
                  .saveQuestionList[selectedQuestion]?.questionId ??
              "");
    }
  }

// View Previous Question
  void viewPrevQuestion() {
    if (selectedQuestion > 0) {
      _decrementQuestion();
    } else {
      Fluttertoast.showToast(msg: "No previous question found");
      cancel();
    }
  }

// Utility Methods
  void _incrementQuestion() {
    setState(() {
      selectedQuestion++;
    });
  }

  void _decrementQuestion() {
    setState(() {
      selectedQuestion--;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  //check by mukesh
  Widget questionWidget() {
    return QuestionWidget(
      questionString:
          controller.examDetails[selectedQuestion].eQuestion.toString(),
    );
  }

//check by mukesh
  Widget optionsWidget() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
                controller.examDetails[selectedQuestion].options!.length, (j) {
              return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          /// check wheter selected option is selected or not
                          color: controller.examDetails[selectedQuestion]
                                      .options![j].correct ==
                                  1
                              ? greenColor
                              : Colors.grey,
                          offset: const Offset(0.0, 1.0), //(x,y)
                          blurRadius: 4.0,
                        ),
                      ],
                      border: Border.all(
                          color: controller.examDetails[selectedQuestion]
                                      .options![j].correct ==
                                  1
                              ? greenColor
                              : whiteColor,
                          width: 2),
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.only(
                      left: 10, top: 5, bottom: 5, right: 10),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(50)),
                        width: 30,
                        height: 30,
                        child: Center(
                          child: CommonTextViewWidgetDarkMode(
                              text: chars[j],
                              fontSize: 16,
                              color: blackColor,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      (controller.examDetails[selectedQuestion].options![j]
                                  .optionE ==
                              null)
                          ? const Text("")
                          : Expanded(
                              child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: CommonTextViewWidgetDarkMode(
                                    text: _htmlConverter.removeAllHtmlTags(
                                        controller.examDetails[selectedQuestion]
                                            .options![j].optionE
                                            .toString()),
                                    fontSize: 16,
                                    color: colorSecondary,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ),
                    ],
                  ));
            })));
  }

//check by mukesh
  Widget bottomButtons() {
    return Container(
        height: 90.adaptSize,
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 4.0,
          ),
        ], color: whiteColor),
        padding: const EdgeInsets.only(top: 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 4,
                child: (selectedQuestion <= 0)
                    ? Container()
                    : CircularRoundedButton(
                        color: colorSecondary,
                        height: 50.adaptSize,
                        text: "Previous",
                        textSize: 14,
                        press: () {
                          viewPrevQuestion();
                        }),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  flex: 4,
                  child: (selectedQuestion == null
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.all(0),
                          child: CircularRoundedButton(
                              textSize: 14,
                              color: colorPrimary,
                              height: 50.adaptSize,
                              text: selectedQuestion + 1 <
                                      questionController.saveQuestionList.length
                                  ? "Next"
                                  : "End",
                              press: () {
                                viewNextQuestion();
                              }))))
            ],
          ),
        ));
  }
}
