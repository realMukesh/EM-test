import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../common_textview_widget.dart';

class RoundedOutlineButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final double radius;
  final bool showIcon;
  const RoundedOutlineButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorSecondary,
      this.textColor = colorSecondary,
      this.textSize = 14,
        this.radius=12,
      this.showIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: size.width,
      height: 55,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.white,
            side: BorderSide(color: color, width: 1),
            shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius))),
          ),
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              press();
            });
          },
          child: CommonTextViewWidget(
            text: text,
            color: textColor,
            fontSize: textSize,
          )),
    );
  }
}