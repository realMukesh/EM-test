/*
import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';

class CommonTextViewWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final bool underline;
  final bool centerUnderline;
  final TextAlign align;
  final int maxLine;
  final FontWeight fontWeight;

  const CommonTextViewWidget({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 14,
    this.underline = false,
    this.centerUnderline = false,
    this.align = TextAlign.start,
    this.maxLine = 1,
    this.fontWeight=FontWeight.normal
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: align,
        maxLines: maxLine,
        softWrap: true,
        style: TextStyle(
            fontWeight: fontWeight,
            fontFamily: 'Poppins',
            color: color,
            fontSize: fontSize.fSize,
            overflow: TextOverflow.ellipsis,
            decoration: underline
                ? TextDecoration.underline
                : centerUnderline
                    ? TextDecoration.lineThrough
                    : TextDecoration.none));
  }
}
*/
