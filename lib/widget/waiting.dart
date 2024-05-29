import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/widget/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomWaiting {
  defaut() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Center(
        child: Container(
          height: 80,
          width: 80,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const LoadingIndicator(
                indicatorType: Indicator.circleStrokeSpin,
                color: BLUEKALM,
              ),
              Image.asset(APP_ICON, scale: 8)
            ],
          ),
        ),
      ),
    );
  }
}
