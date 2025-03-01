import 'package:english_madhyam/src/screen/exam/controller/result_exam_controller.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/utils/progress_bar_report/progress_bar.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import '../../../custom/rounded_button.dart';
import '../model/graph_data_model.dart';

class PerformanceReportPage extends StatefulWidget {
  static const routeName = "/PerformanceReportPage";
  const PerformanceReportPage({
    Key? key,
  }) : super(key: key);

  @override
  _PerformanceReportPageState createState() => _PerformanceReportPageState();
}

class _PerformanceReportPageState extends State<PerformanceReportPage> {
  final ExamResultController controller = Get.put(ExamResultController());
  GraphData? data = GraphData();
  var attempted;

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
            title: "Overall Performance Summary",
          ),
        ),
        body: GetX<ExamResultController>(
          builder: (controller) {
            if (controller.graphData.value.time != null) {
              data = controller.graphData.value;
              attempted = double.parse(data?.correctQuestion.toString() ?? "") +
                  double.parse(data?.incorrectQuestion.toString() ?? "");
            }
            return Stack(
              children: [
                Skeleton(
                  isLoading: controller.loading.value,
                  skeleton: loadGraphData(),
                  child: loadGraphData(),
                ),
                controller.loading.value ? const Loading() : SizedBox()
              ],
            );
          },
        ));
  }

  loadGraphData() {
    int incorrectQuestion = controller.graphData.value?.incorrectQuestion ?? 0;
    int correctQuestion = controller.graphData.value?.correctQuestion ?? 0;
    int totalQuestion = controller.graphData.value?.totalQuestion ?? 0;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.32,
            child: loadParentWidget(),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularPercentIndicator(
                      radius: 50.0,
                      lineWidth: 10.0,
                      animation: true,
                      backgroundColor: lightGreyColor,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: pinkColor,
                      percent: controller.percentage.value / 100,
                    ),
                    CommonTextViewWidget(
                      text: "Total Question Attempted:",
                      fontSize: 18,
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                CommonTextViewWidget(
                  text: "QUESTION  DISTRIBUTION",
                  fontSize: 18,
                  color: colorSecondary,
                  fontWeight: FontWeight.w600,
                ),
                progressWidget(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          CommonTextViewWidget(
                              text: correctQuestion.toString(),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: lightGreenColor),
                          CommonTextViewWidget(
                            text: "Correct",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: lightGreenColor,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CommonTextViewWidget(
                            text: incorrectQuestion.toString(),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: pinkColor,
                          ),
                          CommonTextViewWidget(
                              text: "Incorrect",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: pinkColor),
                        ],
                      ),
                      Column(
                        children: [
                          CommonTextViewWidget(
                              text: (controller.graphData.value.skipQuestion)
                                  .toString(),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: greyColor),
                          CommonTextViewWidget(
                              text: "Unanswered",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: greyColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: CircularRoundedButton(
                      text: "View Solution",
                      textSize: 14,
                      press: () {
                        controller.openExamPag();
                      }),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 1,
                  child: CircularRoundedButton(
                      textSize: 14,
                      text: "View Leaderboard",
                      press: () {
                        controller.openLeaderboard();
                      }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  loadParentWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [Expanded(child: loadHeaderPart())],
    );
  }

  Widget progressWidget() {
    int incorrectQuestion = controller.graphData.value?.incorrectQuestion ?? 0;

    int correctQuestion = controller.graphData.value?.correctQuestion ?? 0;

    int totalQuestion = controller.graphData.value?.totalQuestion ?? 0;

    double redSize =
        double.parse((incorrectQuestion / totalQuestion).toString());
    double greenSize =
        double.parse((correctQuestion / totalQuestion).toString());

    if (redSize.isInfinite || redSize.isFinite || redSize.isNaN) {
      redSize = 0.0;
    }
    if (greenSize.isInfinite || greenSize.isFinite || greenSize.isNaN) {
      greenSize = 0.0;
    }
    return ProgressBar(
        redSize: redSize == "NaN" ? 0.0 : 00,
        greenSize: greenSize == "NaN" ? 0.0 : 00);
  }

  loadHeaderPart() {
    var incorrectQuestion = data?.incorrectQuestion ?? 0;
    var correctQuestion = data?.correctQuestion ?? 0;
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorLightGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              buildChildMenuBody(
                "Rank",
                "${data?.rank ?? 0}/${data?.totalStudents ?? 0}",
                "assets/img/rank.png",
              ),
              buildChildMenuBody(
                "Score",
                "${data?.marks}/${data?.totalMarks}",
                "assets/img/trophy.png",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildChildMenuBody(
                "Accuracy",
                getAccuracy((correctQuestion + incorrectQuestion),
                    correctQuestion ?? 0),
                "assets/img/iaccuracy.png",
              ),
              buildChildMenuBody(
                "Percentile",
                calculatePercentile(
                    data?.rank ?? 0, data?.totalStudents ?? 100),
                "assets/img/ratio.png",
              ),
            ],
          ),
          buildChildMenuBody(
              "Attempted",
              "${attempted ?? 0.toInt()}/${data?.totalQuestion}",
              "assets/img/attempt.png"),
        ],
      ),
    );
  }

  buildChildMenuBody(
    title,
    subTitle,
    String score,
  ) {
    return Expanded(
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Image.asset(
          score,
          height: 30.adaptSize,
        ),
        title: CommonTextViewWidgetDarkMode(
          text: title,
          align: TextAlign.start,
          fontSize: 18,
          color: colorPrimary,
          fontWeight: FontWeight.w500,
        ),
        subtitle: CommonTextViewWidgetDarkMode(
          text: subTitle,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: colorSecondary,
        ),
      ),
    );
  }

  String getAccuracy(int totalQuestion, int correctQuestion) {
    var accuracy =
        double.parse(((correctQuestion / totalQuestion) * 100).toString());
    return accuracy.toStringAsFixed(2);
  }

  String calculatePercentile(int rank, int totalItems) {
    if (rank <= 0 || rank > totalItems || totalItems <= 0) {
      //throw ArgumentError("Invalid rank or totalItems");
      return "0 %";
    }
    double percentile = (totalItems - rank) / totalItems * 100.0;
    return "${percentile.toStringAsFixed(2)} %";
  }
}
