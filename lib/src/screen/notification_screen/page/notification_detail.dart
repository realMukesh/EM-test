import 'package:english_madhyam/src/screen/Notification_screen/model/NotificationModel.dart';
import 'package:english_madhyam/src/screen/Notification_screen/controller/notification_controller.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
class NotificationDetail extends StatefulWidget {
  final Notifications notification;
  const NotificationDetail({Key? key,required this.notification}) : super(key: key);

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themePurpleColor,
        leading: const BackButton(),
        title: CommonTextViewWidget(text:
          widget.notification.title!,
            fontSize: 18
        ),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: NetworkImage(widget.notification.image!),fit: BoxFit.cover)
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CommonTextViewWidget(text:widget.notification.text! ,align: TextAlign.justify,fontSize: 17),
            ],

          ),
        ),
      ),
    );
  }
}
