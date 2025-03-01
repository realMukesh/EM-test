import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'common_textview_widget.dart';
class FreePaidWidget extends StatelessWidget {
  dynamic type;
  FreePaidWidget({super.key,required this.type});

  @override
  Widget build(BuildContext context) {
    return type.toString() =="0" ? freeWidget() : paidWidget();

  }
  Widget freeWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
     /* decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: Colors.green,
      ),*/
      child:  CommonTextViewWidgetDarkMode(
        text: "Free",
        color: colorPrimary,
        fontSize: 12,fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget paidWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      /*decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: Colors.blue,
      ),*/
      child:  CommonTextViewWidgetDarkMode(
        text: "Premium",
        color: colorPrimary,fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }
}
