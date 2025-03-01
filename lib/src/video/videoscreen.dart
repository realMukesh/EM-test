import 'package:flutter/material.dart';

import '../widgets/common_textview_widget.dart';



class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CommonTextViewWidget(text:"Video Screen"),
      ),
    );
  }
}
