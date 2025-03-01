import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:english_madhyam/routes/app_pages.dart';
import 'package:english_madhyam/src/auth/binding/auth_binding.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/src/screen/Splash/splash_binding.dart';
import 'package:english_madhyam/src/screen/Splash/splash_page.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:english_madhyam/restApi/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

const debug = true;

void cancel() {
  Future.delayed(const Duration(seconds: 2), () {
    Fluttertoast.cancel();
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    // ..maxConnectionsPerHost = 5;
  }
}

void main() async {
  /// pdf download section
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  /// pdf download initialization
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final android = AndroidInitializationSettings('@mipmap/logo_round');

  if (Platform.isAndroid) {
    final initSettings = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin!.initialize(initSettings);
  }
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: debug, ignoreSsl: true);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: themePurpleColor,
      statusBarColor: themePurpleColor));

  AwesomeNotifications().initialize(
    'resource://drawable/logo_round',
    [
      NotificationChannel(
        channelName: 'Basic Notification',
        channelKey: 'test_channel',
        channelGroupKey: 'basic_tests',
        playSound: true,
        channelDescription: 'Notification for Test',
        channelShowBadge: true,
      ),
    ],
    channelGroups: [
      // NotificationChannelGroup(
      //   channelGroupName: "Basic tests",
      //   channelGroupkey: 'basic_tests',
      // ),
    ],
    debug: true,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
  ));

  await GetStorage.init();
  initServices();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    await AwesomeNotifications().createNotificationFromJsonData(message.data);
  }
}

void initServices() {
  Get.put<AuthenticationManager>(
    AuthenticationManager(),
  );
  Get.putAsync<ApiService>(() => ApiService().init());
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({Key? key, this.savedThemeMode});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return AdaptiveTheme(
        light: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.blue,
            fontFamily: GoogleFonts.poppins().fontFamily),
        dark: ThemeData(
          useMaterial3: true,
          fontFamily: GoogleFonts.roboto().fontFamily,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => GetMaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          defaultTransition: Transition.fade, // Applies to all `Get.to()` calls
          debugShowCheckedModeBanner: false,
          title: 'English Madhyam',
          initialBinding: InitialBindings(),
          getPages: AppPages.pages,
          initialRoute: SplashScreen.routeName,
        ),
      );
    });
  }
}
