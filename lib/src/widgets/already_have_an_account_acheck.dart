import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import 'package:flutter/material.dart';

import 'common_textview_widget.dart';


class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  const AlreadyHaveAnAccountCheck(this.login, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CommonTextViewWidget(text:login ? "Don't have an account?" : "Already have an account?",color: Colors.black,),
        SizedBox(width: 6,),
        CommonTextViewWidget(text: login ? "Signup" : "Login",color: colorPrimary,)
      ],
    );
  }
}
