import 'package:english_madhyam/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'common_textview_widget.dart';

class ShowLoadingPage extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  const ShowLoadingPage({Key? key,required this.refreshIndicatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              'assets/img/logo_round.png',
              width: 20,
            ),
          ),
           CommonTextViewWidget(
              text: "No data found",
              fontSize: 14,
              color: colorPrimary,
              align: TextAlign.center),
          InkWell(
              onTap: () {
                refreshIndicatorKey.currentState?.show();
              },
              child: const Icon(
                Icons.refresh,
                size: 40,
              ))
        ],
      ),
    );
  }
}
