import 'package:english_madhyam/src/widgets/regularTextViewDarkMode.dart';
import 'package:english_madhyam/utils/size_utils.dart';



import 'package:flutter/material.dart';

import 'common_textview_widget.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CommonTextViewWidget(text:"OR Continue With",
              color: Colors.black,fontSize: 14.fSize,
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }
}
