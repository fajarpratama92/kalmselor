import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/color/colors.dart';

void ERROR_SNACK_BAR(String? title, String? message) {
  Get.rawSnackbar(
      message: message,
      title: title,
      snackPosition: SnackPosition.TOP,
      // backgroundColor: Colors.red[300]!,
      backgroundColor: Colors.black.withOpacity(0.5),
      isDismissible: true,
      duration: const Duration(seconds: 5));
}

void SUCCESS_SNACK_BAR(String? title, String? message) {
  Get.rawSnackbar(
      message: message,
      title: title,
      snackPosition: SnackPosition.TOP,
      backgroundColor: GREENKALM,
      isDismissible: true,
      duration: const Duration(seconds: 5));
}

snackBars({
  required String message,
  int? duration,
  bool? isDismissible,
  bool? showProgressIndicator,
}) async {
  Get.rawSnackbar(
    showProgressIndicator: showProgressIndicator ?? false,
    dismissDirection: DismissDirection.horizontal,
    duration: Duration(seconds: duration ?? 4),
    message: message,
    isDismissible: isDismissible ?? true,
    snackPosition: SnackPosition.TOP,
  );
}
