import 'dart:io';

import 'package:english_madhyam/src/screen/home/model/home_model/home_model.dart';
import 'package:english_madhyam/src/widgets/free_paid_widget.dart';
import 'package:english_madhyam/src/widgets/loading.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/editorial_controller.dart';
import 'package:english_madhyam/src/screen/editorials_page/controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/editorials_details.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';

import '../../../../utils/ui_helper.dart';
import '../../../utils/colors/colors.dart';
import '../../../widgets/common_textview_widget.dart';
import '../../../widgets/editorial_child_widget.dart';
import '../../material/controller/materialController.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';

class EditorialListViewWidget extends StatefulWidget {
  final int type;
  final List<Editorials>? editorials;
  final String? date;

  const EditorialListViewWidget(
      {Key? key, required this.type, this.editorials, this.date})
      : super(key: key);

  @override
  State<EditorialListViewWidget> createState() =>
      _EditorialListViewWidgetState();
}

class _EditorialListViewWidgetState extends State<EditorialListViewWidget> {
  final ProfileControllers _profileController = Get.find();

  final EditorialController _coursesController = Get.put(EditorialController());

  final EditorialDetailController detailController =
      Get.put(EditorialDetailController());

  final MaterialController _planDetailsController =
      Get.put(MaterialController());

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    return Future.delayed(
      const Duration(seconds: 1),
      () {
        _coursesController.selectDate(
            date: _coursesController.select_date.value, isRefresh: false);
        _refreshController.refreshCompleted();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 0) {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.editorials!.length,
          itemBuilder: (BuildContext ctx, int index) {
            return InkWell(
                onTap: () {
                  if (widget.editorials![index].type == "PAID" &&
                      _profileController
                              .isSubscriptionActive) {
                    try {
                      Get.to(() => EditorialsDetailsPage(
                            editorial_id: widget.editorials![index].id!.toInt(),
                            editorial_title:
                                widget.editorials![index].title.toString(),
                          ));
                    } catch (e) {
                      // print(e);
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  } else if (widget.editorials![index].type == "PAID" &&
                      _profileController
                              .isSubscriptionActive==false) {
                    //pay page
                    if (Platform.isAndroid) {
                      Get.toNamed(ChoosePlanDetails.routeName);
                    } else {
                      Get.to(() => InAppPlanDetail());
                    }
                  } else {
                    detailController.meaningList(
                        id: widget.editorials![index].id!.toString());
                    Get.to(() => EditorialsDetailsPage(
                          editorial_id: widget.editorials![index].id!.toInt(),
                          editorial_title:
                              widget.editorials![index].title.toString(),
                        ));
                  }
                },
                child: EditorialChildWidget(
                  index: index,isFromHome: true,
                  editorials: widget.editorials![index],
                ));
          });
    } else {
      return SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: GetX<EditorialController>(
            builder: (_courseController) {
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              controller: _courseController.editorialList,
                              itemCount:
                                  _courseController.editorialListing.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return InkWell(
                                    onTap: () {
                                      if (_courseController
                                              .editorialListing[index].type ==
                                          "FREE") {
                                        detailController.meaningList(
                                            id: _courseController
                                                .editorialListing[index].id!
                                                .toString());

                                        Get.to(() => EditorialsDetailsPage(
                                              editorial_title: _courseController
                                                  .editorialListing[index].title
                                                  .toString(),
                                              editorial_id: _courseController
                                                  .editorialListing[index].id!
                                                  .toInt(),
                                            ));
                                      } else {
                                        if (_profileController.isSubscriptionActive==false) {
                                          if (Platform.isAndroid) {
                                            Get.toNamed(ChoosePlanDetails.routeName);
                                          } else {
                                            Get.to(() => InAppPlanDetail());
                                          }
                                        } else {
                                          detailController.meaningList(
                                              id: _courseController
                                                  .editorialListing[index].id!
                                                  .toString());

                                          Get.to(() => EditorialsDetailsPage(
                                                editorial_title:
                                                    _courseController
                                                        .editorialListing[index]
                                                        .title
                                                        .toString(),
                                                editorial_id: _courseController
                                                    .editorialListing[index].id!
                                                    .toInt(),
                                              ));
                                        }
                                      }
                                    },
                                    child: EditorialChildWidget(
                                      index: index,isFromHome: false,
                                      editorials: _courseController
                                          .editorialListing[index],
                                    ));
                              })),
                      // when the _loadMore function is running
                      if (_coursesController.loadMore.value)
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 40),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      // When nothing else to load
                      if (_coursesController.nextPage.value == false)
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          color: Colors.amber,
                          child: Center(
                            child: CommonTextViewWidget(
                                text: 'You have fetched all of the content'),
                          ),
                        ),
                    ],
                  ),
                  _courseController.firstLoading.value
                      ? const Loading()
                      : const SizedBox(),
                  _courseController.editorialListing.isEmpty
                      ? notDataFound()
                      : const SizedBox(),
                ],
              );
            },
          ));
    }
    //Editorial Listing  on see all
  }

  Widget notDataFound() {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonTextViewWidget(
            text: "NO  data found",
            fontSize: 14,
            color: Colors.black,
            align: TextAlign.center),
        InkWell(
            onTap: () {
              _onRefresh();
            },
            child: const Icon(
              Icons.refresh,
              size: 40,
            ))
      ],
    ));
  }
}
