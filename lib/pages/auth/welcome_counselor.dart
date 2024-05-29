import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/pages/auth/how_to_use_auth.dart';
import 'package:counselor/pages/auth/login.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/dialog.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeCounselorPage extends StatelessWidget {
  final _controller = Get.put(WelcomeCounselorController());

  WelcomeCounselorPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return POP_SCREEN_DIALOG(
      content: "Apakah Anda yakin ingin keluar dari halaman ini?",
      onConfirm: () async {
        await PRO.removeTempCode();
        await Get.offAll(() => LoginPage());
      },
      child: SAFE_AREA(
        context: context,
        useNotification: false,
        child: GetBuilder<WelcomeCounselorController>(
          builder: (_) {
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Selamat Datang\nKalmselor!".toUpperCase(),
                        style: COSTUM_TEXT_STYLE(
                            fonstSize: 25, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                      SPACE(height: 20),
                      GridView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, mainAxisExtent: 130),
                        children: List.generate(4, (i) {
                          return Image.asset(
                              'assets/image/kalm_illustration_00$i.png');
                        }),
                      ),
                      SPACE(height: 20),
                      TEXT(
                          "Kami sangat senang Anda dapat bergabung dengan kami.",
                          textAlign: TextAlign.center),
                      TEXT("Semoga platform KALM dapat memberikan keuntungan",
                          textAlign: TextAlign.center),
                      TEXT("bagi Anda dan para Klien.",
                          textAlign: TextAlign.center),
                      SPACE(height: 20),
                      SizedBox(
                        width: Get.width / 1.5,
                        child: BUTTON(
                          "Selanjutnya",
                          onPressed: () async {
                            // Get.to(HowToUseAuthPage());
                            await pushNewScreen(
                              context,
                              screen: HowToUseAuthPage(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WelcomeCounselorController extends GetxController {}
