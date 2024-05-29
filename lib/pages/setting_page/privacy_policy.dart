import 'package:counselor/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/utilities/html_style.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final _controller = Get.put(PrivacyPolicyController());

  PrivacyPolicyPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyPolicyController>(builder: (_) {
      return SAFE_AREA(
          bottomPadding: PRO.userData?.status == 1 ? null : 0,
          context: context,
          canBack: true,
          useNotification: PRO.userData?.status == 1 ? true : false,
          useLogo: PRO.userData?.status == 1 ? true : false,
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SPACE(),
                  TEXT(
                      PRO.privacyPolicyResModel?.howToData?.name?.toUpperCase(),
                      style: titleApp24),
                  SPACE(),
                  HTML_VIEW(
                    PRO.privacyPolicyResModel?.howToData?.description,
                  )
                ],
              ),
            )
          ]));
    });
  }
}

class PrivacyPolicyController extends GetxController {}
