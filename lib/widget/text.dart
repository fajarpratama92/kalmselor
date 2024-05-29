import 'package:counselor/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Text TEXT(
  String? content, {
  TextStyle? style,
  TextAlign? textAlign,
  TextOverflow? textOverflow,
  int? maxLines,
}) {
  return Text(
    content ?? "not found",
    style: style ?? Get.textTheme.bodyText1,
    textAlign: textAlign ?? TextAlign.start,
    overflow: textOverflow,
    maxLines: maxLines,
  );
}

TextStyle URL_STYLE() {
  return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: TEXTBLUEKALM,
      fontFamily: "MavenPro",
      overflow: TextOverflow.visible);
}

TextStyle COSTUM_TEXT_STYLE({
  Color? color,
  FontWeight? fontWeight,
  double? fonstSize,
  FontStyle? fontStyle,
  Color? backColor,
  TextDecoration? decoration,
}) {
  return TextStyle(
    decoration: decoration,
    backgroundColor: backColor,
    fontSize: fonstSize ?? 16,
    fontStyle: fontStyle,
    fontWeight: fontWeight ?? FontWeight.normal,
    color: color ?? BLUEKALM,
    fontFamily: "MavenPro",
  );
}
