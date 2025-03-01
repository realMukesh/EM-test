import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/common_textview_widget.dart';

class NoNetwork extends StatefulWidget {
  const NoNetwork({Key? key}) : super(key: key);

  @override
  State<NoNetwork> createState() => _NoNetworkState();
}

class _NoNetworkState extends State<NoNetwork> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: Lottie.asset("assets/animations/no-internet.json"),
        ),
        Center(
          child: Column(
            children: [
              CommonTextViewWidget(text: "No Network Connection",fontWeight: FontWeight.w600,fontSize: 18,),
              OutlinedButton(onPressed: (){}, child: CommonTextViewWidget(text: "Retry",))
            ],
          ),
        )
      ],
    );
  }
}
