import 'dart:io';

import 'package:english_madhyam/src/screen/editorials_page/controller/editorial_detail_controler.dart';
import 'package:english_madhyam/src/screen/profile/controller/profile_controllers.dart';
import 'package:english_madhyam/src/screen/editorials_page/page/editorials_details.dart';
import 'package:english_madhyam/src/widgets/free_paid_widget.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:english_madhyam/utils/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../utils/colors/colors.dart';
import '../../../widgets/editorial_child_widget.dart';
import '../../payment/page/choose_plan_details.dart';
import '../../payment/page/in_app_plan_page.dart';

class MaterialEditorialListPage extends StatefulWidget {
  final String title;

  const MaterialEditorialListPage({Key? key, required this.title})
      : super(key: key);

  @override
  State<MaterialEditorialListPage> createState() =>
      _MaterialEditorialListPageState();
}

class _MaterialEditorialListPageState extends State<MaterialEditorialListPage> {
  final EditorialDetailController detailController = Get.find();
  final ProfileControllers profileController = Get.find();

  @override
  void initState() {
    super.initState();
    profileController.getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor.withOpacity(0.01),
      body: Obx(() {
        if (detailController.isDataProcessing.value) {
          return _buildLoadingIndicator(context);
        } else if (detailController.editorialByCat.isNotEmpty) {
          return _buildEditorialList();
        } else {
          return _buildEmptyState(context);
        }
      }),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: Lottie.asset(
        "assets/animations/loader.json",
        height: MediaQuery.of(context).size.height * 0.14,
      ),
    );
  }

  Widget _buildEditorialList() {
    return ListView.builder(
      controller: detailController.readingController,
      itemCount: detailController.editorialByCat.length,
      itemBuilder: (context, index) {
        final editorial = detailController.editorialByCat[index];
        if (index == detailController.editorialByCat.length - 1 &&
            detailController.isMoreDataAvailable.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildEditorialCard(editorial, index);
      },
    );
  }

  Widget _buildEditorialCard(dynamic editorial, int index) {
    return InkWell(
      onTap: () => _handleEditorialTap(editorial),
      child: EditorialChildWidget(
        index: index,isFromHome: false,
        editorials: editorial,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/49993-search.json',
        height: MediaQuery.of(context).size.height * 0.2,
      ),
    );
  }

  void _handleEditorialTap(dynamic editorial) {
    if (editorial.type == "PAID") {
      if (profileController.isSubscriptionActive) {
        _navigateToEditorialDetails(editorial);
      } else {
        profileController.getProfileData();
        Get.toNamed(ChoosePlanDetails.routeName);

      }
    } else {
      _navigateToEditorialDetails(editorial);
    }
  }

  void _navigateToEditorialDetails(dynamic editorial) {
    Get.to(() => EditorialsDetailsPage(
          editorial_title: editorial.title,
          editorial_id: editorial.id,
        ));
  }
}
