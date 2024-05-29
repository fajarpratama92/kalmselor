import 'package:flutter/material.dart';
import 'package:counselor/color/colors.dart';
import 'package:get/get.dart';

Container BOX_BORDER(
  Widget child, {
  double? circularRadius,
  Color? fillColor,
  DecorationImage? decorationImage,
  double? height,
  double? width,
  Key? key,
}) {
  return Container(
    key: key,
    width: width ?? Get.width,
    height: height,
    // color: Colors.white,
    decoration: BoxDecoration(
        image: decorationImage,
        color: fillColor ?? Colors.white,
        // border: Border.all(width: 0.1, color: BLUEKALM),
        borderRadius: BorderRadius.circular(circularRadius ?? 10)),
    child: child,
  );
}
