import 'dart:ui';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../routes/my_constant.dart';
import '../../utils/app_colors.dart';

class CommonTextViewWidget extends StatelessWidget {
  @required
  String text;
  final String? fontFamily;
  final double? fontSize;
  final Color? color;
  final TextAlign? align;
  final FontWeight? fontWeight;
  final double? letterspace;
  final Locale? locale;
  final TextOverflow? overflow;
  final Paint? foreground;
  final int? maxLine;

  TextDecoration? linethrough;

  CommonTextViewWidget(
      {Key? key,
      this.overflow,
      this.color,
      this.align,
      this.fontFamily,
      this.letterspace,
      this.fontSize = 14,
      this.fontWeight,
      this.locale,
      this.maxLine,
      this.foreground,
      required this.text,
      this.linethrough})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.getFont(MyConstant.currentFont,
          //color: color ?? colorSecondary,
          fontWeight: fontWeight,
          fontSize: fontSize?.fSize,
          decorationColor: color,
          decoration: linethrough),
      textAlign: align,
      maxLines: maxLine,
    );
  }
}

class CommonTextViewWidgetDarkMode extends StatelessWidget {
  @required
  String text;
  final String? fontFamily;
  final double? fontSize;
  final Color? color;
  final TextAlign? align;
  final FontWeight? fontWeight;
  final double? letterspace;
  final Locale? locale;
  final TextOverflow? overflow;
  final Paint? foreground;
  final int? maxLine;

  TextDecoration? linethrough;

  CommonTextViewWidgetDarkMode(
      {Key? key,
        this.overflow,
        this.color,
        this.align,
        this.fontFamily,
        this.letterspace,
        this.fontSize = 14,
        this.fontWeight,
        this.locale,
        this.maxLine,
        this.foreground,
        required this.text,
        this.linethrough})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.getFont(MyConstant.currentFont,
          color: color ?? colorSecondary,
          fontWeight: fontWeight,
          fontSize: fontSize?.fSize,
          decorationColor: color,
          decoration: linethrough),
      textAlign: align,
      maxLines: maxLine,
    );
  }
}
