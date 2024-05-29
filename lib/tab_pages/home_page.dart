import 'dart:async';

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/widget/box_border.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/widget_carousel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final _controller = Get.put(HomeController());

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      initState: (st) async {
        if (PRO.articleHomeResModel == null) {
          await PRO.getHomeArticles();
        }
        if (PRO.quoteResModel == null) {
          await PRO.getQuote();
        }
      },
      builder: (_) {
        return SAFE_AREA(
          context: context,
          canBack: false,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SPACE(height: 10),
                  SizedBox(
                    width: Get.width / 1.5,
                    child: TEXT(
                        "Selamat Datang! \n${PRO.userData?.firstName} ${PRO.userData?.lastName ?? ""}",
                        textAlign: TextAlign.center,
                        style: titleApp20,
                        maxLines: 2,
                        textOverflow: TextOverflow.visible),
                  ),
                  SPACE(height: 15),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Builder(builder: (context) {
                        if (STATE(context).quoteResModel == null) {
                          return AspectRatio(
                              aspectRatio: 16 / 9, child: SHIMMER());
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: BOX_BORDER(
                              AspectRatio(
                                aspectRatio: 16 / 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TEXT(
                                    STATE(context)
                                        .quoteResModel
                                        ?.data
                                        ?.description,
                                    textOverflow: TextOverflow.ellipsis,
                                    maxLines: 8,
                                    style: qoutesApp18,
                                  ),
                                ),
                              ),
                              decorationImage: DecorationImage(
                                image: NetworkImage(
                                  IMAGE_URL +
                                      INSPIRATIONAL_QUOTE +
                                      (STATE(context)
                                          .quoteResModel!
                                          .data!
                                          .image!),
                                ),
                                fit: BoxFit.fill,
                                onError: (_, __) {},
                              ),
                            ),
                          );
                        }
                      })),
                  SPACE(height: 30),
                  TEXT("Newest", style: titleApp24BOLD),
                  SPACE(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ARTICLE_CAROUSEL(
                      context,
                      STATE(context).articleHomeResModel,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeController extends GetxController {
  String? qoute = "";

  setQouteData(BuildContext context) {
    qoute = STATE(context).quoteResModel?.data?.description;
  }

  Timer? timer;
  static bool? quoteTimer = true;

  @override
  void onInit() {
    Timer.periodic(
      const Duration(seconds: 15),
      (Timer t) async {
        await PRO.getQuote();
        if (quoteTimer == false) {
          t.cancel();
        }
      },
    );
    quoteTimer = true;
    super.onInit();
  }

  cancelTimer() {
    quoteTimer = false;
    timer?.cancel();
  }
}
