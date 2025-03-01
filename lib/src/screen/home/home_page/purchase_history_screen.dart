import 'dart:io';
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

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final TransactionController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.purchaseHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const ToolbarTitle(title: "Purchase History"),
      ),
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Stack(
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
                            init: TransactionController(),
                            builder: (contr) {
                              if (contr.loading.value) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  child: Center(
                                    child: Lottie.asset(
                                      "assets/animations/loader.json",
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.14,
                                    ),
                                  ),
                                );
                              } else {
                                if (contr.planHistoryList.isEmpty) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
          ],
        ),
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
