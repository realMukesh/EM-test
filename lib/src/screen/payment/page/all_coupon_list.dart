import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/payment/controller/paymentController.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../pages/page/converter.dart';

class UseCoupons extends GetView<PaymentController> {
  final String planId;
  UseCoupons({super.key, required this.planId});

  final PaymentController _paymentController = Get.find();
  TextEditingController _couponCode = TextEditingController();
  var _couponId;
  get couponId => _couponId;

  HtmlConverter _htmlConverter = HtmlConverter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const ToolbarTitle(
          title: 'Apply Coupon',
        ),
      ),
      body: GetX<PaymentController>(
        builder: (controller) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: 80,
                      color: purpleColor.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        enabled: true,
                        controller: _couponCode,
                        style: GoogleFonts.roboto(
                            fontSize: 14, letterSpacing: 0.5),
                        decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TextButton(
                                onPressed: () {
                                  _paymentController.applyCouponApi(
                                      planId: planId,
                                      coupon: _couponCode.text.trim(),
                                      couponId: _couponId.toString());
                                },
                                child: CommonTextViewWidget(
                                  text: "Apply",
                                  color: purpleColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(8),
                            hintText: "Enter your coupon code ",
                            hintStyle: GoogleFonts.roboto(
                              fontSize: 17,
                              color: greyColor,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsets.only(left: 18, top: 14, bottom: 12),
                      child: CommonTextViewWidget(
                        text: "Available Coupons",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _paymentController.couponList.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return InkWell(
                            onTap: () {
                              _couponCode.text = _paymentController
                                  .couponList[index].couponCode!;
                              _couponId = _paymentController.couponList[index].id!;
                              print("_couponId ${_couponId}");
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              color: purpleColor.withOpacity(0.2),
                              padding: const EdgeInsets.only(
                                  left: 16, right: 14, top: 10, bottom: 8),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextViewWidget(
                                    text: _paymentController
                                        .couponList[index].title!,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  CommonTextViewWidget(
                                    text:
                                        "Get ${_paymentController.couponList[index].couponValue} % OFF up to \u{20B9} ${_paymentController.couponList[index].maxDiscount}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Expanded(
                                    child: CommonTextViewWidget(
                                      text: _htmlConverter.parseHtmlString(
                                          _paymentController
                                              .couponList[index].terms!),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  DottedBorder(
                                      options: RoundedRectDottedBorderOptions(
                                        dashPattern: [3, 3],
                                        strokeWidth: 1,
                                        radius: Radius.circular(16),
                                        color: purpleColor,
                                        padding: EdgeInsets.all(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 3.0,
                                            bottom: 3,
                                            left: 10,
                                            right: 10),
                                        child: CommonTextViewWidget(
                                          text: _paymentController
                                              .couponList[index].couponCode
                                              .toString(),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: purpleColor,
                                        ),
                                      )),
                                  const Divider(
                                    thickness: 0.8,
                                  ),
                                  CommonTextViewWidget(
                                    text:
                                        " You will save \u{20B9} ${_paymentController.couponList[index].maxDiscount} with this code",
                                    fontSize: 10,
                                    color: purpleColor,
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
              controller.loading.value ? const Loading() : const SizedBox()
            ],
          );
        },
      ),
    );
  }
}
