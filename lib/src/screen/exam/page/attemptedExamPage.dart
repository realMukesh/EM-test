import 'dart:ui';
import 'package:english_madhyam/src/screen/exam/model/exam_detail_model.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/exam/controller/examDetailController.dart';
import 'package:english_madhyam/src/screen/favorite/controller/favoriteController.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/src/widgets/question_widget.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../utils/ui_helper.dart';
import '../../../custom/rounded_button.dart';
import '../../../widgets/button/custom_icon_button.dart';
import '../../../widgets/custom_dialog_widget.dart';
import '../../pages/page/converter.dart';
import '../../profile/controller/profile_controllers.dart';
import '../../savedQuestion/controller/questionController.dart';

class AttemptedExamPage extends StatefulWidget {
  final ExamDetailsModel examDetails;
  final String title;
  final bool reviewExam;
  final int type;

  const AttemptedExamPage(
      {Key? key,
      required this.title,
      required this.type,
      required this.examDetails,
      required this.reviewExam})
      : super(key: key);

  @override
  _AttemptedExamPageState createState() => _AttemptedExamPageState();
}

class _AttemptedExamPageState extends State<AttemptedExamPage> {
  final ExamDetailController _quizDetailsController =
      Get.put(ExamDetailController());
  final HtmlConverter _htmlConverter = HtmlConverter();
  final QuestionController _favoriteController = Get.put(QuestionController());
  final ProfileControllers _profileControllers = Get.find();
  TextEditingController reportQuestionController = TextEditingController();

  bool valueUpdated = false;
  bool isRe_attempted = true;
  String? dropdownValue;
  List<String> reportIssues = [
    "Wrong Question",
    "Wrong Answer",
    "Formatting Issue",
    "No Solution",
    "Wrong Translation",
    "Copyright issue",
    "Other"
  ];

  //checked set Colors for question position
  Color getGoToColor(int questionIndex) {
    var questionList = widget.examDetails.content!.examQuestion ?? [];
    if (widget.reviewExam == true) {
      if (questionList[questionIndex].isAttempt == 1) {
        for (int i = 0; i < questionList[questionIndex].options!.length; i++) {
          var optionData = questionList[questionIndex].options![i];
          if (optionData.checked == 1 && optionData.correct == 1) {
            return lightGreenColor;
          } else if (optionData.checked == 1 && optionData.correct != 1) {
            return redColor;
          }
        }
      }
    }
    //default color for un answered
    return greyColor;
  }

  //done by mukesh initialize question index in var
  goToQuestion(int i) {
    if (i < _examQuestion.length && i >= 0) {
      setState(() {
        selectedQuestion = i;
      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

// Give Answer
  giveAnswer(int questionIndex, int optionIndex) async {
    if (optionIndex < _examQuestion[questionIndex].options!.length &&
        optionIndex >= 0 &&
        _examQuestion[questionIndex]
            .options!
            .contains(_examQuestion[questionIndex].options![optionIndex])) {
      for (int k = 0; k < _examQuestion[questionIndex].options!.length; k++) {
        _examQuestion[questionIndex].options![k].attempted = 0;
      }
      _examQuestion[questionIndex].options![optionIndex].attempted = 1;
      setState(() {
        selectedOption = _examQuestion[questionIndex].options![optionIndex].id!;
        //TODO check here the selected option
        _examQuestion[questionIndex].isSelect =
            _examQuestion[questionIndex].options![optionIndex].id;
        _examQuestion[selectedQuestion].isAttempt = 1;
        _examQuestion[selectedQuestion].ansType = 1;
        _examQuestion[selectedQuestion].isREAttmpted = 1;
        print(
            "_examQuestion[questionIndex].isSelect == ${_examQuestion[questionIndex].options![optionIndex].id}");
      });
    } else {
      Fluttertoast.showToast(msg: "Option not exist");
      cancel();
    }
  }

//View Next Questiojn
  nextAndSubmitExam({required String option}) async {
    if ((selectedQuestion + 1) < _examQuestion.length) {
      setState(() {
        selectedQuestion += 1;
      });
    } else {
      //if question is last the exam is submit by clicking on this button
      /// route of saved question list
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogWidget(
            logo: "assets/img/cancel_img.png",
            title: widget.type == 6
                ? "Do you really want to exit?"
                : "Re-Attempted Exam",
            description: widget.type == 6
                ? "Are you sure, You want to exit from Saved Exam Question"
                : "Are you sure, You want to exit from Quiz Exam",
            buttonAction: "Confirm",
            buttonCancel: "Cancel",
            onCancelTap: () {},
            onActionTap: () async {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

//View Prev Question
  viewPrevQuestion() {
    if ((selectedQuestion) > 0) {
      setState(() {
        selectedQuestion -= 1;
      });
    } else {
      Fluttertoast.showToast(msg: "No previous question found");
      cancel();
    }
  }

//Remove Answer
  removeAnswer(int i) async {
    if (i < _examQuestion.length && i >= 0) {
      for (int k = 0; k < _examQuestion[i].options!.length; k++) {
        _examQuestion[i].options![k].checked = 0;
      }
      setState(() {
        _examQuestion[i].isAttempt = 0;
        _examQuestion[i].ansType = 0;
      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

//Mark for review
  markForReview(int i) async {
    if (i < _examQuestion.length && i >= 0) {
      await _favoriteController.bookmarkQuestion(
          context: context, jsonBody: {"question_id": _examQuestion[i].id.toString(),
      },isBookmark: true);
      setState(() {
        _examQuestion[i].isBookmark = 1;
      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

  //UnMark Review
  unMarkForReview(int i) async {
    if (i < _examQuestion.length && i >= 0) {
      await _favoriteController.bookmarkQuestion(
          context: context, jsonBody: {"question_id": _examQuestion[i].id.toString(),
      },isBookmark: false);
      setState(() {
        _examQuestion[i].isBookmark = 0;
      });
    } else {
      Fluttertoast.showToast(msg: "question not found");
      cancel();
    }
  }

  late List<ExamQuestion> _examQuestion;
  final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  int selectedQuestion = 0;
  int selectedOption = 0;
  @override
  void initState() {
    _examQuestion = widget.examDetails.content!.examQuestion ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: ToolbarTitle(
          title: widget.title ?? "Attempted Exam",
        ),
      ),
      body: Stack(
        children: [
          _examQuestion.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                      child: Column(
                    children: [
                      Image.asset("assets/img/norecord.jpg"),
                      CommonTextViewWidget(
                        text: "Solution is no longer available!!",
                        fontSize: 20,
                      )
                    ],
                  )),
                )
              : Padding(
                  padding: EdgeInsets.all(15.adaptSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      indicateMarks(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              questionWidget(),
                              optionsWidget(),
                              (_examQuestion[selectedQuestion].isREAttmpted ==
                                              0 &&
                                          isRe_attempted) &&
                                      _examQuestion[selectedQuestion]
                                              .savedQuestionId ==
                                          null
                                  ? const SizedBox()
                                  : Padding(
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
                                              data: _examQuestion[
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
                              saveRow(),
                              SizedBox(
                                height: 150.adaptSize,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: bottomButtons(),
          ),
        ],
      ),
      endDrawer: endDrawerWidget(context),
    );
  }

  endDrawerWidget(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: context.width * .70,
          decoration: const BoxDecoration(color: white),
          padding: const EdgeInsets.only(top: 12),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(_profileControllers
                      .profileGet.value.user!.image
                      .toString()),
                ),
                title: CommonTextViewWidgetDarkMode(
                  text: _profileControllers.profileGet.value.user!.name
                      .toString(),
                  fontSize: 18,
                  align: TextAlign.start,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: Colors.blueGrey),
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: CommonTextViewWidgetDarkMode(
                      text: "Topic:",
                      color: white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    subtitle: CommonTextViewWidgetDarkMode(
                      text: widget.title.toString(),
                      maxLine: 4,
                      color: white,
                      fontSize: 14,
                    )),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    labelCreate(Colors.grey, "Not Answered"),
                    labelCreate(Colors.red, "Wrong answered"),
                  ],
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: labelCreate(Colors.green, "Answered"),
              ),
              const Divider(),
              Expanded(child: questionIndexWidget()),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
                padding: const EdgeInsets.only(top:30 ,right: 20),
                child: SvgPicture.asset("assets/icon/close_icon.svg",height: 40.adaptSize,)),
          ),
        ),
      ],
    );
  }

  Widget indicateMarks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CommonTextViewWidget(
            text: "Que No.${selectedQuestion + 1}",
            fontWeight: FontWeight.bold),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextViewWidgetDarkMode(text: "Marks:"),
            const SizedBox(
              width: 6,
            ),
            Container(
              //width: 50,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child: CommonTextViewWidgetDarkMode(
                  color: white,
                  text:
                      "+ ${widget.examDetails.content?.mark.toString() ?? ""}"),
            ),
            const SizedBox(
              width: 6,
            ),
            Container(
              //width: 50,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              child: CommonTextViewWidgetDarkMode(
                  color: white,
                  text:
                      "- ${widget.examDetails.content?.negativeMark.toString() ?? ""}"),
            )
          ],
        )
      ],
    );
  }

  Widget labelCreate(MaterialColor materialColor, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: materialColor, borderRadius: BorderRadius.circular(5)),
        ),
        const SizedBox(
          width: 6,
        ),
        FittedBox(
            child: CommonTextViewWidgetDarkMode(
          text: title,
          fontSize: 12,
        ))
      ],
    );
  }

  //check by mukesh
  Widget questionIndexWidget() {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.examDetails.content!.examQuestion!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1 / 1,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15),
      itemBuilder: (BuildContext context, int i) {
        var data=widget.examDetails.content!.examQuestion?[i];
        return InkWell(
          onTap: () {
            goToQuestion(i);
            Get.back();
          },
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: getGoToColor(i),
                border: Border.all(color: i != selectedQuestion?Colors.transparent:green,width: 3),
                borderRadius: BorderRadius.circular(5)),
            width: 30,
            height: 30,
            child: Stack(
              children: [
                Center(
                  child: CommonTextViewWidgetDarkMode(
                    text: (i + 1).toString(),
                    color: whiteColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )/*Container(
          color: Colors.red,
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  goToQuestion(i);
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: getGoToColor(i),
                      borderRadius: BorderRadius.circular(5)),
                  width: 30,
                  height: 30,
                  child: Stack(
                    children: [
                      Center(
                        child: CommonTextViewWidget(
                          text: (i + 1).toString(),
                          color: whiteColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (i != selectedQuestion)
                  ? Container()
                  : Divider(
                color: greyColor,
                height: 10,
                thickness: 2,
              )
            ],
          ),
        )*/;
      },
    );
  }

  Widget saveRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconButton(
            width: 150.adaptSize,
            height: 30,
            onTap: () {
              if (_examQuestion[selectedQuestion].isBookmark == 0) {
                markForReview(selectedQuestion);
              } else {
                unMarkForReview(selectedQuestion);
              }
            },
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: (_examQuestion[selectedQuestion].isBookmark == 0)
                        ? Colors.grey
                        : purpleColor,
                    width: 1)),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonTextViewWidget(
                      text: (_examQuestion[selectedQuestion].isBookmark == 0)
                          ? "Save"
                          : "Saved",
                      fontSize: 14,
                      color: (_examQuestion[selectedQuestion].isBookmark == 0)
                          ? Colors.grey
                          : purpleColor,
                      fontWeight: FontWeight.w500),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    (_examQuestion[selectedQuestion].isBookmark == 0)
                        ? Icons.star_border
                        : Icons.star,
                    size: 20.adaptSize,
                    color: (_examQuestion[selectedQuestion].isBookmark == 0)
                        ? Colors.grey
                        : purpleColor,
                  ),
                ],
              ),
            ),
          ),
          reportQuestion(),
        ],
      ),
    );
  }

  Widget reportQuestion() {
    return Container(
      height: 30,
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0), // Border
        // Background color of the dropdown
        borderRadius: BorderRadius.circular(6.0), // Rounded corners
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          padding: EdgeInsets.zero,
          hint: CommonTextViewWidget(text: "Report"),
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              print("New Value $newValue");
              dropdownValue = newValue!;
              showDialog(
                  context: context,
                  builder: (context) {
                    return reportDialog();
                  });
              print("New Value $dropdownValue");
            });
          },
          items: reportIssues.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: CommonTextViewWidget(text: value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget reportDialog() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(12),
          // height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextViewWidget(
                    text: dropdownValue.toString(),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        size: 30,
                      ))
                ],
              ),
              TextFormField(
                controller: reportQuestionController,
                maxLines: 5,
                // expands: true,
                // maxLines: null,
                // minLines: null,
                decoration: InputDecoration(
                  hintText:
                      "Please Tell us more about the issue (at least 7-8 words) for the quick resolutions",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Divider(
                height: 40,
                color: Colors.grey,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purpleColor,
                      // primary: purpleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      var requestBody = {
                        "exam_id": widget.examDetails.content!.id.toString(),
                        "report_type": dropdownValue.toString(),
                        "message": reportQuestionController.text,
                        "q_id": widget.examDetails.content!
                            .examQuestion![selectedQuestion].id
                            .toString()
                      };
                      _quizDetailsController.reportQuiz(requestBody);
                      Navigator.of(context).pop();
                    },
                    child: CommonTextViewWidget(
                      text: "Submit",
                      color: Colors.white,
                      fontSize: 20,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget questionWidget() {
    return QuestionWidget(
      questionString: _examQuestion[selectedQuestion].eQuestion.toString(),
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
                _examQuestion[selectedQuestion].options!.length, (j) {
              return InkWell(
                onTap: () {
                  if (_quizDetailsController.loadingQuestion.value) {
                    return;
                  } else if (_examQuestion[selectedQuestion].isREAttmpted ==
                      1) {
                    return;
                  } else {
                    if (isRe_attempted) {
                      giveAnswer(selectedQuestion, j);
                    }
                  }
                  //
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: _examQuestion[selectedQuestion]
                                                .isREAttmpted ==
                                            1 &&
                                        isRe_attempted
                                    ? getAttemptedColor(j, 1)
                                    : !isRe_attempted
                                        ? getNotAttemptedColor(j, 1)
                                        : greyColor,
                                offset: const Offset(0.0, 1.0), //(x,y)
                                blurRadius: 4.0,
                              ),
                            ],
                            border: Border.all(
                                color: _examQuestion[selectedQuestion]
                                                .isREAttmpted ==
                                            1 &&
                                        isRe_attempted
                                    ? getAttemptedColor(j, 0)
                                    : !isRe_attempted
                                        ? getNotAttemptedColor(j, 0)
                                        : greyColor,
                                width: 2),
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(
                            left: 10, top: 5, bottom: 5, right: 10),
                        child: Stack(
                          children: [
                            Row(
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
                                          color: greyColor,
                                          fontWeight: FontWeight.normal)),
                                ),
                                (_examQuestion[selectedQuestion]
                                            .options![j]
                                            .optionE ==
                                        null)
                                    ? const Text("")
                                    : Expanded(
                                        child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: CommonTextViewWidgetDarkMode(
                                              text: _htmlConverter
                                                  .removeAllHtmlTags(
                                                      _examQuestion[
                                                              selectedQuestion]
                                                          .options![j]
                                                          .optionE
                                                          .toString()),
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                            )),
                                      ),
                              ],
                            ),
                            _examQuestion[selectedQuestion].isREAttmpted == 1 &&
                                    isRe_attempted
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: showAttemptedIcon(j),
                                  )
                                : const SizedBox()
                          ],
                        )),
                    _examQuestion[selectedQuestion].isREAttmpted == 1 &&
                            isRe_attempted
                        ? Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: showAttemptedText(j),
                          )
                        : const SizedBox(),
                  ],
                ),
              );
            })));
  }

  Color getAttemptedColor(int j, int type) {
    var data =
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j];

    ///correct
    if (data.correct == 1 && (data.checked == 1 && data.attempted == 1)) {
      return lightGreenColor;
    }

    ///wrong
    else if (data.correct == 0 && (data.checked == 1 || data.attempted == 1)) {
      return redColor;
    }
    //default
    else if (data.correct == 0 && (data.checked == 0 || data.attempted == 0)) {
      ///border color
      if (type == 1) {
        return greyColor;
      }
      //container color
      else {
        return whiteColor;
      }
    } else if (data.correct == 1) {
      return lightGreenColor;
    }
    return greyColor;
  }

  Color getNotAttemptedColor(int j, int type) {
    var data =
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j];

    ///correct
    if (data.correct == 1 && (data.checked == 1)) {
      return lightGreenColor;
    }

    ///wrong
    else if (data.correct == 0 && data.checked == 1) {
      return redColor;
    }
    //default
    else if (data.correct == 0 && data.checked == 0) {
      ///border color
      if (type == 1) {
        return greyColor;
      }
      //container color
      else {
        return whiteColor;
      }
    } else if (data.correct == 1) {
      return lightGreenColor;
    }
    return greyColor;
  }

  Widget showAttemptedIcon(int j) {
    var data =
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j];

    ///correct
    if (data.correct == 1 && data.attempted == 1) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
      );
    }

    ///wrong
    else if (data.correct == 0 && data.checked == 1) {
      return const Icon(
        Icons.close,
        color: Colors.red,
      );
    } else if (data.correct == 0 && data.attempted == 1) {
      return const Icon(
        Icons.replay,
        color: Colors.red,
      );
    } else
      return const SizedBox();
  }

  Widget showAttemptedText(int j) {
    var data =
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j];

    ///correct
    if (data.correct == 1 && data.attempted == 1) {
      return const SizedBox();
    }

    ///wrong
    else if (data.correct == 0 && data.checked == 1) {
      return CommonTextViewWidget(
        text: "Your first attempt",
        color: Colors.red,
        fontSize: 12,
      );
    } else {
      return const SizedBox();
    }
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
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(top: 0),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 4,
                  child: (selectedQuestion <= 0)
                      ? const SizedBox()
                      : CircularRoundedButton(
                          color: colorSecondary,
                          height: 50.adaptSize,
                          text: "Previous",
                          textSize: 14,
                          press: () {
                            viewPrevQuestion();
                          })),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  height: context.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      isRe_attempted
                          ? CommonTextViewWidgetDarkMode(
                              text: "Re-Attempt",
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)
                          : const SizedBox(),
                      Transform.scale(
                        scale: 0.8,
                        child: Container(
                          margin: EdgeInsets.all(4),
                          height: 20,
                          child: Switch(
                            value: isRe_attempted,
                            onChanged: (value) {
                              if (value) {
                                isRe_attempted = true;
                              } else {
                                isRe_attempted = false;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: CircularRoundedButton(
                      textSize: 14,
                      color: greenColor,
                      height: 50.adaptSize,
                      text: selectedQuestion + 1 < _examQuestion.length
                          ? "Next"
                          : "End",
                      press: () {
                        nextAndSubmitExam(option: selectedOption.toString());
                      }))
            ],
          ),
        ));
  }
}
