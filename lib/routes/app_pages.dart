import 'package:english_madhyam/src/screen/leader_Board/page/leader_board.dart';
import 'package:english_madhyam/src/screen/practice/widget/performance_report.dart';
import 'package:get/get.dart';
import '../src/screen/Notification_screen/page/Notifications.dart';
import '../src/screen/login/page/login_page.dart';
import '../../../src/screen/Splash/splash_binding.dart';
import '../../../src/screen/Splash/splash_page.dart';
import '../../../src/screen/bottom_nav/dashboard_page.dart';
import '../../../src/screen/bottom_nav/root_binding.dart';
import '../src/screen/login/binding/login_binding.dart';
import '../src/screen/payment/binding/payment_binding.dart';
import '../src/screen/payment/page/choose_plan_details.dart';
import '../src/screen/practice/binding/performance_controller_binding.dart';
import '../src/screen/savedQuestion/page/saveQuestionDetailPage.dart';
import '../src/screen/savedQuestion/page/saveQuestionListPage.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: SplashScreen.routeName,
        page: () => const SplashScreen(),
        binding: SplashBinding()),
    GetPage(
        name: LoginPage.routeName,
        page: () => LoginPage(),
        binding: LoginBinding()),
    GetPage(
      name: DashboardPage.routeName,
      page: () => DashboardPage(),
      bindings: [RootBinding()],
    ),
    GetPage(name: LeaderboardPage.routeName, page: () => LeaderboardPage()),
    GetPage(name: SaveQuestionList.routeName, page: () => SaveQuestionList()),
    GetPage(name: SavedQuestionDetailPage.routeName, page: () => SavedQuestionDetailPage()),


    GetPage(
        name: NotificationScreen.routeName, page: () => NotificationScreen()),
    GetPage(
        name: ChoosePlanDetails.routeName,
        page: () =>  ChoosePlanDetails(),
        binding: PaymentBinding()),
    GetPage(
        binding: PerformanceControllerBiding(),
        name: PerformanceReportPage.routeName,
        page: () => PerformanceReportPage()),
  ];
}
