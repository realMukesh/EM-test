import 'package:english_madhyam/src/screen/category/controller/libraryController.dart';
import 'package:english_madhyam/src/screen/practice/model/all_category.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/showLoadingPage.dart';
import 'package:english_madhyam/src/screen/favorite/controller/favoriteController.dart';
import 'package:english_madhyam/src/screen/savedQuestion/page/saveQuestionListPage.dart';
import 'package:english_madhyam/src/screen/practice/controller/praticeController.dart';
import 'package:english_madhyam/src/screen/practice/page/practiceExamPage.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletons/skeletons.dart';
import '../../../../routes/my_constant.dart';
import '../../../../utils/ui_helper.dart';
import '../../../widgets/customImageWidget.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../../widgets/loading.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import '../../../custom/toolbarTitle.dart';
import '../../../skeletonView/examSkeletonList.dart';
import '../../exam/controller/examListController.dart';

class PracticeListTabPage extends StatefulWidget {
  var subCategoryId = "";
  bool isSavedQuestions;
  PracticeListTabPage(
      {Key? key, required this.subCategoryId, required this.isSavedQuestions})
      : super(key: key);

  @override
  State<PracticeListTabPage> createState() => _PracticeListTabPageState();
}

class _PracticeListTabPageState extends State<PracticeListTabPage>
    with TickerProviderStateMixin {
  late TabController tabController;
  final _controller = Get.put(PraticeController(), permanent: true);

  final ExamListController _praticeExamListController =
      Get.put(ExamListController());

  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<RefreshIndicatorState> _refreshKey1 =
      GlobalKey<RefreshIndicatorState>();
  final LibraryController _favoriteController = Get.find();


  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  void loadData() async {
    _controller.getPracticeChildListData(
        subCategoryId: widget.subCategoryId ?? "",
        isRefresh: true,
        isSavedQuestions: widget.isSavedQuestions);
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const ToolbarTitle(
          title: 'Practice List',
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: GetX<PraticeController>(
          builder: (controller) {
            return Column(
              children: [
                _controller.previousExamList.isNotEmpty
                    ? buildTabWidget()
                    : const SizedBox(),
                Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        getMockTestCategories(),
                        getMockPreviousCategories()
                      ]),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildTabWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 55.adaptSize,
      child: TabBar(
        padding: const EdgeInsets.symmetric(horizontal: 6),
          unselectedLabelColor: colorGray,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: tabController,
          dividerColor: Colors.transparent,
          unselectedLabelStyle:  TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.w500),
          labelStyle:  TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.w500,
              color: Colors.white),
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: purpleColor),

          onTap: (index) {
            _controller.tabIndex(index);
            loadData();
          },
          tabs: const [Tab(text: "Mock Test",),Tab(text: "Previous Years",)]),
    );
  }

  Widget getMockTestCategories() {
    return Padding(
      padding:  EdgeInsets.only(left: 12.0, right: 12, top: 20),
      child: Stack(
        children: [
          RefreshIndicator(
              key: _refreshKey,
              onRefresh: () async {
                return Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    loadData();
                  },
                );
              },
              child: Skeleton(
                //themeMode: ThemeMode.light,
                isLoading: _controller.isFirstLoadRunning.value,
                skeleton: const ListAgendaSkeleton(),
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _controller.practiceListList.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      var praticeQuizData = _controller.practiceListList[index];
                      return buildCategoryItem(praticeQuizData, false, index);
                    }),
              )),
          _progressEmptyWidget(true, _controller.practiceListList)
        ],
      ),
    );
  }

  Widget getMockPreviousCategories() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, top: 20),
      child: Stack(
        children: [
          RefreshIndicator(
            key: _refreshKey1,
            onRefresh: () async {
              return Future.delayed(
                const Duration(seconds: 1),
                () {
                  loadData();
                },
              );
            },
            child: Skeleton(
              //themeMode: ThemeMode.light,
              isLoading: _controller.isFirstLoadRunning.value,
              skeleton: const ListAgendaSkeleton(),
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _controller.previousExamList.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    var praticeQuizData = _controller.previousExamList[index];
                    return buildCategoryItem(praticeQuizData, true, index);
                  }),
            ),
          ),
          _progressEmptyWidget(false, _controller.previousExamList)
        ],
      ),
    );
  }

  Widget buildCategoryItem(PracticeQuizData practiceQuizData, isPaid, index) {
    return InkWell(
      onTap: () async {
        if (true) {
          _praticeExamListController.getExamListByCategory(
              cat: practiceQuizData.id!.toString(),
              isRefresh: false,
              saveQuestionExamList: false);
          Get.to(
            () => PracticeExamListPage(
              title: practiceQuizData.name ?? "",
              id: practiceQuizData.id!.toString(),
              saveQuestion: false,
            ),
          );
        } else {
          _praticeExamListController.getExamListByCategory(
              cat: practiceQuizData.id!.toString(),
              isRefresh: false,
              saveQuestionExamList: true);
          Get.to(
            () => PracticeExamListPage(
              title: practiceQuizData.name ?? "",
              id: practiceQuizData.id!.toString(),
              saveQuestion: true,
            ),
          );
        }
      },
      child: Container(
        margin:  EdgeInsets.symmetric(horizontal: 0, vertical: 10.adaptSize),
        padding:  EdgeInsets.all(10.adaptSize),
        decoration: UiHelper.pdfDecoration(context,index % 6),
        child:ListTile(
          leading: CustomSqureImageWidget(
            imageUrl: practiceQuizData.image ?? MyConstant.banner_image,
            size: 70.adaptSize,
          ),
          title: CommonTextViewWidget(
            text: practiceQuizData.name ?? "",
            color: colorSecondary,fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 15,color: colorPrimary,
          ),
        ),
      )
    );
  }

  Widget _progressEmptyWidget(isMock, list) {
    return Center(
      child: _controller.isLoading.value
          ? const Loading()
          : list.isEmpty && !_controller.isFirstLoadRunning.value
              ? ShowLoadingPage(
                  refreshIndicatorKey: isMock ? _refreshKey : _refreshKey1)
              : const SizedBox(),
    );
  }
}
