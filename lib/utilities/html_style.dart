import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

Html HTML_VIEW(
  String? data, {
  double? fontSize,
  double? wordSpace,
  Color? textColor,
  FontWeight? fontWeight,
  Map<String, Style>? style,
}) {
  return Html(
    onLinkTap: (l, c, e, r) async {
      if (await canLaunch(l!)) {
        await launch(l);
      } else {
        ERROR_SNACK_BAR("Perhatian", "Tidak dapat membuka link");
        return;
      }
    },
    data: data,
    style: style ??
        HTML_STYLE(
          fontSize: fontSize,
          wordSpace: wordSpace,
          fontWeight: fontWeight,
          textColor: textColor,
        ),
  );
}

Map<String, Style> MY_HTML_STYLE() {
  return {
    "p": Style(fontFamily: "MavenPro"),
    "li": Style(fontFamily: "MavenPro"),
    "span": Style(fontFamily: "MavenPro"),
    "b": Style(fontFamily: "MavenPro"),
    "h1": Style(fontFamily: "MavenPro"),
    "h2": Style(fontFamily: "MavenPro"),
    "h3": Style(fontFamily: "MavenPro"),
    "h4": Style(fontFamily: "MavenPro"),
    "h5": Style(fontFamily: "MavenPro"),
    "h6": Style(fontFamily: "MavenPro"),
  };
}

Map<String, Style> HTML_STYLE({
  TextAlign? textAlign,
  double? fontSize,
  double? wordSpace,
  Color? textColor,
  FontWeight? fontWeight,
}) {
  return {
    "p": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "MavenPro",
        fontSize: FontSize(fontSize ?? 14),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal),
    "li": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "MavenPro",
        fontSize: FontSize(fontSize ?? 14),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal),
    "span": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "MavenPro",
        fontSize: FontSize(fontSize ?? 14),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal),
    "b": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "MavenPro",
        fontSize: FontSize(fontSize ?? 14),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.bold),
    "h1": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "MavenPro",
        fontSize: FontSize(fontSize ?? 30),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.bold),
    "h2": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "MavenPro",
        fontSize: FontSize(fontSize ?? 30),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.bold),
    "h3": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "MavenPro",
        fontSize: FontSize(fontSize ?? 30),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.bold),
    "h4": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "MavenPro",
        fontSize: FontSize(fontSize ?? 20),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.bold),
    "h5": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "MavenPro",
        fontSize: FontSize(fontSize ?? 26),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.bold),
    "h6": Style(
        // width: Get.width,
        wordSpacing: wordSpace ?? 4,
        fontFamily: "MavenPro",
        fontSize: FontSize(fontSize ?? 26),
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.bold),
  };
}
