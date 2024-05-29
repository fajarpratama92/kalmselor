import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../color/colors.dart';

class Avatar extends StatelessWidget {
  String? imgUrl;
  double? nullImgUrlScale;
  double? height;
  double? radius;
  bool isEditImage;
  Function()? onPressed;
  bool uploadLoading;
  String? imgFile;
  String? nullOrErrorImg;
  Color? fillColor;
  Avatar(
    this.imgUrl, {
    this.height,
    this.radius,
    this.isEditImage = false,
    this.onPressed,
    this.uploadLoading = false,
    this.nullOrErrorImg,
    this.fillColor,
    this.imgFile,
    this.nullImgUrlScale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: BLUEKALM),
        height: (radius ?? 100) * 2,
        width: (radius ?? 100) * 2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Builder(
                builder: (context) {
                  switch (uploadLoading) {
                    case true:
                      return CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: radius ?? 100,
                          child: const CupertinoActivityIndicator(radius: 15));
                    case false:
                      if (imgFile != null) {
                        return CircleAvatar(
                          backgroundImage: FileImage(File(imgFile!)),
                          radius: radius ?? 100,
                        );
                      } else {
                        if (imgUrl == null) {
                          return CircleAvatar(
                              backgroundColor: fillColor ?? BLUEKALM,
                              radius: radius ?? 100,
                              child: Builder(
                                builder: (context) {
                                  if (nullOrErrorImg != null) {
                                    return Center(
                                        child: Image.asset(nullOrErrorImg!,
                                            scale: 3, color: Colors.black26));
                                  } else {
                                    return Center(
                                        child: Image.asset(
                                      'assets/others/null-profile.png',
                                      scale: nullImgUrlScale ?? 2,
                                      color: Colors.white,
                                    ));
                                  }
                                },
                              ));
                        } else {
                          return CachedNetworkImage(
                              imageUrl: imgUrl!,
                              placeholder: (b, s) => CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: radius ?? 100,
                                  child: const CupertinoActivityIndicator(
                                      radius: 10)),
                              imageBuilder: (context, imageProvider) {
                                return CircleAvatar(
                                    radius: radius ?? 100,
                                    backgroundImage: imageProvider,
                                    backgroundColor: BLUEKALM);
                              },
                              errorWidget: (context, url, error) {
                                print(error.runtimeType.toString().replaceAll(
                                    "ArgumentError", "img not found"));
                                return CircleAvatar(
                                    backgroundColor: fillColor ?? BLUEKALM,
                                    radius: radius ?? 100,
                                    child: Builder(
                                      builder: (context) {
                                        if (nullOrErrorImg != null) {
                                          return Center(
                                              child: Image.asset(
                                                  nullOrErrorImg!,
                                                  scale: 3,
                                                  color: Colors.black26));
                                        } else {
                                          return Center(
                                              child: Image.asset(
                                            'assets/others/null-profile.png',
                                            scale: 2,
                                            color: Colors.white,
                                          ));
                                        }
                                      },
                                    ));
                              });
                        }
                      }
                    default:
                      return build(context);
                  }
                },
              ),
            ),
            // Builder(builder: (context) {
            //   return Positioned(
            //     right: 0,
            //     top: 20,
            //     child: Container(
            //       decoration: const BoxDecoration(
            //           shape: BoxShape.circle, color: ORANGEKALM),
            //       child: Padding(
            //         padding: const EdgeInsets.all(1.0),
            //         child: IconButton(
            //             icon: const Icon(
            //               Icons.edit,
            //               color: Colors.white,
            //               size: 20,
            //             ),
            //             onPressed: onPressed),
            //       ),
            //     ),
            //   );
            // })
          ],
        ));
  }
}

class Avatar2 extends StatelessWidget {
  final String? imgUrl;
  final String? imgFilePick;
  final String nullImg;
  const Avatar2(
      {Key? key,
      required this.imgUrl,
      required this.imgFilePick,
      required this.nullImg})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (imgFilePick != null) {
        return CircleAvatar(
            radius: 100, backgroundImage: FileImage(File(imgFilePick!)));
      } else if (imgUrl != null) {
        return CachedNetworkImage(
          imageUrl: imgUrl!,
          errorWidget: (context, url, error) => Column(
            children: [
              const Icon(Icons.error),
              SPACE(),
              TEXT("Gambar tidak ditemukan", textAlign: TextAlign.center),
            ],
          ),
          imageBuilder: (context, imgProvider) {
            return CircleAvatar(
              radius: 100,
              backgroundImage: imgProvider,
            );
          },
        );
      } else {
        return CircleAvatar(
          backgroundColor: BLUEKALM,
          radius: 100,
          child: Image.asset(
            nullImg,
            scale: 3,
          ),
        );
      }
    });
  }
}
