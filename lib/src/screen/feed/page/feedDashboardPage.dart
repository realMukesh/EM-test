import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/src/screen/feed/controller/feed_controller.dart';
import 'package:english_madhyam/src/screen/feed/page/phraseDayPage.dart';
import 'package:english_madhyam/src/screen/feed/page/wordDayPage.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../custom/toolbarTitle.dart';
import '../../../widgets/common_textview_widget.dart';

class FeedDashboard extends StatefulWidget {
  FeedDashboard({Key? key}) : super(key: key);

  @override
  _FeedDashboardState createState() => _FeedDashboardState();
}

class _FeedDashboardState extends State<FeedDashboard>
    with TickerProviderStateMixin {
  late TabController tabController;

  final FeedController _feedController =
      Get.put<FeedController>(FeedController());
  DateTime? dateTime;
  String formattedDate = "";
  String chooseDate = "";

  List<String> color = [
    "#EDF6FF",
    "#FFDDDD",
    "#F6F4FF",
    "#EBFFE5",
  ];

  @override
  void initState() {
    super.initState();

    /// initially send current date in payload
    String currentDate = dateFormatter(DateTime.now());
    // WidgetsBinding.instance!.addPostFrameCallback((_) {});
    _feedController.feedApiFetch(
        type: "word", date: currentDate, currentPage: 1);
    tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (!tabController.indexIsChanging) {
          _feedController.pageCounter.value = 1;
          currentDate = dateFormatter(DateTime.now());
          if (tabController.index == 0) {
            _feedController.feedApiFetch(
                type: "word", date: currentDate, currentPage: 1);
          } else if (tabController.index == 1) {
            _feedController.feedApiFetch(
                type: "phrase", date: currentDate, currentPage: 1);
          }
        }
      });
  }

  String dateFormatter(DateTime date) {
    chooseDate = " ${date.year}-${date.month}-${date.day}";
    return chooseDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: const ToolbarTitle(
            title: 'Daily Learnings',
          ),
          actions: [
            InkWell(
              onTap: () async {
                DateTime? newDateTime = await showRoundedDatePicker(
                  height: MediaQuery.of(context).size.height * 0.3,
                  styleDatePicker: MaterialRoundedDatePickerStyle(
                    backgroundHeader: themeYellowColor,
                  ),
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022, 4, 9),
                  lastDate: DateTime.now().add(
                    const Duration(seconds: 10),
                  ),
                  theme: ThemeData(primarySwatch: Colors.pink),
                );

                if (newDateTime != null) {
                  setState(() {
                    dateTime = newDateTime;
                    dateFormatter(newDateTime);

                    if (tabController.index == 0) {
                      _feedController.wordOfDayList.clear();
                      _feedController.pageCounter.value = 1;
                      _feedController.feedApiFetch(
                          type: "word", date: chooseDate, currentPage: 1);
                    } else {
                      _feedController.phraseList.clear();
                      _feedController.pageCounter.value = 1;
                      _feedController.feedApiFetch(
                          type: "phrase", date: chooseDate, currentPage: 1);
                    }
                  });
                }
              },
              child: Padding(
                padding: EdgeInsets.all(8.0.adaptSize),
                child: SvgPicture.asset(
                  "assets/icon/calendar.svg",
                  color: purpleColor,height: 30.adaptSize,
                ),
              ),
            )
          ]),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildTabWidget(),
            ),
            Expanded(
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    WordDayPage(
                      paginationCallback: (page) {
                        _feedController.pageCounter.value = page;
                        _feedController.feedApiFetch(
                            type: "word",
                            date: chooseDate,
                            currentPage: _feedController.pageCounter.value);
                      },
                      controller: _feedController,
                    ),
                    PhraseDayPge(
                      controller: _feedController,
                      paginationCallback: (page) {
                        _feedController.pageCounter.value = page;
                        _feedController.feedApiFetch(
                            type: "phrase",
                            date: chooseDate,
                            currentPage: _feedController.pageCounter.value);
                      },
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabWidget() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 6.adaptSize),
      child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: tabController,
          unselectedLabelStyle: TextStyle(
              fontSize: 18.fSize, fontWeight: FontWeight.w500),
          labelStyle:  TextStyle(
              fontSize: 18.fSize, fontWeight: FontWeight.w500, color: Colors.white),
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: purpleColor),
          tabs: const [
            Tab(
              text: "Word",
            ),
            Tab(
              text: "Phrase",
            ),
          ]),
    );
  }
}
