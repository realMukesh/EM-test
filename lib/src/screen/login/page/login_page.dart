import 'dart:io';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/widgets/rounded_button.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
import '../../../widgets/already_have_an_account_acheck.dart';
import '../../../widgets/or_divider.dart';
import '../../../../utils/ui_helper.dart';
import '../../../commonController/authenticationController.dart';
import '../../pages/page/Terms&co.dart';
import '../../../auth/sign_up/signup_screen.dart';

class LoginPage extends GetView<LoginController> {
  static const routeName = "/login";
  LoginPage({Key? key}) : super(key: key);

  TextEditingController number = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        //backgroundColor: whiteColor,
        body: GetX<LoginController>(
          builder: (controller) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.07),
                        CommonTextViewWidget(
                          text: "Get Better Every Day, Practice",
                          fontSize: 18,
                          color: colorSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        CommonTextViewWidget(
                          text: "Test Series and Free Daily Quizzes",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorPrimary,
                        ),
                        Image.asset(
                          "assets/img/two_child.png",
                          height: size.height * 0.25,
                        ),
                        ListTile(
                          title: CommonTextViewWidget(
                            text: "Sign In",
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          subtitle: CommonTextViewWidget(
                            text: "Welcome back to login.",
                            fontSize: 18,
                            color: colorPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              enabled: true,
                              controller: number,
                              maxLength: 10,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false),
                              style: GoogleFonts.roboto(
                                  fontSize: 18.fSize,
                                  letterSpacing: 1.0,
                                  /*color: colorSecondary*/),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  prefix: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CommonTextViewWidget(
                                        text: "+91",
                                        color: colorSecondary,
                                        fontSize: 18,
                                      ),
                                      const Icon(Icons.arrow_drop_down),
                                      const SizedBox(
                                        width: 4,
                                      )
                                    ],
                                  ),
                                  prefixStyle: GoogleFonts.roboto(
                                    fontSize: 22,
                                  ),
                                  hintText: "Enter your mobile number ",
                                  hintStyle: GoogleFonts.roboto(
                                    fontSize: 18,
                                    color: greyColor,
                                  )),
                              validator: (String? value) {
                                if (value!.trim().isEmpty ||
                                    value.trim() == null) {
                                  return 'Please enter mobile';
                                } else if (UiHelper.isNumber(value)) {
                                  if (!UiHelper.isValidPhoneNumber(value)) {
                                    return 'Please enter valid mobile number';
                                  }
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RoundedButton(
                            text: "Login",
                            press: () {
                              if (_formKey.currentState!.validate()) {
                                controller.sendOtp(
                                    context: context,
                                    mobile: number.text.trim());
                              }
                            }),
                        const SizedBox(height: 10),
                        const SizedBox(height: 20),
                        Platform.isAndroid ? const OrDivider() : const SizedBox(),
                        Platform.isAndroid
                            ? InkWell(
                                onTap: () async {
                                  controller.handleSignIn(context);
                                },
                                child: Image.asset(
                                  "assets/img/google.png",
                                  scale: 1.8,
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(height: size.height * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonTextViewWidget(
                              text: "By signing up you agree to our ",
                              fontSize: 13,
                              color: colorGray,
                            ),
                            Expanded(child: InkWell(
                              onTap: () {
                                Get.to(() => TermsCond());
                              },
                              child: CommonTextViewWidget(
                                text: "Terms and Condition ",
                                fontSize: 14,
                                color: colorPrimary,
                                linethrough: TextDecoration.underline,
                              ),
                            ),)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: controller.loading.value
                      ? const Loading()
                      : const SizedBox(),
                )
              ],
            );
          },
        ));
  }
}
