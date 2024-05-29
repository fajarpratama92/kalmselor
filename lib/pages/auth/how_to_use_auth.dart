import 'dart:ui';

import 'package:counselor/api/api.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/pages/auth/sop_confirm.dart';
import 'package:counselor/pages/auth/upload_mandatory.dart';
import 'package:counselor/pages/counselor/upload_mandatory_2.dart';
import 'package:counselor/utilities/html_style.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HowToUseAuthPage extends StatelessWidget {
  final _controller = Get.put(HowToUseAuthController());

  HowToUseAuthPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SAFE_AREA(
      bottomPadding: PRO.userData?.status == 1 ? null : 0,
      context: context,
      canBack: true,
      useNotification: PRO.userData?.status == 1 ? true : false,
      child: GetBuilder<HowToUseAuthController>(
        builder: (_) {
          return Builder(
            builder: (context) {
              if (_.description != null) {
                return SingleChildScrollView(
                  child: SizedBox(
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          TEXT(_.title,
                              style: COSTUM_TEXT_STYLE(
                                  fonstSize: 30, fontWeight: FontWeight.w900)),
                          HTML_VIEW(_.description),
                          SizedBox(
                            width: Get.width / 1.5,
                            child: Column(
                              children: [
                                BUTTON(
                                  "Buka KARS",
                                  onPressed: () async => await _.openKars(),
                                ),
                                if (PRO.tabController.index != 3)
                                  BUTTON(
                                    "Selanjutnya",
                                    onPressed: () async {
                                      // Get.to(SopConfirmPage());
                                      await pushNewScreen(
                                        context,
                                        screen: SopConfirmPage(),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                          SPACE(),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CustomWaiting().defaut(),
                    // Loading().LOADING_ICON(context),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class HowToUseAuthController extends GetxController {
  String? description;
  String? title;
  Future<void> getTutorial() async {
    var _res = await Api().GET(HOW_TO, useLoading: false);
    // (as Map<String, dynamic>).removeWhere((key, value) => key == 'description');
    // PR(_res?.data);
    if (_res?.statusCode == 200) {
      title = _res?.data['data']['name'];
      description = _res?.data['data']['description'];
      update();
    } else {
      return;
    }
  }

  Future<void> openKars() async {
    if (await canLaunch(KARS)) {
      await launch(KARS);
    } else {
      ERROR_SNACK_BAR("Perhatian", "Tidak dapat membuka link");
      return;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getTutorial();
  }
}
