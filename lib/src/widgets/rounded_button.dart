import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'common_textview_widget.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final double height;
  final bool showIcon;
  final FontWeight weight;
  final double radius;

  const RoundedButton(
      {Key? key,
      required this.text,
      required this.press,
      this.color = colorPrimary,
      this.textColor = Colors.white,
      this.textSize = 18,
      this.showIcon = false,
      this.height = 55,
      this.radius = 30,
      this.weight = FontWeight.bold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      height: 55.adaptSize,
      width: size.width,
      child: MaterialButton(
          animationDuration: const Duration(seconds: 1),
          color: color,
          hoverColor: colorPrimary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              press();
            });
          },
          child: CommonTextViewWidgetDarkMode(
            text: text,
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            /*weight: weight,*/
          )),
    );
  }
}
