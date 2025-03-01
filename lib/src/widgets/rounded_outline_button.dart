
import 'package:flutter/material.dart';
import '../utils/colors/colors.dart';
import 'package:english_madhyam/utils/app_colors.dart';

import 'common_textview_widget.dart';



class RoundedOutlineButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final double textSize;
  final bool showIcon;
  const RoundedOutlineButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = colorPrimary,
    this.textColor = colorPrimary,
    this.textSize=14,
    this.showIcon=false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      width: size.width,
      height: 55,
      child: OutlinedButton(
          child: CommonTextViewWidget(text: text,color: textColor,fontSize: textSize),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.white,
            side: BorderSide(color: color, width: 1),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          onPressed: (){
            Future.delayed(Duration.zero, () async {
              press();
            });
          }
      ),
    );
  }
}

