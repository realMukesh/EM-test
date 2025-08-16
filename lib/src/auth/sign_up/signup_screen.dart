import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/auth/sign_up/controller/signup_controller.dart';
import 'package:english_madhyam/src/commonController/authenticationController.dart';
import 'package:english_madhyam/main.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/rounded_button.dart';
import '../../../utils/ui_helper.dart';

class RegisterScreen extends StatefulWidget {
  final String? mobile;
  final String? email;

  const RegisterScreen({Key? key, this.mobile, this.email}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var emailController = TextEditingController();
  var dobController = TextEditingController();

  final AuthenticationManager authenticationController = Get.find();
  final controller = Get.put(SignupController());

  dynamic dropdownvalueCity;
  dynamic dropdownvalueState;

  final _formKey = GlobalKey<FormState>();
  DateTime? dateTime;
  late int _state, _city;
  String boardData = "";
  String classData = "";

  bool state = false;

  @override
  void initState() {
    super.initState();
    mobileController.text = widget.mobile ?? "";
    emailController.text = widget.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: black),
      ),
      body: GetX<SignupController>(builder: (controller) {
        return Form(
          key: _formKey,
          child: SafeArea(
              child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(left: 20, right: 20),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Welcome to ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          AdaptiveTheme.of(context).mode.isDark
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 18)),
                              const TextSpan(
                                  text: 'English Madhyam',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff476CFF),
                                      fontSize: 18)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CommonTextViewWidget(
                            text: "Tell us about yourself",
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset(
                      "assets/img/signup.png",
                      height: 100,
                      alignment: Alignment.center,
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    style: GoogleFonts.roboto(
                        fontSize: 18.fSize, letterSpacing: 1.0),
                    decoration: const InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty || value.trim() == null) {
                        return "Please enter name.";
                      }
                      if (!UiHelper.isValidName(value.toString())) {
                        return "Please enter valid name.";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: widget.email != null && widget.email!.isNotEmpty
                        ? true
                        : false,
                    controller: emailController,
                    maxLength: 50,
                    enabled: widget.email != null && widget.email!.isNotEmpty
                        ? false
                        : true,
                    validator: (value) {
                      if (value!.trim().isEmpty || value.trim() == null) {
                        return "Please enter email Id.";
                      }
                      if (!UiHelper.isEmail(value.toString())) {
                        return "Please enter valid email Id.";
                      }
                    },
                    style: GoogleFonts.roboto(
                        fontSize: 18.fSize, letterSpacing: 1.0),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 16, bottom: 8),
                      labelText: "Email Id",
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.phone,
                    readOnly: widget.mobile != null && widget.mobile!.isNotEmpty
                        ? true
                        : false,
                    controller: mobileController,
                    maxLength: 10,
                    enabled: widget.mobile != null && widget.mobile!.isNotEmpty
                        ? false
                        : true,
                    validator: (value) {
                      if (value!.trim().isEmpty || value.trim() == null) {
                        return "Please enter mobile number.";
                      }
                      if (!UiHelper.isMobileValid(value.toString())) {
                        return "Please enter valid mobile number.";
                      }
                    },
                    style: GoogleFonts.roboto(
                        fontSize: 18.fSize, letterSpacing: 1.0),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 16, bottom: 8),
                      labelText: "Mobile Number",
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RoundedButton(
                      text: "Signup",
                      press: () async {
                        if (_formKey.currentState!.validate()) {
                          FirebaseMessaging.instance.getToken().then((token) {
                            authenticationController.saveFcmToken(token);
                            print('token: $token');
                          }).catchError((err) {
                            print("This is bug from FCM${err.message.toString()}");
                          });

                          Map requestBody = {
                            "name": nameController.text.trim(),
                            "phone": widget.mobile != null &&
                                    widget.mobile!.isNotEmpty
                                ? widget.mobile!
                                : mobileController.text.trim(),
                            "email":
                                widget.email != null && widget.email!.isNotEmpty
                                    ? widget.email!
                                    : emailController.text.trim(),
                            "deviceID": await UiHelper.getDeviceId(),
                            "deviceToken":
                                authenticationController.getFcmToken() ?? "",
                            "deviceType":
                                Platform.isAndroid ? "Android" : "IOS",
                          };
                          controller.signup(requestBody);
                        }
                      }),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
              controller.loading.value ? const Loading() : const SizedBox()
            ],
          )),
        );
      }),
    );
  }
}
