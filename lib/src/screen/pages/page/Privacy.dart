import 'package:english_madhyam/src/screen/pages/controller/cms_controller.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../custom/toolbarTitle.dart';
import '../../../widgets/common_textview_widget.dart';

class PrivacyPo extends StatefulWidget {
  const PrivacyPo({Key? key}) : super(key: key);

  @override
  _PrivacyPoState createState() => _PrivacyPoState();
}

class _PrivacyPoState extends State<PrivacyPo> {
  final CMSSController _cmsController = Get.put(CMSSController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const ToolbarTitle(title: "Privacy Policy"),
      ),
      body: Obx(() {
        if (_cmsController.loading == true) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Center(
              child: Lottie.asset(
                "assets/animations/loader.json",
                height: MediaQuery.of(context).size.height * 0.14,
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: _cmsController.cmsData.value.cmsPages!=null?Html(
                data:
                    _cmsController.cmsData.value.cmsPages?.cmsPages?.privacy ??
                        "",
              ):Center(child: CommonTextViewWidget(text:"No Data Found")),
            ),
          );
        }
      }),
    );
  }
}
