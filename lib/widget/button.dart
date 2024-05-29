import 'package:flutter/material.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/widget/text.dart';
import 'package:get/get.dart';

Widget BUTTON(
  String title, {
  void Function()? onPressed,
  Widget? suffixIcon,
  Widget? prefixIcon,
  double? circularRadius,
  Color? disableColor,
  Color? backgroundColor,
  bool isExpanded = false,
  double? verticalPad,
  double? expandedHorizontalPad,
  MainAxisAlignment? titleMainAxisAlignment,
  TextStyle? style,
}) {
  if (isExpanded) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: expandedHorizontalPad ?? 0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius:
                      BorderRadius.all(Radius.circular(circularRadius ?? 10))),
              backgroundColor: onPressed == null
                  ? disableColor ?? Colors.grey
                  : backgroundColor ?? ORANGEKALM),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPad ?? 0),
              child: Builder(builder: (context) {
                if (suffixIcon == null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TEXT(title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TEXT("content"),
                      TEXT(title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      suffixIcon,
                    ],
                  );
                }
              })),
        ),
      ),
    );
  } else {
    return ElevatedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius:
                  BorderRadius.all(Radius.circular(circularRadius ?? 10))),
          backgroundColor: onPressed == null
              ? disableColor ?? Colors.grey
              : backgroundColor ?? ORANGEKALM),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPad ?? 0),
        child: Builder(builder: (context) {
          if (suffixIcon != null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // SPACE(),
                TEXT(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                suffixIcon,
              ],
            );
          } else if (prefixIcon != null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                prefixIcon,
                TEXT(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment:
                  titleMainAxisAlignment ?? MainAxisAlignment.center,
              children: [
                TEXT(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

InkWell OUTLINE_BUTTON(
  String title, {
  void Function()? onPressed,
  Widget? suffixIcon,
  double? circularRadius,
  Color? disableColor,
  Color? backgroundColor,
  double? verticalPad,
  Color? textColor,
  bool useExpanded = true,
  TextStyle? customTextStyle,
}) {
  return InkWell(
    onTap: onPressed,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPad ?? 0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(circularRadius ?? 5),
            border: Border.all(width: 0.5, color: BLUEKALM),
            color: backgroundColor ?? Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (useExpanded)
              Expanded(
                  child: TEXT(title,
                      style: customTextStyle ??
                          TextStyle(
                            fontSize: 12,
                            color: textColor ?? BLUEKALM,
                            fontFamily: "MavenPro",
                          ),
                      textAlign: TextAlign.center))
            else
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TEXT(title,
                    style: customTextStyle ??
                        TextStyle(
                          fontSize: 12,
                          color: textColor ?? BLUEKALM,
                          fontFamily: "MavenPro",
                        ),
                    textAlign: TextAlign.center),
              ),
            if (suffixIcon != null) suffixIcon,
          ],
        ),
      ),
    ),
  );
}
