import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/pages/counselor/counselor_questioner_introduction_page.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage extends StatelessWidget {
  final _controller = Get.put(IntroController());

  IntroPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroController>(builder: (_) {
      return SAFE_AREA(
          context: context,
          bottomPadding: 0,
          useAppBar: false,
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    TEXT('Untuk Menjadi Kalmselor,'),
                    TEXT("Anda Butuh...", style: titleApp20),
                    SPACE(),
                    Column(
                      children: List.generate(_.assetsImage.length, (i) {
                        return Column(
                          children: [
                            SPACE(height: 15),
                            Image.asset(_.assetsImage[i], scale: 3),
                            SPACE(height: 15),
                            TEXT(_.description[i], textAlign: TextAlign.center),
                          ],
                        );
                      }),
                    ),
                    SPACE(height: 20),
                    SizedBox(
                        width: Get.width / 1.5,
                        child: BUTTON("Selanjutnya", onPressed: () async {
                          await PRO.getWelcomeQuestioner();
                          Loading.hide();
                          // Get.to(QuestionerWelcomePage());
                          pushNewScreen(context,
                              screen: CounselorQustionerIntroductionPage(
                                  isFromWelcome: true));
                        }, circularRadius: 20))
                  ],
                ),
              )
            ],
          ));
    });
  }
}

class IntroController extends GetxController {
  final List<String> assetsImage = [
    'assets/flash/flash1.png',
    'assets/flash/flash2.png',
    'assets/flash/flash3.png'
  ];
  final List<String> description = [
    'Fasih dalam salah satu Bahasa Indonesia, Inggris, atau keduanya.',
    'Memiliki minimal S2 baik dalam Psikologi, Konseling, Psikiater, atau gelar Profesi Psikolog.',
    'Memiliki minimal 200 jam pengalaman konseling tatap muka dengn klien.'
  ];
}
