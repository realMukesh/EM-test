import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:english_madhyam/src/screen/payment/controller/paymentController.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../material/model/plan_detial.dart';
import '../../pages/page/setup.dart';

class PlanWidget extends GetView<PaymentController> {
  PlanData planData;
  int index;
  PlanWidget({super.key,required this.planData,required this.index});

  @override
  Widget build(BuildContext context) {
    return  GetX<PaymentController>(builder: (controller){
      return Container(
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 12),
        decoration: BoxDecoration(
          color: AdaptiveTheme.of(context).mode.isDark?Colors.black:white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Stack(
          children: [
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  controller.selectedPlanIndex.value == index
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: controller.selectedPlanIndex.value == index
                      ? primaryColor
                      : Colors.grey,
                ),
              ),
              title: CommonTextViewWidget(
                text: "${planData.duration} Months",
                align: TextAlign.start,
                fontSize: 16,
              ),
              subtitle: CommonTextViewWidget(
                align: TextAlign.start,
                color: primaryColor,fontWeight: FontWeight.w500,
                text:planData.perDay!
                    .toString()
                    .length >
                    5
                    ? "(${planData.perDay!.toString().substring(0, 5)})" +
                    " per day"
                    : "${planData.perDay!}per day",
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  planData.discount != 0
                      ? DottedBorder(
                      borderType: BorderType.RRect,
                      dashPattern: const [3, 3],
                      color: primaryColor,
                      strokeWidth: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 3.0, bottom: 3, left: 10, right: 10),
                        child: CommonTextViewWidget(
                          text:
                          "${planData.discount}% OFF",
                          color: primaryColor,
                        ),
                      ))
                      : const SizedBox(),
                  const SizedBox(
                    height: 6,
                  ),

                ],
              ),
            ),
            Positioned(
              bottom: 0,right: 0,
              child: SizedBox(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    planData.mrp != planData.fee!
                        ? Text(
                      "\u{20B9} ${planData.mrp}",
                      style: GoogleFonts.roboto(
                          color: examGreyColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough),
                    )
                        : const SizedBox(),
                    const SizedBox(
                      width: 10,
                    ),
                    CommonTextViewWidget(
                      text: "\u{20B9} ${planData.fee}",
                      fontSize: 18,
                    ),
                  ],
                ),
              ),),
          ],
        ),
      );
    },);
  }
}
