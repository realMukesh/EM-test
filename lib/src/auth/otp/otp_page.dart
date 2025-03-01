import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../screen/login/controller/login_controller.dart';
import '../../widgets/common_textview_widget.dart';
import '../../widgets/loading.dart';
import '../../widgets/regularTextViewDarkMode.dart';
import '../../widgets/rounded_button.dart';

class OtpPage extends StatefulWidget {
  final String mobile;

  const OtpPage({Key? key, required this.mobile}) : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final AuthenticationManager authenticationController = Get.find();
  final LoginController controller = Get.find();

  TextEditingController otp = TextEditingController();
  final ValueNotifier<String> otpErrorNotifier = ValueNotifier<String>("");
  late Timer _timer;
  String otpCode = "";
  int _start = 60;
  var resentMsg = 'Resend OTP';
  var isTimerIsRunning = false;
  var isTimerEmailIsRunning = false;

  final scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      //backgroundColor: whiteColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.05),
                  CommonTextViewWidget(
                    text: "Get Better Every Day, Practice",
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  CommonTextViewWidget(
                    text: "Test Series and Free Daily Quizzes",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: purpleColor,
                  ),
                  Image.asset(
                    "assets/img/two_child.png",
                    height: size.height * 0.25,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CommonTextViewWidget(
                    text:
                        "We have sent verification code to your registered Phone.",
                    align: TextAlign.center,
                    fontSize: 16,
                    color: colorPrimary,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonTextViewWidget(
                        text: widget.mobile,
                        fontSize: 16,
                        color: colorSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.edit),
                      )
                    ],
                  ),
                  SizedBox(height: context.height * 0.05),
                  Pinput(
                    length: 4,
                    defaultPinTheme: controller.defaultPinTheme,
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    pinAnimationType: PinAnimationType.fade,
                    animationCurve: Curves.linear,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Only allows numbers
                    ],
                    onCompleted: (pin) {
                      setState(() {
                        otpCode = pin;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        if (value.length < 2) {
                          otpCode = "";
                        }
                      });
                    },
                    cursor: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 2,
                            height: 23,
                            color: indicatorColor,
                          ),
                        ),
                      ],
                    ),
                    focusedPinTheme: controller.defaultPinTheme.copyWith(
                      decoration: controller.defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: colorSecondary),
                      ),
                    ),
                    submittedPinTheme: controller.defaultPinTheme.copyWith(
                      decoration: controller.defaultPinTheme.decoration!.copyWith(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: colorSecondary),
                      ),
                    ),
                    errorPinTheme: controller.defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                 /* OTPTextField(
                    length: 4,
                    otpFieldStyle: AdaptiveTheme.of(context).mode.isDark
                        ? OtpFieldStyle(
                            borderColor: white,
                            enabledBorderColor: white,
                            focusBorderColor: white,
                            errorBorderColor: red)
                        : null,
                    width: context.width,
                    fieldWidth: 55.0,
                    outlineBorderRadius: 7,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    style: TextStyle(
                        color: AdaptiveTheme.of(context).mode.isDark
                            ? Colors.white
                            : colorSecondary,
                        fontSize: 16.fSize),
                    onChanged: (pin) {
                      setState(() {
                        if (pin.length < 2) {
                          otpCode = "";
                        }
                      });
                    },
                    onCompleted: (pin) {
                      setState(() {
                        otpCode = pin;
                      });
                    },
                  ),*/
                  SizedBox(height: context.height * 0.05),
                  RoundedButton(
                      text: "Verify OTP",
                      press: () {
                        if (otpCode.isEmpty) {
                          UiHelper.showSnakbarMsg(context, "Please enter OTP.");
                          return;
                        } else {
                          controller.login(
                              email: "",
                              phone: widget.mobile,
                              context: context,
                              otp: otpCode);
                        }
                      }),
                  SizedBox(height: context.height * 0.03),
                  Center(
                      child: isTimerIsRunning
                          ? CommonTextViewWidget(
                              text: '${"Resend In"} $_start ${"Seconds"}',
                              fontSize: 14)
                          : resentOTPWidget(context)),
                  SizedBox(height: context.height * 0.03),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Obx(() => controller.loading.value ||
                    authenticationController.loading.value
                ? const Loading()
                : const SizedBox()),
          )
        ],
      ),
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isTimerIsRunning = false;
          });
        } else {
          setState(() {
            _start--;
            isTimerIsRunning = true;
          });
        }
      },
    );
  }

  Widget resentOTPWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CommonTextViewWidget(
          text: "Don’t Receive the Code?",
        ),
        GestureDetector(
          onTap: () async {
            controller.sendOtp(context: context, mobile: widget.mobile);
            _start = 60;
            startTimer();
          },
          child: CommonTextViewWidget(
            text: "Resend OTP",
            linethrough: TextDecoration.underline,
            color: colorPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
