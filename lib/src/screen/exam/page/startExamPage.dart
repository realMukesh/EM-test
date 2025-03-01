import 'package:english_madhyam/src/screen/exam/model/exam_detail_model.dart';
import 'package:english_madhyam/src/screen/savedQuestion/model/SaveQuestionExamListModel.dart';
import 'package:english_madhyam/src/widgets/button/custom_icon_button.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/exam/controller/examDetailController.dart';
import 'package:english_madhyam/src/screen/bottom_nav/dashboard_page.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/editorials_page.dart';
import 'package:english_madhyam/src/screen/favorite/controller/favoriteController.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/src/widgets/question_widget.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../custom/rounded_button.dart';
import '../../../widgets/custom_dialog_widget.dart';
import '../../../widgets/rounded_button.dart';
import '../../pages/page/converter.dart';
import '../../profile/controller/profile_controllers.dart';
import '../../savedQuestion/controller/questionController.dart';
import '../../savedQuestion/model/question_category_model.dart';
import '../../savedQuestion/model/save_question_model.dart';

const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

class StartExamPage extends StatefulWidget {
  final ExamDetailsModel examDetails;
  final String title;
  final bool reviewExam;
  final int type;

  const StartExamPage(
      {Key? key,
      required this.title,
      required this.type,
      required this.examDetails,
      required this.reviewExam})
      : super(key: key);

  @override
  _StartExamPageState createState() => _StartExamPageState();
}

class _StartExamPageState extends State<StartExamPage> {
  TextEditingController reportQuestionController = TextEditingController();
  final ExamDetailController _examDetailController = Get.find();
  final HtmlConverter _htmlConverter = HtmlConverter();
  final QuestionController _favoriteController = Get.put(QuestionController());
  final ProfileControllers _profileControllers = Get.find();
  List<String> reportIssues = [
    "Wrong Question",
    "Wrong Answer",
    "Formatting Issue",
    "No Solution",
    "Wrong Translation",
    "Copyright issue",
    "Other"
  ];
  late Timer _timer;
  bool valueUpdated = false;

  late List<ExamQuestion> _examQuestion;

  int selectedQuestion = 0;
  int selectedOption = 0;
  int selectedOptionIndex = 0;
  int _remainingTime = 0;

  @override
  void initState() {
    _examQuestion = widget.examDetails.content!.examQuestion ?? [];
    if (widget.reviewExam == false) {
      if (widget.examDetails.content!.timeLeft == "") {
        _remainingTime = int.parse(widget.examDetails.content!.duration!) * 60;
      } else {
        _remainingTime =
            int.parse(widget.examDetails.content!.timeLeft!.toString());
      }
      _startTimer();
    }
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        title: const ToolbarTitle(
          title: 'Play Exam',
        ),
      ),
      body: WillPopScope(
        onWillPop: exitDialog,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(15.adaptSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  indicateMarks(),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          headerTimerWidget(),
                          questionWidget(),
                          optionsWidget(),
                          const SizedBox(
                            height: 12,
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
            Obx(() => _examDetailController.loadingQuestion.value ||
                    _examDetailController.loading.value ||
                    _examDetailController.loading.value
                ? const Loading()
                : const SizedBox())
          ],
        ),
      ),
      endDrawer: endDrawerWidget(),
    );
  }

  Widget saveRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          reportQuestion(),
        ],
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

// Checked set colors for question position
  Color getGoToColor(int questionIndex) {
    var questionList = widget.examDetails.content?.examQuestion ?? [];
    if (questionList.isEmpty) return greyColor; // Fallback for empty list

    final question = questionList[questionIndex];

    if (!widget.reviewExam) {
      // Color for marked questions
      if (question.isBookmark == 1) return purpleColor;

      // Color for attempted questions
      if (question.ansType == 1 || question.isAttempt == 1) {
        return lightGreenColor;
      }

      // Default color for unanswered questions
      return hintColor;
    }

    if (widget.reviewExam) {
      if (question.isAttempt == 1) {
        for (var option in question.options ?? []) {
          if (option.checked == 1 && option.correct == 1)
            return lightGreenColor;
          if (option.checked == 1 && option.correct != 1) return redColor;
        }
      }
    }

    // Default color for unanswered questions
    return hintColor;
  }

  // Initialize question index in a variable and navigate to a specific question
  void goToQuestion(int index) {
    if (index >= 0 && index < _examQuestion.length) {
      setState(() {
        selectedQuestion = index;
      });
    } else {
      Fluttertoast.showToast(msg: "Question not found");
      cancel();
    }
  }

// Give an answer to a specific question
  Future<void> giveAnswer(int questionIndex, int optionIndex) async {
    if (questionIndex < 0 || questionIndex >= _examQuestion.length) {
      Fluttertoast.showToast(msg: "Invalid question index");
      cancel();
      return;
    }

    final question = _examQuestion[questionIndex];
    final options = question.options;

    if (options == null || optionIndex < 0 || optionIndex >= options.length) {
      Fluttertoast.showToast(msg: "Option does not exist");
      cancel();
      return;
    }

    // Reset checked state for all options
    for (var option in options) {
      option.checked = 0;
    }

    // Set the selected option
    options[optionIndex].checked = 1;

    setState(() {
      selectedOption = options[optionIndex].id!;
      question.isSelect = selectedOption;
      selectedOptionIndex = optionIndex;
      question.isAttempt = 1;
      question.ansType = 1;

      print("Selected option ID: ${options[optionIndex].id}");
    });
  }

// Calculate the total number of questions based on a specific condition
  int _getQuestionCount(bool Function(dynamic examQuestion) condition) {
    return widget.examDetails.content?.examQuestion
            ?.where((examQuestion) => condition(examQuestion))
            .length ??
        0;
  }

// Total Answered Number
  int _getAnsweredNumber() {
    return _getQuestionCount((examQuestion) => examQuestion.isAttempt == 1);
  }

// Total Review Question
  int _getReviewNumber() {
    return _getQuestionCount((examQuestion) => examQuestion.isBookmark == 1);
  }

// Total Not Answered Question
  int _getNotAnsweredNumber() {
    return _getQuestionCount((examQuestion) => examQuestion.isAttempt != 1);
  }

// View Next Question
  Future<void> viewNextQuestion({required String option}) async {
    if (!widget.reviewExam) {
      // Exam Started
      if (selectedQuestion + 1 < _examQuestion.length) {
        if (selectedOption != 0) {
          if (_examQuestion[selectedQuestion]
                  .options![selectedOptionIndex]
                  .id ==
              int.parse(option)) {
            _incrementQuestion();
          } else {
            _showSnackBar("Option not found");
          }
        } else {
          _incrementQuestion();
        }
      } else {
        _openSubmitDialog(eventType: "Submit");
        _resetSelection();
      }
    } else {
      // Exam Reviewing
      if (selectedQuestion + 1 < _examQuestion.length) {
        _incrementQuestion();
      } else {
        Fluttertoast.showToast(msg: "No next question found");
        cancel();
      }
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

// Remove Answer
  Future<void> removeAnswer(int index) async {
    if (_isValidQuestionIndex(index)) {
      for (var option in _examQuestion[index].options!) {
        option.checked = 0;
      }
      setState(() {
        _examQuestion[index]
          ..isAttempt = 0
          ..ansType = 0
          ..isSelect = null;
        _resetSelection();
      });
    } else {
      _showError("Question not found");
    }
  }
// Exit Dialog

  Future<bool> exitDialog() async {
    dynamic result = false;
    result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          logo: "assets/img/cancel_img.png",
          title: "Do you really want to exit?",
          description: _examDetailController.pauseMessage.value == "resume"
              ? "By confirming, you are submitting your exam."
              : "Are you sure?",
          buttonAction: "Confirm",
          buttonCancel: "Cancel",
          onCancelTap: () {},
          onActionTap: () async {
            Navigator.pop(Get.context!, true);
          },
        );
      },
    );
    return result ?? false;
  }

// Start Timer
  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingTime <= 0) {
          timer.cancel();
          _submitExam();
        } else {
          setState(() {
            _remainingTime--;
          });
        }
      },
    );
  }

// Pause Timer
  void pauseTimer() {
    if (_timer != null) {
      setState(() {
        if (_timer!.isActive) {
          _timer!.cancel();
        } else {
          _startTimer();
        }
      });
    }
  }

// Utility Methods
  void _incrementQuestion() {
    setState(() {
      selectedQuestion++;
      _resetSelection();
    });
  }

  void _decrementQuestion() {
    setState(() {
      selectedQuestion--;
      _resetSelection();
    });
  }

  void _resetSelection() {
    selectedOption = 0;
    selectedOptionIndex = 0;
  }

  bool _isValidQuestionIndex(int index) {
    return index >= 0 && index < _examQuestion.length;
  }

  void _showError(String message) {
    Fluttertoast.showToast(msg: message);
    cancel();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _submitExam() {
    _examDetailController.submitControl(
      id: widget.examDetails.content!.id.toString(),
      title: widget.title,
      catId: widget.examDetails.content!.categoryId.toString(),
      examList: widget.examDetails.content!.examQuestion ?? [],
      route: widget.type,
      time: _remainingTime.toString(),
    );
  }

//submit dailog
  _openSubmitDialog({required String eventType}) async {
    // Validation logic for unanswered or incorrectly answered questions
    for (int i = 0; i < widget.examDetails.content!.examQuestion!.length; i++) {
      var element = widget.examDetails.content!.examQuestion![i];
      List<int> availableOptions = [];
      element.options?.forEach((options) {
        availableOptions.add(options.id ?? 0);
      });

      if (element.isAttempt == 1 &&
          !availableOptions.contains(element.isSelect)) {
        Fluttertoast.showToast(
            msg:
                "Please select your answer for question number ${i + 1} again.");
        selectedQuestion = i;
        goToQuestion(i);
        removeAnswer(selectedQuestion);
        return;
      }
    }

    var response = await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: _buildDialogTitle(),
        content: _buildDialogContent(eventType),
      ),
      barrierDismissible: false,
    );

    if (response != null) Navigator.pop(context);
  }

// Build title section of the dialog
  Widget _buildDialogTitle() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            CommonTextViewWidget(
              text: "Time Remaining",
              align: TextAlign.center,
              color: purpleColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            CommonTextViewWidget(
              text: _printDuration(Duration(seconds: _remainingTime)),
              color: purpleColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }

// Build content section of the dialog
  Widget _buildDialogContent(String type) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow("Answered", _getAnsweredNumber().toString(), greenColor),
          _buildRow(
              "Not Answered", _getNotAnsweredNumber().toString(), redColor),
          _buildRow("Marked For Review", _getReviewNumber().toString(),
              Colors.orange),
          const SizedBox(height: 10),
          _buildActionButton(type),
        ],
      ),
    );
  }

// Build row for displaying question status
  Widget _buildRow(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CommonTextViewWidget(
              text: label,
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w500),
          CommonTextViewWidget(
              text: value,
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ],
      ),
    );
  }

// Build action button based on the 'type' (Pause/Submit)
  Widget _buildActionButton(String type) {
    return type == "Pause"
        ? InkWell(
            onTap: () async {
              pauseTimer();
              var result = await _examDetailController.pauseExam(
                id: widget.examDetails.content?.id.toString() ?? "",
                left: _remainingTime,
              );
              Future.delayed(const Duration(seconds: 0), () {
                Navigator.pop(context, result);
              });
            },
            child: _buildButton("Pause", _examDetailController.loading.value),
          )
        : InkWell(
            onTap: () async {
              Navigator.pop(context);
              _timer?.cancel();
              _examDetailController.submitControl(
                id: widget.examDetails.content!.id.toString(),
                title: widget.title,
                catId: widget.examDetails.content!.categoryId.toString(),
                examList: widget.examDetails.content!.examQuestion ?? [],
                route: widget.type,
                time: _remainingTime.toString(),
              );
            },
            child: _buildButton("SUBMIT", _examDetailController.loading.value),
          );
  }

// Build button with loading animation and text
  Widget _buildButton(String text, bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: purpleColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: isLoading
          ? Center(
              child: Lottie.asset(
                "assets/animations/loader.json",
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            )
          : CommonTextViewWidgetDarkMode(
              text: text,
              fontWeight: FontWeight.normal,
              fontSize: 16,
              color: white,
            ),
    );
  }

  endDrawerWidget() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: context.width * .70,
          decoration: const BoxDecoration(color: white),
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 12,
              ),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    labelCreate(Colors.grey, "Not Answered"),
                    const SizedBox(
                      width: 12,
                    ),
                    labelCreate(Colors.green, "Answered"),
                  ],
                ),
              ),
              const Divider(),
              Expanded(child: questionIndexWidget()),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: CircularRoundedButton(
                            text: "Submit Exam",
                            textSize: 16,
                            height: 55,
                            press: () {
                              _openSubmitDialog(eventType: "Submit");
                            }),
                      )
                    ],
                  ),
                ),
              ),
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
                padding: const EdgeInsets.only(top: 30, right: 20),
                child: SvgPicture.asset("assets/icon/close_icon.svg",
                    height: 40.adaptSize)),
          ),
        ),
      ],
    );
  }

  Widget labelCreate(MaterialColor materialColor, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        CommonTextViewWidgetDarkMode(
          text: title,
          fontSize: 14,
        )
      ],
    );
  }

  Widget indicateMarks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CommonTextViewWidget(
              text: "Que No.${selectedQuestion + 1}",
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(
              width: 12,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonTextViewWidget(
                  text: "Marks:",
                  fontWeight: FontWeight.normal,
                ),
                const SizedBox(
                  width: 6,
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CommonTextViewWidgetDarkMode(
                      color: white,
                      fontWeight: FontWeight.normal,
                      text:
                          "+ ${widget.examDetails.content?.mark.toString() ?? ""}"),
                ),
                const SizedBox(
                  width: 6,
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CommonTextViewWidgetDarkMode(
                      color: white,
                      fontWeight: FontWeight.normal,
                      text:
                          "- ${widget.examDetails.content?.negativeMark.toString() ?? ""}"),
                )
              ],
            ),
          ],
        ),
        CustomIconButton(
          width: 150.adaptSize,
          height: 30,
          onTap: () {
            if (_examQuestion[selectedQuestion].isBookmark == 0) {
              askQuestionDialog(context, selectedQuestion, true);
            } else {
              askQuestionDialog(context, selectedQuestion, false);
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
      ],
    );
  }

  String? dropdownValue;

  Widget reportQuestion() {
    return Container(
      height: 30,
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
              child: CommonTextViewWidgetDarkMode(text: value),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
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
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                      ))
                ],
              ),
              TextFormField(
                controller: reportQuestionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      "Please Tell us more about the issue (at least 7-8 words) for the quick resolutions",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Divider(
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
                      if (reportQuestionController.text.isNotEmpty) {
                        var requestBody = {
                          "exam_id": widget.examDetails.content!.id.toString(),
                          "report_type": dropdownValue.toString(),
                          "message": reportQuestionController.text,
                          "q_id": widget.examDetails.content!
                              .examQuestion![selectedQuestion].id
                              .toString()
                        };
                        _examDetailController.reportQuiz(requestBody);
                        Navigator.of(context).pop();
                      } else {
                        UiHelper.showFailureMsg(context, "Issue Required.");
                      }
                    },
                    child: CommonTextViewWidgetDarkMode(
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

  Widget headerTimerWidget() {
    return Row(
      children: [
        InkWell(
            onTap: () {
              _openSubmitDialog(eventType: "Pause");
            },
            child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Obx(() {
                  return Icon(
                    // Icons.play_arrow_rounded,
                    _examDetailController.pauseMessage.value == "resume" ||
                            _examDetailController.pauseMessage.value == ""
                        ? Icons.pause_circle_outline_outlined
                        : Icons.play_arrow_rounded,
                    color: Colors.indigo,
                    size: 30,
                  );
                }))),
        CommonTextViewWidget(
          text: "Time Left : ",
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        CommonTextViewWidget(
          text: _printDuration(Duration(seconds: _remainingTime)),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
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
        var data = widget.examDetails.content!.examQuestion?[i];
        return InkWell(
          onTap: () {
            goToQuestion(i);
            Get.back();
          },
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: getGoToColor(i),
                border: Border.all(
                    color: i != selectedQuestion ? Colors.transparent : green,
                    width: 3),
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
        ) /*Container(
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
        )*/
            ;
      },
    );
  }

  //check by mukesh
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
                  if (widget.reviewExam == false) {
                    if (_examDetailController.loadingQuestion.value) {
                      return;
                    }
                    giveAnswer(selectedQuestion, j);
                  } else {
                    return;
                  }
                },
                child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            /// check wheter selected option is selected or not
                            color: (_examQuestion[selectedQuestion]
                                        .options![j]
                                        .id ==
                                    _examQuestion[selectedQuestion].isSelect)
                                ? greenColor
                                : Colors.grey,
                            offset: const Offset(0.0, 1.0), //(x,y)
                            blurRadius: 4.0,
                          ),
                        ],
                        border: Border.all(
                            color: (_examQuestion[selectedQuestion]
                                        .options![j]
                                        .id ==
                                    _examQuestion[selectedQuestion].isSelect)
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
                        (_examQuestion[selectedQuestion].options![j].optionE ==
                                null)
                            ? const Text("")
                            : Expanded(
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: CommonTextViewWidgetDarkMode(
                                      text: _htmlConverter.removeAllHtmlTags(
                                          _examQuestion[selectedQuestion]
                                              .options![j]
                                              .optionE
                                              .toString()),
                                      fontSize: 16,
                                      color: colorSecondary,
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                      ],
                    )),
              );
            })));
  }

  Color getGoToOptionColor(int j, int Type) {
    ///correct
    if (widget.examDetails.content!.examQuestion![selectedQuestion].options![j]
                .correct ==
            1 &&
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j]
                .checked ==
            1) {
      return lightGreenColor;
    }

    ///wrong
    else if (widget.examDetails.content!.examQuestion![selectedQuestion]
                .options![j].correct ==
            0 &&
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j]
                .checked ==
            1) {
      return redColor;
    }

    ///default
    else if (widget.examDetails.content!.examQuestion![selectedQuestion]
                .options![j].correct ==
            0 &&
        widget.examDetails.content!.examQuestion![selectedQuestion].options![j]
                .checked ==
            0) {
      ///border color
      if (Type == 1) {
        return greyColor;
      }
      //container color
      else {
        return whiteColor;
      }
    } else if (widget.examDetails.content!.examQuestion![selectedQuestion]
            .options![j].correct ==
        1) {
      return lightGreenColor;
    }
    return Colors.transparent;
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
              widget.reviewExam == false
                  ? Expanded(
                      flex: 3,
                      child: CircularRoundedButton(
                          color: redColor,
                          height: 50.adaptSize,
                          text: "Clear",
                          textSize: 14,
                          press: () {
                            removeAnswer(selectedQuestion);
                          }))
                  : const SizedBox(),
              const SizedBox(
                width: 10,
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
                              text: widget.reviewExam == false
                                  ? selectedQuestion + 1 < _examQuestion.length
                                      ? "Save & Next"
                                      : "Submit Exam"
                                  : selectedQuestion + 1 < _examQuestion.length
                                      ? "Next"
                                      : "End",
                              press: () {
                                viewNextQuestion(
                                    option: selectedOption.toString());
                              }))))
            ],
          ),
        ));
  }

  backToQuiz() {
    if (widget.type == 2) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => DashboardPage()),
          (route) => false);
    }
    // if its came from daily Quiz Category
    else if (widget.type == 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => DashboardPage(
                    index: 2,
                  )),
          (route) => false);

      // Navigator.of(context).pop();
    }
    //from editorials
    else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => EditorialsPage()),
          (route) => false);
    }
  }

  ///
  askQuestionDialog(BuildContext context, int index, bool isBookmark) {
    if (isBookmark) {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled:
            true, // Allows bottom sheet to adjust when keyboard opens
        builder: (BuildContext context) {
          return Container(
            padding:
                const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 8),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              border: Border.all(color: indicatorColor, width: 1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context)
                          .viewInsets
                          .bottom, // Adjusts padding when keyboard opens
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextViewWidgetDarkMode(
                              text: "Choose Category",
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: colorSecondary,
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        GetX<QuestionController>(
                          builder: (controller) {
                            return ListView.builder(
                              itemCount:
                                  _favoriteController.filterItemList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                SqCategories data =
                                    _favoriteController.filterItemList[index];
                                return GestureDetector(
                                  onTap: () {
                                    _favoriteController.selectedIndex(data.id);
                                    _favoriteController.selectedIndex.refresh();
                                    _favoriteController.filterItemList
                                        .refresh();
                                  },
                                  child: ListTile(
                                    title: CommonTextViewWidgetDarkMode(
                                      text: data.name ?? "",
                                      fontSize: 14,
                                    ),
                                    trailing: Icon(_favoriteController
                                                .selectedIndex.value ==
                                            data.id
                                        ? Icons.radio_button_on
                                        : Icons.radio_button_off),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const Divider(color: grayColorLight),
                        const SizedBox(height: 12),
                        const SizedBox(height: 12),
                        RoundedButton(
                            text: "Save Question",
                            press: () {
                              bookmarkAction(index, isBookmark);
                              Get.back();
                            }),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      bookmarkAction(index, isBookmark);
    }
  }


  // Mark for Review
  Future<void> bookmarkAction(int index, bool isBookmark) async {
    if (_isValidQuestionIndex(index)) {
      Map requestBody = {
        "question_id": _examQuestion[selectedQuestion].id.toString(),
        "sq_category_id": isBookmark
            ? _favoriteController.selectedIndex.value
            : _examQuestion[index].bookmarkCateId
      };
      await _favoriteController.bookmarkQuestion(
          context: context, jsonBody: requestBody, isBookmark: isBookmark);
      setState(() {
        _examQuestion[index].isBookmark = isBookmark ? 1 : 0;
        _examQuestion[index].bookmarkCateId =
            _favoriteController.selectedIndex.value;
      });
    } else {
      _showError("Question not found");
    }
  }
}
