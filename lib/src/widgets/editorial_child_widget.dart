import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/ui_helper.dart';
import '../utils/colors/colors.dart';
import 'common_textview_widget.dart';
import 'free_paid_widget.dart';

class EditorialChildWidget extends StatelessWidget {
  var index;
  dynamic editorials;
  bool isFromHome;
  EditorialChildWidget(
      {super.key, required this.index, required this.editorials,required this.isFromHome});

  List<Gradient> color = [
    learning1,
    learning2,
    learning3,
    learning4,
    learning5,
    learning6
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: 7.adaptSize, horizontal: 15.adaptSize),
      padding: EdgeInsets.symmetric(vertical: 6.adaptSize),
      decoration: isFromHome?BoxDecoration(
        gradient: color[index % 6],
        boxShadow: [
          BoxShadow(
              color: greyColor.withOpacity(0.4),
              blurRadius: 2,
              spreadRadius: 1,
              offset: const Offset(1, 2)),
        ],
        borderRadius: BorderRadius.circular(18),
      ):UiHelper.commonDecoration(index: index,context: context),

      child: ListTile(
        leading: Container(
          height: 70.adaptSize,
          width: 70.adaptSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: whiteColor,
            image: DecorationImage(
              fit: editorials.image == null ? BoxFit.contain : BoxFit.cover,
              image: NetworkImage(
                  editorials.image ?? "https://via.placeholder.com/150"),
            ),
          ),
        ),
        title: CommonTextViewWidgetDarkMode(
            text: editorials.title,
            fontSize: 16,maxLine: 2,
            fontWeight: FontWeight.w600,
            color: isFromHome?white:colorSecondary),
        subtitle: Column(
          children: [
            Row(
              children: [
                 Icon(
                  Icons.access_time_outlined,
                  color: isFromHome?white:colorSecondary,
                  size: 16,
                ),
                CommonTextViewWidgetDarkMode(
                    text:" ${UiHelper.getDataTimeFormat(
                        date: editorials.date.toString()
                    )}",
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: isFromHome?white:grayColorLight),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                     Icon(
                      Icons.person_outline,
                      color: isFromHome?white:colorSecondary,
                      size: 16,
                    ),
                    CommonTextViewWidgetDarkMode(
                        text: editorials.author!.length > 10
                            ? editorials.author!.substring(0, 9) + ".."
                            : editorials.author!.toString(),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isFromHome?white:colorSecondary),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                FreePaidWidget(type: editorials.type == "PAID" ? 1 : 0)
              ],
            )
          ],
        ),
      ),
    );
  }
}
