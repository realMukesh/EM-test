import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/app_colors.dart';
import 'common_textview_widget.dart';
class PurchaseHistoryWidget extends StatelessWidget {
  var data;
  PurchaseHistoryWidget({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
            color: AdaptiveTheme.of(context).mode.isDark ? Colors.transparent :
            colorLightGray,
            border: Border.all(color: AdaptiveTheme.of(context).mode.isDark?Colors.transparent:indicatorColor, width: 0.7),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextViewWidget(
                text: data.planTitle!.length > 20
                    ? "${data.planTitle!.substring(0, 18)}.."
                    : data.planTitle!,
                fontWeight: FontWeight.w600,
                color: colorSecondary,
                fontSize: 18,
              ),
              const SizedBox(
                height: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextViewWidget(
                          text: 'Date of Purchase :${data.startDate}',
                          fontSize: 14,fontWeight: FontWeight.w500,
                          color: colorSecondary,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CommonTextViewWidget(
                          text: 'End Date of Subscription :${data.endDate}',
                          fontSize: 14,fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CommonTextViewWidget(
                          text:
                          "Plan Duration : ${data.planDuration!} Month",
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Platform.isIOS
                        ? buildText(data)
                        : CommonTextViewWidget(
                      text: " \u{20B9}${data.fee!.toString()}",
                      color: colorPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
  buildText(dynamic purchaseHistory) {
    if (purchaseHistory.planDuration == 1) {
      return CommonTextViewWidget(
        text: " \u{20B9}${"105"}",
        color: greenColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
    } else if (purchaseHistory.planDuration == 3) {
      return CommonTextViewWidget(
        text: " \u{20B9}${"259"}",
        color: greenColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
    } else if (purchaseHistory.planDuration == 12) {
      return CommonTextViewWidget(
        text: " \u{20B9}${"649"}",
        color: greenColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
    } else if (purchaseHistory.planDuration == 6) {
      return CommonTextViewWidget(
        text: " \u{20B9}${"449"}",
        color: greenColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
    } else {
      return SizedBox();
    }
  }

}
