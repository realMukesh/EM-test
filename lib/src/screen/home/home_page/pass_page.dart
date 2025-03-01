import 'dart:io';

import 'package:english_madhyam/src/screen/payment/controller/paymentController.dart';
import 'package:english_madhyam/src/screen/payment/model/purchase_history_model.dart';
import 'package:english_madhyam/src/widgets/rounded_button.dart';
import 'package:english_madhyam/src/custom/toolbarTitle.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:get/get.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widgets/purchase_history_widget.dart';
import '../../payment/controller/transectionController.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';

class PassPage extends StatefulWidget {
  PassPage({Key? key}) : super(key: key);

  @override
  State<PassPage> createState() => _PassPageState();
}

class _PassPageState extends State<PassPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TransactionController _controller = Get.put(TransactionController());

  @override
  void initState() {
    super.initState();
    _controller.purchaseHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<TransactionController>(
        builder: (controller) {
          return Scaffold(
            body: Stack(
              children: [
                SafeArea(
                  child: IndexedStack(
                    index: controller.tabIndex,
                    children: [
                      planHistoryList(),
                      Platform.isAndroid
                          ?  ChoosePlanDetails()
                          : InAppPlanDetail()
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget planHistoryList() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const ToolbarTitle(
          title: 'Purchase History',
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: Column(
              children: [
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GetX<TransactionController>(
                          init: _controller,
                          builder: (contr) {
                            if (contr.loading.value) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Center(
                                  child: Lottie.asset(
                                    "assets/animations/loader.json",
                                    height: MediaQuery.of(context).size.height *
                                        0.14,
                                  ),
                                ),
                              );
                            } else {
                              if (contr.planHistoryList
                                      .isEmpty) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CommonTextViewWidget(
                                        text: "No Plan Found",
                                        color: blackColor,
                                      ),
                                      RoundedButton(
                                          text: "Choose Plan",
                                          press: () {
                                            if (Platform.isAndroid) {
                                              Get.toNamed(ChoosePlanDetails.routeName);

                                            } else {
                                              Get.to(() => InAppPlanDetail());
                                            }
                                          })
                                    ],
                                  ),
                                );
                              } else {
                                return refund(
                                    purchase: contr.planHistoryList);
                              }
                            }
                          }),
                    ),
                  ),
                )
              ],
            ),
          ),
                  _controller.planHistoryList.isNotEmpty
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: RoundedButton(
                      text: "Extend Validity",
                      press: () {
                        if(Get.isRegistered<PaymentController>()){
                          PaymentController payment=Get.find();
                          payment.loading(false);
                        }
                        if (Platform.isAndroid) {
                          Get.toNamed(ChoosePlanDetails.routeName);
                        } else {
                          Get.to(() => InAppPlanDetail());
                        }
                      }),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget refund({required List<PurchaseHistory> purchase}) {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: purchase.length,
        itemBuilder: (context, index) {
          var data = purchase[index];
          return PurchaseHistoryWidget(
            data: data,
          );
        });
  }

  void _onRefresh() async {
    // monitor network fetch
    _controller.purchaseHistory();

    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
