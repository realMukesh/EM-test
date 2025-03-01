import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import 'button/custom_icon_button.dart';

class CustomDialogWidget extends StatelessWidget {
  final String title, description, buttonCancel, buttonAction, logo;
  final bool? isShowBtnCancel;
  final VoidCallback? onCancelTap, onActionTap;

  const CustomDialogWidget(
      {super.key,
        required this.logo,
        required this.title,
        required this.description,
        required this.buttonCancel,
        required this.buttonAction,
        this.onCancelTap,this.isShowBtnCancel,
        this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          //color: bgColor,
          border: Border.all(color: const Color(0xffDCE2E6)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            logo.isNotEmpty?Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color.fromRGBO(244, 243, 247, 1),
              ),
              child: !logo.contains(".svg")
                  ? Image.asset(logo, scale: 3.5,)
                  : Padding(
                padding: const EdgeInsets.all(14.0),
                child: SvgPicture.asset(logo),
              ),
            ):const SizedBox(),
            const SizedBox(
              height: 25,
            ),
            CommonTextViewWidget(
              text: title,
              align: TextAlign.center,
              fontSize: 22.0,
              color: colorSecondary,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 16.0),
            CommonTextViewWidget(
              text: description,
              align: TextAlign.center,
              fontSize: 16.0,
              color: colorSecondary,
              maxLine: 100,
              fontWeight: FontWeight.normal,
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                isShowBtnCancel!=null?const SizedBox():Expanded(
                  flex: 1,
                  child: CustomIconButton(
                    height: 45.v,
                    decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: colorGray, width: 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: context.width,
                    onTap: () {
                      onCancelTap!();
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: CommonTextViewWidgetDarkMode(
                        text: buttonCancel,
                        fontSize: 16,
                        maxLine: 1,
                        fontWeight: FontWeight.normal,
                        color: colorSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: isShowBtnCancel!=null?0:10.h,
                ),
                Expanded(
                  flex: 1,
                  child: CustomIconButton(
                    height: 45.v,
                    decoration: BoxDecoration(
                        color: colorPrimary,
                        border: Border.all(color: colorPrimary, width: 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: context.width,
                    onTap: (){
                      onActionTap!();
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: CommonTextViewWidgetDarkMode(
                        text: buttonAction,
                        fontSize: 16,
                        maxLine: 1,fontWeight: FontWeight.normal,
                        color: white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
