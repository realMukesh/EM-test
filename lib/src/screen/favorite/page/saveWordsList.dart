import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/screen/favorite/controller/favoriteController.dart';
import 'package:english_madhyam/src/screen/favorite/model/wardDataModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../custom/toolbarTitle.dart';
import '../../pages/page/converter.dart';
import '../../../widgets/common_textview_widget.dart';

class SaveWordList extends GetView<FavoriteController> {
  static const name = "SaveWordList";
  SaveWordList({Key? key}) : super(key: key);

  final favoriteController = Get.put(FavoriteController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final HtmlConverter _htmlConverter = HtmlConverter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ToolbarTitle(title: "My Words"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetX<FavoriteController>(builder: (controller) {
          return Stack(
            children: [
              listBodyWidget(
                  saveWordsList: controller.saveWordsList.reversed.toList()),
              controller.loading.value ? const Loading() : const SizedBox(),
              !controller.loading.value && controller.saveWordsList.isEmpty
                  ? Center(
                      child: CommonTextViewWidget(text: "No Data Found"),
                    )
                  : const SizedBox(),
            ],
          );
        }),
      ),
    );
  }

  Widget listBodyWidget({required List<dynamic> saveWordsList}) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: saveWordsList.length,
          reverse: false,
          itemBuilder: (context, index) {
            WordData wordData = saveWordsList[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
              decoration: BoxDecoration(
                  color: AdaptiveTheme.of(context).mode.isDark
                      ? Colors.transparent
                      : colorLightGray,
                  border: Border.all(
                      color: AdaptiveTheme.of(context).mode.isDark
                          ? Colors.transparent
                          : indicatorColor,
                      width: 0.7),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: CommonTextViewWidget(
                        text: "${wordData.word ?? ""} :",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorSecondary),
                    subtitle: CommonTextViewWidget(
                      text: _htmlConverter.parseHtmlString(
                          wordData.meaning.toString().replaceAll("-", "")),
                    ),
                    trailing: GestureDetector(
                      onTap: () async {
                        await controller.removeWordsFromList(
                            context: context,
                            wordId: wordData.vocabId.toString() ?? "");
                        // saveWordsList.removeAt(index);
                        controller.update();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.bookmark,
                          color: colorPrimary,
                        ),
                      ),
                    ),
                  )),
            );
          }),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    favoriteController.getSaveWordsList();

    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
