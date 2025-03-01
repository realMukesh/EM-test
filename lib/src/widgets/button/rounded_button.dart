import 'package:english_madhyam/src/widgets/common_textview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import '../../../utils/app_colors.dart';

class CommonMaterialButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color, textColor;
  final double textSize;
  final double height;
  final double radius;
  final bool showIcon;
  final FontWeight weight;
  final String? svgIcon;
  final double? iconHeight;

  const CommonMaterialButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color = colorSecondary,
      this.textColor = Colors.white,
      this.textSize = 20,
      this.showIcon = false,
      this.height = 55,
      this.radius = 10,
      this.svgIcon,
      this.iconHeight,
      this.weight = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, svgIcon != null ? 0 : 10),
      width: size.width,
      height: height,
      child: MaterialButton(
          elevation: 0,
          animationDuration: const Duration(seconds: 1),
          color: color,
          hoverColor: colorSecondary,
          splashColor: colorSecondary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            Future.delayed(Duration.zero, () async {
              onPressed();
            });
          },
          child: svgIcon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      svgIcon.toString(),
                      height: iconHeight ?? 12.adaptSize,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    CommonTextViewWidget(
                      text: text,
                      color: textColor,
                      fontSize: textSize,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                )
              : CommonTextViewWidget(
                  text: text,
                  color: textColor,
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                )),
    );
  }
}



