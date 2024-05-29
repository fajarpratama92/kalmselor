import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/pages/auth/counselor_tnc.dart';
import 'package:counselor/widget/box_border.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/image_cache.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutMePage extends StatelessWidget {
  final _controller = Get.put(AboutMeController());

  AboutMePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SAFE_AREA(
      context: context,
      // useLogo: false,
      useNotification: false,
      child: GetBuilder<AboutMeController>(
        builder: (_) {
          return SingleChildScrollView(
            child: SizedBox(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TEXT("PROFIL SAYA",
                      style: COSTUM_TEXT_STYLE(
                          fonstSize: 25, fontWeight: FontWeight.w900)),
                  SPACE(height: 20),
                  CircleAvatar(
                      backgroundColor: BLUEKALM,
                      radius: 100,
                      child: IMAGE_CACHE(
                        "$IMAGE_URL/users/${PRO.userData?.photo}",
                        width: 190,
                        height: 190,
                        circularRadius: 100,
                      )),
                  SPACE(),
                  TEXT(
                      "${PRO.userData?.firstName?.capitalize} ${(PRO.userData?.lastName ?? "").capitalize}",
                      style: titleApp20),
                  SPACE(),
                  TEXT(_.about, textAlign: TextAlign.center),
                  SPACE(height: 20),
                  SizedBox(
                      width: Get.width / 1.5,
                      child: BUTTON(
                          _.buttonVal ? "Selanjutnya" : "Tulis Profil",
                          onPressed: () async => _.buttonVal
                              ? await _.submit(context: context)
                              : await _.openTextEditing()))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AboutMeController extends GetxController {
  String desc =
      "Tulis deskripsi mengenai diri Anda sebagai\nseorang konselor disini. Penjelasan ini akan\nberguna untuk memberikan latar belakang dan\npengenalan diri Anda kepada Klien";
  String get about {
    return (aboutTextController.text.isNotEmpty
        ? aboutTextController.text
        : desc);
  }

  bool get buttonVal {
    return aboutTextController.text.isNotEmpty;
  }

  TextEditingController aboutTextController = TextEditingController();
  Future<void> openTextEditing() async {
    await Get.dialog(Center(
      child: BOX_BORDER(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                    child: CupertinoTextField(
                  textAlignVertical: TextAlignVertical.top,
                  placeholder: "Isi Deskripsi disini",
                  controller: aboutTextController,
                  maxLines: null,
                )),
                SPACE(),
                SizedBox(
                    width: (Get.width / 1.2) - 100,
                    child: BUTTON("Simpan", onPressed: () {
                      update();
                      Get.back();
                    }))
              ],
            ),
          ),
          fillColor: Colors.white,
          height: Get.height / 3,
          width: Get.width / 1.2,
          circularRadius: 10),
    ));
  }

  Future<void> submit({required BuildContext context}) async {
    var _res = await Api().POST(
        ABOUT_ME, {"about_me": aboutTextController.text},
        useToken: true, useSnackbar: false);
    try {
      if (_res?.statusCode == 200) {
        await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
        Loading.hide();
        // CounselorTncPage());
        await pushNewScreen(context, screen: CounselorTncPage());
        // snackBars(message: _res?.message ?? "");
      } else {
        Loading.hide();
        snackBars(message: _res?.message ?? "");
        return;
      }
    } catch (e) {
      Loading.hide();
      snackBars(message: e.toString());
    }
  }
}
