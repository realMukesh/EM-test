import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/app_colors.dart';
import '../button/custom_icon_button.dart';

class CustomAnimatedDialogWidget extends StatelessWidget {
  final String title, description, buttonCancel, buttonAction, logo;
  final VoidCallback? onCancelTap, onActionTap;
  final bool? isHideCancelBtn;

  const CustomAnimatedDialogWidget(
      {super.key,
        required this.logo,
        required this.title,
        required this.description,
        required this.buttonCancel,
        required this.buttonAction,
        this.isHideCancelBtn,
        this.onCancelTap,
        this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 31),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: indicatorColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              logo.isNotEmpty
                  ? logo.contains("http") || logo.contains("https")
                  ? Image.network(logo, height: 100.adaptSize)
                  : logo.contains("json")
                  ? Lottie.asset(logo, width: 100)
                  : logo.contains("svg")
                  ? SvgPicture.asset(logo, height: 100.adaptSize)
                  : Image.asset(logo, height: 76.adaptSize)
                  : Lottie.asset("assets/animations/success.json", width: 100),
              const SizedBox(height: 0.0),
              title.isNotEmpty
                  ? CommonTextViewWidgetDarkMode(
                text: title,
                align: TextAlign.center,
                fontSize: 22.0,
                color: colorSecondary,
                fontWeight: FontWeight.w600,
              )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              CommonTextViewWidgetDarkMode(
                text: description,
                align: TextAlign.center,
                fontSize: 16.0,
                color: colorSecondary,
                maxLine: 100,
                fontWeight: FontWeight.normal,
              ),
              const SizedBox(height: 22.0),
              Row(
                children: [
                  isHideCancelBtn != null
                      ? const SizedBox()
                      : Expanded(
                    flex: 1,
                    child: CustomIconButton(
                      height: 50.v,
                      decoration: BoxDecoration(
                          color: white,
                          border: Border.all(color: colorGray, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      width: context.width,
                      onTap: () {
                        onCancelTap!();
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: CommonTextViewWidget(
                          text: buttonCancel,
                          fontSize: 16,
                          maxLine: 1,
                          fontWeight: FontWeight.w500,
                          color: colorSecondary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                          isHideCancelBtn ?? false ? 40.adaptSize : 0),
                      child: CustomIconButton(
                        height: 45.v,
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            border: Border.all(color: colorPrimary, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        width: context.width,
                        onTap: () {
                          Navigator.of(context).pop();
                          onActionTap?.call();
                        },
                        child: Center(
                          child: CommonTextViewWidgetDarkMode(
                            text: buttonAction,
                            fontSize: 16,
                            maxLine: 1,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
