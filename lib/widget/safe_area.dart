// import 'dart:js';

import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';

SafeArea SAFE_AREA({
  Widget? child,
  bool canBack = true,
  bool useAppBar = true,
  double? bottomPadding,
  bool? useNotification = true,
  bool? useLogo = true,
  Future<void> Function()? onBackPressed,
  required BuildContext context,
}) {
  return SafeArea(
    top: false,
    bottom: false,
    child: Scaffold(
      appBar: !useAppBar
          ? null
          : AppBar(
              toolbarHeight: 50,
              centerTitle: true,
              elevation: 0.0,
              leading: canBack
                  ? IconButton(
                      onPressed: onBackPressed != null
                          ? () async => await onBackPressed()
                          : () async => await Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: BLUEKALM,
                        size: 20,
                      ))
                  : null,
              backgroundColor: Colors.white,
              title: useLogo != null && useLogo == true
                  ? Image.asset("assets/icon/counselor.png", scale: 6)
                  : null,
              shadowColor: Colors.transparent,
              actions: [
                useNotification == true
                    ? Builder(
                        builder: (context) {
                          return IconButton(
                              onPressed: () {
                                pushNewScreen(context,
                                    screen: SAFE_AREA(
                                        context: context,
                                        child: SizedBox(
                                          width: Get.width,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TEXT("Belum ada notifikasi"),
                                            ],
                                          ),
                                        )));
                              },
                              icon: Image.asset("assets/icon/bell.png",
                                  scale: 3.5));
                        },
                      )
                    : Container(),
              ],
            ),
      body: Builder(
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: STATE(context).keyboardVisibility
                    ? 0
                    : bottomPadding ?? 75),
            child: child,
          );
        },
      ),
    ),
    // minimum: EdgeInsets.only(bottom: 10),
  );
}

SafeArea NON_MAIN_SAFE_AREA({
  Widget? child,
  bool resizeBottomInset = true,
  PreferredSizeWidget? appBar,
  bool? top,
  bool? bottom,
  double? bottomPadding,
}) {
  return SafeArea(
    top: top ?? false,
    bottom: bottom ?? false,
    child: Scaffold(
      appBar: appBar,
      body: Builder(
        builder: (context) {
          try {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: STATE(context).keyboardVisibility
                      ? 0
                      : (bottomPadding ?? 38)),
              child: child!,
            );
          } catch (e) {
            return Container();
          }
        },
      ),
      resizeToAvoidBottomInset: resizeBottomInset,
    ),
  );
}
