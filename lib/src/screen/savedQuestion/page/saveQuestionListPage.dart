import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/savedQuestion/controller/questionController.dart';
import 'package:english_madhyam/src/screen/savedQuestion/controller/questionDetailController.dart';
import 'package:english_madhyam/src/screen/savedQuestion/page/saveQuestionDetailPage.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/question_widget.dart';
import '../../pages/page/converter.dart';
import '../model/question_category_model.dart';
import '../model/save_question_model.dart';

class SaveQuestionList extends GetView<QuestionController> {
  static const routeName = "/SaveQuestionList";
  SaveQuestionList({
    Key? key,
  }) : super(key: key);

  @override
  QuestionController controller = Get.put(QuestionController());

  var questionDetailsController = Get.put(QuestionDetailController());

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final HtmlConverter _htmlConverter = HtmlConverter();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ToolbarTitle(title: "My Questions"),
        actions: [
          popupMenuButton(context),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetX<QuestionController>(builder: (controller) {
          return Stack(
            children: [
              listBodyWidget(),
              controller.loading.value ? const Loading() : const SizedBox(),
              !controller.loading.value && controller.saveQuestionList.isEmpty
                  ? const Center(
                      child: Text("No Data Found"),
                    )
                  : const SizedBox()
            ],
          );
        }),
      ),
    );
  }

  popupMenuButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: PopupMenuButton<SqCategories>(
        offset: const Offset(0, 50), // Adjust the Y-axis (50px downwards)
        icon: Container(
            margin: const EdgeInsets.all(12),
            child: const Icon(Icons.filter_list_alt, color: Colors.black)),
        onSelected: (SqCategories item) {
          controller.applyFilterToItem(item.id);
        },
        itemBuilder: (BuildContext context) {
          return controller.filterItemAllList.map((SqCategories item) {
            return PopupMenuItem<SqCategories>(
              value: item,
              child: Text(item.name ?? ""),
            );
          }).toList();
        },
      ),
    );
  }

  Widget listBodyWidget() {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.saveQuestionList.length,
          itemBuilder: (context, index) {
            QuestionData questionData = controller.saveQuestionList[index];
            return Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 1), blurRadius: 3)
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              margin:
                  const EdgeInsets.only(left: 10, right: 0, bottom: 5, top: 10),
              child: Column(
                children: [
                  QuestionWidget(questionString: questionData?.eQuestion ?? ""),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          color: colorPrimary,
                          width: context.width,
                          child: TextButton(
                              onPressed: () async {
                                questionDetailsController.getQuestionDetails(
                                    catId: questionData?.sqCatId ?? "",
                                    questionId: questionData?.questionId ?? "");
                                questionDetailsController.examDetails.clear();
                                Get.to(SavedQuestionDetailPage());
                              },
                              child: CommonTextViewWidgetDarkMode(
                                text: "View Details",
                                color: white,
                              )),
                        )),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: Container(
                          color: Colors.red,
                          width: context.width,
                          child: TextButton(
                              onPressed: () async {
                                Map requestBody = {
                                  "question_id": questionData?.questionId ?? "",
                                  "sq_category_id":
                                      questionData?.sqCatId ?? ""
                                };
                                await controller.removeQuestion(
                                    context: context,
                                    jsonBody: requestBody,
                                    index: index);
                              },
                              child: CommonTextViewWidgetDarkMode(
                                text: "Remove",
                                color: white,
                              )),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    //favoriteController.getSaveQuestionList(categoryId);
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
