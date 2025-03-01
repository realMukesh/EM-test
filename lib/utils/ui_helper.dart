import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:english_madhyam/utils/app_colors.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../src/screen/pages/page/setup.dart';
import '../src/widgets/common_textview_widget.dart';

class UiHelper {

  static List<String> backgroundColors= [
    "#DBDDFF",
    "#FFECE7",
    "#EDF6FF",
    "#EBFFE5",
    "#F6F4FF",
    "#EBFFE5",
  ];

  static bool isNumber(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  static Widget viewActionButton(String buttonName) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
    ),
      elevation: 3,
      child: Container(
        width: 80.adaptSize,
        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 6),
        decoration:  BoxDecoration(
          color: buttonName=="Start"?colorPrimary:Colors.green,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: CommonTextViewWidgetDarkMode(
          text: buttonName.replaceAll("View", ""),
          color: white,align: TextAlign.center,
        ),
      ),
    );
  }

  static BoxDecoration gridCommonDecoration(
      {required int index, required BuildContext context}) {
    return BoxDecoration(
      color: AdaptiveTheme.of(context).mode.isDark
          ? Colors.transparent
          : Color(hexStringToHexInt(
              backgroundColors[index % backgroundColors.length])),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: greyColor.withOpacity(0.4),
          blurRadius: 2,
          spreadRadius: 1,
          offset: const Offset(1, 2),
        ),
      ],
    );
  }

  static BoxDecoration commonDecoration(
      {required int index, required BuildContext context}) {
    return BoxDecoration(
      color: AdaptiveTheme.of(context).mode.isDark
          ? Colors.black
          : Color(hexStringToHexInt(
              backgroundColors[index % backgroundColors.length])),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: greyColor.withOpacity(0.4),
          blurRadius: 2,
          spreadRadius: 1,
          offset: const Offset(1, 2),
        ),
      ],
    );
  }

  static BoxDecoration pdfDecoration(BuildContext context, index) {
    return BoxDecoration(
      color: AdaptiveTheme.of(context).mode.isDark
          ? Colors.black
          : Color(hexStringToHexInt(
              backgroundColors[index % backgroundColors.length])),
      borderRadius: BorderRadius.circular(15),
    );
  }

  static Future<bool> showConfirmDialog({title, content}) async {
    var result = await Get.dialog(AlertDialog(
      title: CommonTextViewWidget(
        text: title,
        color: colorPrimary,
        align: TextAlign.start,
        fontSize: 16,
      ),
      content: CommonTextViewWidget(text: content),
      actions: [
        TextButton(
          child: CommonTextViewWidget(
            text: "OK",
            color: colorPrimary,
          ),
          onPressed: () => Get.back(result: true),
        ),
      ],
    ));
    return result;
  }

  static bool isEmail(String string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
      return true;
    }
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  static showDialog() {
    Get.dialog(CupertinoAlertDialog(
      title: CommonTextViewWidget(text: 'English Madhyam'),
      content: CommonTextViewWidget(
          text: 'Please manage your account setting from website'),
      actions: [
        TextButton(
          child: CommonTextViewWidget(text: "OK"),
          onPressed: () => Get.back(),
        ),
      ],
    ));
  }

  static showINfoDialog(dynamic content) {
    Get.dialog(CupertinoAlertDialog(
      title: const Text('English Madhyam'),
      content: Html(
        data: content ?? "",
        style: {
          "p": Style(
              fontSize: FontSize(14.0),
              textAlign: TextAlign.justify,
              maxLines: 4)
        },
      ),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () => Get.back(),
        ),
      ],
    ));
  }

  static Future<bool> showInfoDialog() async {
    String title = "New Update Available";
    String message =
        "There is a newer version of app available please update it now.";
    String btnLabel = "Update Now";
    String btnLabelCancel = "Later";

    var result = await Get.dialog(AlertDialog(
      title: CommonTextViewWidget(
        text: title,
        color: colorPrimary,
        align: TextAlign.start,
        fontSize: 16,
      ),
      content: Text(message),
      actions: [
        OutlinedButton(
          child: Text(btnLabel),
          onPressed: () {
            Get.back(result: true);
          },
        ),
        OutlinedButton(
          child: Text(btnLabelCancel),
          onPressed: () {
            Get.back(result: false);
          },
        ),
      ],
    ));
    return result;
  }

  static Future<bool> showAlertDialog({title, message, yes, no}) async {
    var response = await Get.dialog(AlertDialog(
      title: CommonTextViewWidget(
        text: "",
        fontSize: 28,
      ),
      content: CommonTextViewWidget(
        text: message,
      ),
      actions: [
        TextButton(
          child: CommonTextViewWidget(
            text: no,
          ),
          onPressed: () {
            Get.back(result: false);
          },
        ),
        TextButton(
          child: CommonTextViewWidget(
            text: yes,
          ),
          onPressed: () {
            Get.back(result: true);
          },
        ),
      ],
    ));
    return response;
  }

  static void showFailureMsg(BuildContext? context, String message) {
    Get.snackbar(
      "Alert",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void showSuccessMsg(BuildContext? context, String message) {
    Get.snackbar(
      "Alert",
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
    ));*/
  }

  static String getFormattedChatDate({date}) {
    print(date);
    if (date.isEmpty) {
      return "";
    }
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date, true);
    var outputFormat = DateFormat("dd-MMM-yyyy");
    //var outputFormat = DateFormat('dd MMM, yyyy');
    var outputDate = outputFormat.format(parseDate);
    //print("selected timezone-:$outputDate");
    return outputDate;
  }

  static String getDataTimeFormat({date}) {
    String formattedDate="";
    print(date);
    if (date.isEmpty) {
      return "";
    }
   try{
     if(date.toString().contains("am")){
       DateTime parseDate = DateFormat("dd-MMM-yyyy HH:mm").parse(date);
       formattedDate = DateFormat("d MMM, yyyy | hh:mm a").format(parseDate);
     }
     else{
       DateTime parseDate = DateFormat("dd-MMM-yyyy").parse(date);
      // DateTime parseDate = DateTime.parse(date);
       formattedDate = DateFormat("d MMM, yyyy | hh:mm a").format(parseDate);
     }
   }
    catch(e){
      print(e.toString());
      formattedDate=date;
    }
    return formattedDate;
  }
  static Widget getLoadingImage({imageUrl}) {
    return imageUrl == null || imageUrl.toString().isEmpty
        ? const SizedBox()
        : Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          );
  }

  static bool isValidPhoneNumber(String string) {
    // Null or empty string is invalid phone number
    if (string == null || string.isEmpty || string.length < 7) {
      return false;
    }

    // You may need to change this pattern to fit your requirement.
    // I just copied the pattern from here: https://regexr.com/3c53v
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }

  static bool isValidName(String string) {
    // Null or empty string is invalid phone number
    if (string == null || string.isEmpty || string.length < 2) {
      return false;
    }
    return true;
  }

  static bool isValidPasswords(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static bool isValidPassword(String string) {
    // Null or empty string is invalid phone number
    if (string == null || string.isEmpty || string.length < 8) {
      return false;
    }
    // You may need to change this pattern to fit your requirement.
    // I just copied the pattern from here: https://regexr.com/3c53v

    return true;
  }

  static void showSnakbarMsg(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: CommonTextViewWidget(
        text: message,
        color: white,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    ));
  }

  static void showSnakbarSucess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: CommonTextViewWidget(
        text: message,
        color: white,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
    ));
  }



  static String formatedAmount(dynamic amount) {
    return double.parse(amount.toString()).toStringAsFixed(1).toString();
  }

  static bool isMobileValid(String phone) {
    if (phone.isEmpty || phone == null) {
      return false;
    } else if (!isValidPhoneNumber(phone)) {
      return false;
    } else {
      return true;
    }
  }
}
