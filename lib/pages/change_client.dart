import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/tab_pages/chat_page.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';

class ChangeClientPage extends StatelessWidget {
  final _controller = Get.put(ChangeClientController());

  ChangeClientPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangeClientController>(builder: (_) {
      return SAFE_AREA(
          context: context,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    TEXT("Ganti Kalmselor", style: titleApp20),
                    const Divider(thickness: 1),
                    SPACE(),
                    _reason(_),
                    if (_.payload['reason'] == "Lainnya")
                      Column(
                        children: [
                          SPACE(),
                          CupertinoTextField(
                            onChanged: (val) => _.otherReasonOnChange(val),
                            controller: _.otherReasonController,
                            minLines: 1,
                            maxLines: 5,
                            placeholder: "Wajib diisi ( minimal 8 karakter )",
                          ),
                        ],
                      ),
                    SPACE(),
                    _question(_),
                    SPACE(height: 20),
                    SizedBox(
                        width: Get.width / 1.5,
                        child: BUTTON("Kirim",
                            onPressed: _.validationPaylaod
                                ? () async => await _.submit(context)
                                : null,
                            circularRadius: 20)),
                    TEXT("*Wajib pilih salah satu",
                        style: COSTUM_TEXT_STYLE(
                            fonstSize: 12, color: Colors.grey))
                  ],
                ),
              )
            ],
          ));
    });
  }

  Column _question(ChangeClientController _) {
    return Column(
      children: _.question.map((e) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 1),
            TEXT(e),
          ],
        );
      }).toList(),
    );
  }

  Column _reason(ChangeClientController _) {
    return Column(
      children: List.generate(_.reason.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: InkWell(
            onTap: () => _.updatePayload(_.reason[i]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: BLUEKALM),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: _.payload['reason']!.contains(_.reason[i])
                                ? ORANGEKALM
                                : Colors.white,
                            border: Border.all(width: 0.5, color: BLUEKALM),
                            borderRadius: BorderRadius.circular(2))),
                  ),
                ),
                SPACE(),
                TEXT(_.reason[i])
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ChangeClientController extends GetxController {
  TextEditingController otherReasonController = TextEditingController();
  Map<String, String> payload = {"reason": ""};
  bool validateOtherReason = false;
  bool get validationPaylaod =>
      validateOtherReason ||
      payload['reason']!.isNotEmpty && payload['reason']! != "Lainnya";
  otherReasonOnChange(String val) {
    if (val.length > 8) {
      validateOtherReason = true;
    } else {
      validateOtherReason = false;
    }
    update();
  }

  List<String> reason = [
    "Saya merasa Kalmselor saya tidak\nmenangani kebutuhan saya dengan\nbaik",
    "Saya mencari Kalmselor dengan\nkeahlian yang berbeda",
    "Saya ingin mencari perspektif yang\nberbeda dari Kalmselor yang lain",
    "Lainnya"
  ];
  List<String> question = [
    "Apakah ada informasi tambahan mengenai\nalasan Anda ingin mengganti Kalmselor? Hal ini akan sangat membantu kami!",
    "Silahkan memilih preferensi yang Anda\ninginkan untuk Kalmselor baru Anda setelah\nmenekan tombol di bawah"
  ];
  void updatePayload(String reason) {
    payload.update("reason", (value) => reason);
    update();
  }

  Future<void> submit(BuildContext context) async {
    if (payload['reason'] == "Lainnya") {
      payload.update("reason", (value) => otherReasonController.text);
    }
    var _res =
        await Api().POST(REQUEST_CHANGE_COUNSELOR, payload, useToken: true);

    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
      Loading.hide();
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Loading.hide();
      return;
    }
  }
}
