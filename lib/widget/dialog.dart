import 'dart:io';

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/widget/button/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:image_picker/image_picker.dart';

WillPopScope POP_SCREEN_DIALOG({
  required Widget child,
  String? content,
  void Function()? onConfirm,
}) {
  return WillPopScope(
    child: child,
    onWillPop: () async {
      if (onConfirm == null) {
        return true;
      } else {
        await SHOW_DIALOG(content, onAcc: onConfirm);
      }
      return false;
    },
  );
}

Future SHOW_DIALOG(
  String? content, {
  Function()? onAcc,
  Function()? reject,
  Widget? customButton,
  bool barrierDismissible = true,
}) async {
  await Get.dialog(
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: Get.width / 1.5,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TEXT(content,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            textOverflow: TextOverflow.visible),
                        SPACE(height: 20),
                        if (customButton != null)
                          customButton
                        else
                          Row(
                            mainAxisAlignment: !barrierDismissible
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              IconButton(
                                  icon: Image.asset(
                                    'assets/icon/accept.png',
                                  ),
                                  onPressed: onAcc),
                              !barrierDismissible
                                  ? Container()
                                  : IconButton(
                                      icon: Image.asset(
                                        'assets/icon/decline.png',
                                      ),
                                      onPressed: reject ?? () => Get.back(),
                                    ),
                            ],
                          ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
      barrierDismissible: barrierDismissible);
}

dialogCustom({
  String? title,
  String? desc,
  required String buttonTitle,
  required Function() onPress,
  Widget? customButton,
  Widget? customWidget,
  Widget? customBottomWidget,
  bool barrierDismissible = true,
  double? width,
  double? radiusButtonCircular,
  double? buttonPadHorizontal,
  required BuildContext context,
}) {
  return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!(desc == null))
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: "${title ?? ""}\n",
                        style: const TextStyle(
                            fontSize: 30,
                            color: BLUEKALM,
                            fontWeight: FontWeight.w900)),
                    TextSpan(text: desc),
                  ]),
                  textAlign: TextAlign.center,
                ),
              Builder(builder: (context) {
                if (customWidget != null) {
                  return customWidget;
                } else {
                  return Container();
                }
              }),
              const SizedBox(height: 20),
              Builder(builder: (context) {
                switch (customButton != null) {
                  case true:
                    return customButton!;
                  case false:
                    return CustomButton(
                      heigth: 40,
                      radiusCircular: radiusButtonCircular,
                      titleStyle: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      padHorizontal: buttonPadHorizontal ?? 10,
                      radius: 10,
                      title: buttonTitle,
                      onPressed: onPress,
                    );
                  default:
                    return Container();
                }
              }),
              Builder(builder: (context) {
                if (customBottomWidget != null) {
                  return customBottomWidget;
                } else {
                  return Container();
                }
              }),
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      });
}

Future<List?>? uploadImageDialog({
  required String buttonTitle,
  required BuildContext context,
  Widget? customButton,
  bool customBottomWidget = false,
  String? imgPath,
  String? imgUrl,
  bool barrierDismissible = true,
  bool isReview = false,
  bool isReject = false,
  bool isOptionalFile = false,
  void Function()? onConfirm,
  required ImageSource imageSource,
}) async {
  String? _imgPath = imgPath;
  TextEditingController _nameController = TextEditingController();
  bool _save = false;
  await showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: SizedBox(
              height: Get.size.height / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 4 / 2,
                      child: Builder(builder: (context) {
                        if (_imgPath != null || imgPath != null) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(_imgPath ?? imgPath!),
                                fit: BoxFit.cover,
                              ));
                        } else if (imgUrl != null) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                COUNSELOR_IMAGE_URL + imgUrl,
                                fit: BoxFit.cover,
                              ));
                        } else {
                          return Container();
                        }
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Builder(builder: (context) {
                    switch (customButton != null) {
                      case true:
                        return customButton!;
                      case false:
                        if (_imgPath != null) {
                          return Column(
                            children: [
                              if (isOptionalFile)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CupertinoTextField(
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      controller: _nameController,
                                      placeholder: "Nama Opsional*",
                                      maxLength: 15,
                                      clearButtonMode:
                                          OverlayVisibilityMode.always,
                                    ),
                                    const Text(
                                      "wajib diisi*",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              SPACE(),
                              CustomButton(
                                  // titleStyle: TEXTSTYLE(
                                  //     fontWeight: FontWeight.bold,
                                  //     colors: Colors.white),
                                  padHorizontal: 10,
                                  radius: 10,
                                  title: buttonTitle,
                                  onPressed: () {
                                    if ((_nameController.text == "" ||
                                            _nameController.text == null) &&
                                        isOptionalFile) {
                                      return;
                                    }
                                    _save = true;
                                    Get.back();
                                  }),
                            ],
                          );
                        }
                        if (isReview && !isReject) {
                          return Container();
                        } else if (isReject) {
                          return Container();
                        }
                        return Container();
                      default:
                        return Container();
                    }
                  }),
                  Builder(builder: (context) {
                    if (customBottomWidget) {
                      return TextButton(
                          onPressed: () async {
                            final _picker = ImagePicker();
                            var _path =
                                await _picker.pickImage(source: imageSource,imageQuality: 80);
                            if (_path != null) {
                              setState(() {
                                _imgPath = _path.path;
                              });
                            } else {
                              return;
                            }
                          },
                          child: const Text(
                            "Ulangi Pengambilan Foto",
                            // style: TEXTSTYLE(
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 18,
                            //     colors: ORANGEKALM),
                          ));
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          );
        });
      });
  if (!_save) {
    return null;
  }
  return [File(_imgPath!), _nameController.text];
}

dialogAcc(
    {
    // required BuildContext context,
    required String desc,
    String? title,
    Function()? accPress,
    Function()? rejectPress,
    TextStyle? descStyle,
    bool barrierDismissible = true,
    required BuildContext context}) {
  return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? "",
                // style: TEXTSTYLE(
                //     fontSize: 30,
                //     colors: BLUEKALM,
                //     fontWeight: FontWeight.w900),
              ),
              Text(
                desc,
                textAlign: TextAlign.center,
                // style: descStyle ?? TEXTSTYLE(),
                style: descStyle ?? const TextStyle(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: Image.asset(
                        'assets/others/accept.png',
                      ),
                      onPressed: accPress),
                  IconButton(
                    icon: Image.asset(
                      'assets/others/decline.png',
                    ),
                    onPressed: rejectPress ??
                        () {
                          Get.back();
                        },
                  ),
                ],
              )
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      });
}

dialog({
  String? title,
  String? desc,
  required String buttonTitle,
  required Function() onPress,
  Widget? customButton,
  Widget? customWidget,
  Widget? customBottomWidget,
  bool barrierDismissible = true,
  double? width,
  double? radiusButtonCircular,
  double? buttonPadHorizontal,
  required BuildContext context,
}) {
  return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!(desc == null))
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: "${title ?? ""}\n",
                      // style: TEXTSTYLE(
                      //     fontSize: 30,
                      //     colors: BLUEKALM,
                      //     fontWeight: FontWeight.w900),
                    ),
                    TextSpan(
                      text: desc,
                      // style: TEXTSTYLE(),
                    ),
                  ]),
                  textAlign: TextAlign.center,
                ),
              Builder(builder: (context) {
                if (customWidget != null) {
                  return customWidget;
                } else {
                  return Container();
                }
              }),
              const SizedBox(height: 20),
              Builder(builder: (context) {
                switch (customButton != null) {
                  case true:
                    return customButton!;
                  case false:
                    return CustomButton(
                      heigth: 40,
                      radiusCircular: radiusButtonCircular,
                      // titleStyle: TEXTSTYLE(fontWeight: FontWeight.bold, colors: Colors.white),
                      padHorizontal: buttonPadHorizontal ?? 10,
                      radius: 10,
                      title: buttonTitle,
                      onPressed: onPress,
                    );
                  default:
                    return Container();
                }
              }),
              Builder(builder: (context) {
                if (customBottomWidget != null) {
                  return customBottomWidget;
                } else {
                  return Container();
                }
              }),
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      });
}
