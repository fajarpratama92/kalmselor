import 'package:flutter/material.dart';
import 'package:get/get.dart';

const ORANGEKALM = Color(0xFFC88676);
const YELLOWKALM = Color(0xFFE6B363);
const BLUEKALM = Color(0xFF586B87);
const TEXTBLUEKALM = Color(0xFF586B83);
const GREENKALM = Color(0xFFB0BB90);
const GREYOPACITY = Color(0xFFB0BB90);


const TextStyle font16 = TextStyle(fontSize: 16, fontFamily: "MavenPro");
const TextStyle font14 = TextStyle(fontSize: 14, fontFamily: "MavenPro");
const TextStyle font12 = TextStyle(fontSize: 12, fontFamily: "MavenPro");
const TextStyle font10 = TextStyle(fontSize: 10, fontFamily: "MavenPro");
const TextStyle font8 = TextStyle(fontSize: 8, fontFamily: "MavenPro");

TextStyle? headline6BLUEKALM(
        {double? fontSize, Color? color = BLUEKALM, FontWeight? fontWeight}) =>
    Get.textTheme.headline6?.copyWith(
      color: color,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontSize: fontSize ?? Get.textTheme.headline6!.fontSize,
      fontFamily: "MavenPro",
    );
TextStyle? bodyLargeBOLDBLUEKALM({double? fontSize, Color? color = BLUEKALM}) =>
    Get.textTheme.bodyLarge?.copyWith(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: fontSize ?? Get.textTheme.bodyLarge!.fontSize,
      fontFamily: "MavenPro",
    );
TextStyle? bodyLargeNORMALBLUEKALM(
        {double? fontSize, Color? color = BLUEKALM}) =>
    Get.textTheme.bodyLarge?.copyWith(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: fontSize ?? Get.textTheme.bodyLarge!.fontSize,
      fontFamily: "MavenPro",
    );
// TextStyle? titleApp24 = headline6BLUEKALM(fontSize: 25);
TextStyle? titleApp24BOLD = headline6BLUEKALM(fontSize: 24, fontWeight: FontWeight.w900);
TextStyle? titleApp24 = headline6BLUEKALM(fontSize: 24);
TextStyle? titleApp20 = headline6BLUEKALM(fontSize: 20);
TextStyle? titleApp16 = headline6BLUEKALM(fontSize: 16);
TextStyle? titleApp14 = headline6BLUEKALM(fontSize: 14);

TextStyle? qoutesApp18 =
    bodyLargeBOLDBLUEKALM(fontSize: 18, color: Colors.white);
TextStyle? descriptionAppBOLD18 =
    bodyLargeBOLDBLUEKALM(fontSize: 18, color: Colors.white);
TextStyle? descriptionApp14 =
    bodyLargeBOLDBLUEKALM(fontSize: 14, color: Colors.black);
TextStyle? descriptionApp14Gray =
    bodyLargeBOLDBLUEKALM(fontSize: 14, color: Colors.grey);
