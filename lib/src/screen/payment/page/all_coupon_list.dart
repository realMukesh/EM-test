import 'dart:ui' as BorderType;

import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/payment/controller/paymentController.dart';
import 'package:english_madhyam/src/utils/colors/colors.dart';
import 'package:english_madhyam/src/screen/pages/page/custom_dmsans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../pages/page/converter.dart';

class UseCoupons extends StatefulWidget {
  final String planId;

  const UseCoupons({Key? key, required this.planId}) : super(key: key);

  @override
  State<UseCoupons> createState() => _UseCouponsState();
}

class _UseCouponsState extends State<UseCoupons> {
  final PaymentController _paymentController = Get.find();
  TextEditingController _couponCode = TextEditingController();
  HtmlConverter _htmlConverter = HtmlConverter();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:whiteColor,
      appBar: AppBar(
        //backgroundColor: whiteColor,
        elevation: 0.0,
        centerTitle: true,
        title: ToolbarTitle(title: 'Apply Coupon',),
      ),
      body: Container(
        //color: purpleColor.withOpacity(0.2),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12,),
              Container(
                height: 80,
                color: purpleColor.withOpacity(0.2),
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  enabled: true,
                  controller: _couponCode,
                  style: GoogleFonts.roboto(fontSize: 14, letterSpacing: 0.5),
                  decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          _paymentController.applyCouponContr(
                              PlanID: widget.planId,
                              Coupon: _couponCode.text.trim());

                        },
                        child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: purpleColor)),
                            child: CustomDmSans(
                              text: "Apply",
                              color: purpleColor,
                            )),
                      ),
                      contentPadding: const EdgeInsets.all(8),
                      hintText: "Enter your coupon code ",

                      hintStyle: GoogleFonts.roboto(
                        fontSize: 16,
                        color: greyColor,
                      )),
                ),
              ),
              const SizedBox(height: 12,),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 18, top: 14, bottom: 12),
                child: CustomDmSans(
                  text: "Available Coupons",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Obx(
                () {
                  if (_paymentController.CouponListloading.value) {
                    return Center(
                      child: Lottie.asset(
                        "assets/animations/loader.json",
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                    );
                  } else if (_paymentController
                      .couponListcontr.value.couponsList!.isEmpty) {

                    return Center(
                      child: Lottie.asset('assets/animations/49993-search.json',
                          height: MediaQuery.of(context).size.height * 0.2),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _paymentController
                            .couponListcontr.value.couponsList!.length,
                        itemBuilder: (BuildContext ctx, int index) {

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _couponCode.text = _paymentController
                                    .couponListcontr
                                    .value
                                    .couponsList![index]
                                    .couponCode!;
                              });
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
                                  CustomDmSans(
                                    text: _paymentController.couponListcontr
                                        .value.couponsList![index].title!,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  CustomDmSans(
                                    text:
                                        "Get ${_paymentController.couponListcontr.value.couponsList![index].couponValue} % OFF up to \u{20B9} ${_paymentController.couponListcontr.value.couponsList![index].maxDiscount}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Expanded(
                                    child: CustomDmSans(
                                      text: _htmlConverter.parseHtmlString(
                                          _paymentController.couponListcontr.value
                                              .couponsList![index].terms!),
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
                                        child: Text(
                                          _paymentController
                                              .couponListcontr
                                              .value
                                              .couponsList![index]
                                              .couponCode
                                              .toString(),
                                          style: GoogleFonts.roboto(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                              color: purpleColor),
                                        ),
                                      )),
                                  const Divider(
                                    thickness: 0.8,
                                  ),
                                  CustomDmSans(
                                    text:
                                        " You will save \u{20B9} ${_paymentController.couponListcontr.value.couponsList![index].maxDiscount} with this code",
                                    fontSize: 10,
                                    color: purpleColor,
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
