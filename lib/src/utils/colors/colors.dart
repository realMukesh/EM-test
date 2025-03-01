import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
//to convert hexadecimal string into int
hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff' + hex : hex;
  int val = int.parse(hex, radix: 16);
  return val;
}

final Shader linearGradient = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    gradientBlue,
    gradientLigthblue.withOpacity(0.5),
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Gradient learning1 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xff5041E2),
    Color(0xff48CBCD),
  ],
);
const Gradient learning2 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xffFA4873),
    Color(0xffFBB090),
  ],
);
final Gradient learning3 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xffF7C12A),
    Color(0xffFAD66B),
  ],
);
final Gradient learning4 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xff8043D6),
    Color(0xffF149A0),
  ],
);
final Gradient learning5 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xff0BC58C),
    Color(0xff52DEB4),
  ],
);
final Gradient learning6 = LinearGradient(
  stops: <double>[0.0, 1.0],
  tileMode: TileMode.mirror,
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [
    Color(0xff4B3FF4),
    Color(0xff7C8DF5),
  ],
);
