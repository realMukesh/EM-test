import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../widgets/common_textview_widget.dart';
class ToolbarTitle extends StatelessWidget {
  final String title;
  final Color color;
  const ToolbarTitle({
    Key? key,
    required this.title,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonTextViewWidget(
      text: title,
      color:AdaptiveTheme.of(context).mode.isDark?white:colorSecondary,
      fontSize: 22,fontWeight: FontWeight.w500,
      align: TextAlign.left,
    );
  }
}
