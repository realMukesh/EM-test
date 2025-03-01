import 'package:english_madhyam/src/screen/payment/widget/plan_widget.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/screen/payment/page/all_coupon_list.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../widgets/rounded_button.dart';
import '../../material/model/plan_detial.dart';
import '../controller/paymentController.dart';

class ChoosePlanDetails extends GetView<PaymentController> {
  static const routeName = "/choosePlanDetail";

  ChoosePlanDetails({super.key});

  @override
  final PaymentController controller = Get.put(PaymentController());

  void _onRefresh() async {
    // monitor network fetch
    controller.selectedPlanIndex.value = 0;
    controller.couponCode.value = "";
    controller.selectedCouponId.value = "";
    controller.getPlanDetails();
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: const ToolbarTitle(
            title: 'Choose Your Plan',
          ),
        ),
        body: GetX<PaymentController>(
          builder: (controller) {
            return Stack(
              children: [
                SmartRefresher(
                  onRefresh: _onRefresh,
                  controller: RefreshController(),
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          "assets/img/ribbon.png",
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.6,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                        child: Row(
                          children: [
                            Image.asset("assets/img/unlocked.png"),
                            const SizedBox(
                              width: 10,
                            ),
                            CommonTextViewWidget(
                              text: "Access to all paid content",
                              fontSize: 14,
                              color: const Color(0xff676767),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                        child: Row(
                          children: [
                            Image.asset("assets/img/touch.png"),
                            const SizedBox(
                              width: 10,
                            ),
                            CommonTextViewWidget(
                              text: "Unlimited Tapping for Meaning",
                              fontSize: 14,
                              color: const Color(0xff676767),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.planList.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            PlanData planData = controller.planList[index];
                            return GestureDetector(
                                onTap: () {
                                  controller.couponCode.value = "";
                                  controller.selectedPlanIndex.value = index;
                                  controller.planList.refresh();
                                },
                                child: PlanWidget(
                                  planData: planData,
                                  index: index,
                                ));
                          }),
                      InkWell(
                        onTap: () async {
                          await controller.getCouponListApi();
                          if (controller.couponList.isNotEmpty &&
                              controller.planList.isNotEmpty) {
                            Get.to(() => UseCoupons(
                                  planId: controller
                                      .planList[
                                          controller.selectedPlanIndex.value]
                                      .id
                                      .toString(),
                                ));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: purpleColor.withOpacity(0.09),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          margin: EdgeInsets.symmetric(
                              horizontal: 12.adaptSize, vertical: 12.adaptSize),
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.adaptSize, vertical: 12.adaptSize),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icon/coupon.svg",
                                    height: 40,
                                  ),
                                  CommonTextViewWidget(
                                    text: "Use coupons",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              const Icon(Icons.keyboard_arrow_right_outlined)
                            ],
                          ),
                        ),
                      ),
                      controller.couponCode.value == ""
                          ? const SizedBox()
                          : Container(
                              padding: const EdgeInsets.all(2),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: greenColor)),
                              child: CommonTextViewWidget(
                                text:
                                    "Applied Coupon : ${controller.couponCode.value}",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      controller.couponCode.value == ""
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonTextViewWidget(
                                              text: "You Saved:"),
                                          CommonTextViewWidget(
                                              text:
                                                  "\u{20B9}${controller.selectedCouponDetails.value.discount.toString().length > 5 ? controller.selectedCouponDetails.value.discount.toString().substring(0, 5) : controller.selectedCouponDetails.value.discount.toString()}")
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CommonTextViewWidget(
                                              text: "Final Amount:"),
                                          CommonTextViewWidget(
                                              text:
                                                  "\u{20B9}${controller.selectedCouponDetails.value.finalAmount}")
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 6,
                      ),
                      controller.loading.value == false
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: RoundedButton(
                                text: 'JOIN NOW',
                                press: () async {
                                  String orderId =
                                      await controller.getOrderId();
                                  if (orderId.isNotEmpty) {
                                    if (controller.couponCode.value != "") {
                                      controller.openCheckout(
                                          amount: (double.parse(controller
                                              .selectedCouponDetails
                                              .value
                                              .finalAmount
                                              .toString())),
                                          orderId: orderId);
                                    } else {
                                      controller.openCheckout(
                                          amount: (double.parse(controller
                                              .planList[controller
                                                  .selectedPlanIndex.value]
                                              .fee!
                                              .toString())),
                                          orderId: orderId);
                                    }
                                  } else {
                                    /*if (controller.couponCode.value != "") {
                                      controller.openCheckout((double.parse(
                                          controller.selectedCouponDetails.value
                                              .finalAmount
                                              .toString())));
                                    } else {
                                      controller.openCheckout((double.parse(
                                          controller
                                              .planList[controller
                                              .selectedPlanIndex.value]
                                              .fee!
                                              .toString())));
                                    }*/
                                  }
                                },
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Center(
                                child: Lottie.asset(
                                    "assets/animations/loader.json"),
                              ),
                            ),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  )),
                ),
                controller.loading.value ? const Loading() : const SizedBox()
              ],
            );
          },
        ));
  }
}
