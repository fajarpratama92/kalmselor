import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/register_tnc_res_model/register_tnc_res_model.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/pages/auth/register.dart';
import 'package:counselor/pages/auth/verify_code.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';

class RegisterTncPage extends StatelessWidget {
  final RegisterTncResModel? registerTncResModel;
  RegisterTncPage({Key? key, required this.registerTncResModel})
      : super(key: key);
  final _controller = Get.put(RegisterTncController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterTncController>(initState: (st) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) {
          if (_controller.hasListeners) {
            _controller.scrollController.addListener(() {
              if (_controller.scrollController.offset ==
                  _controller.scrollController.position.maxScrollExtent) {
                _controller.onReaded();
              }
            });
          } else {
            _controller.onReaded();
          }
        },
      );
    }, builder: (_) {
      return NON_MAIN_SAFE_AREA(
          bottomPadding: 0,
          child: Column(
            children: [
              SPACE(height: 50),
              Expanded(
                child: Scrollbar(
                  controller: _.scrollController,
                  child: ListView(
                    controller: _.scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Html(
                          data: registerTncResModel?.tncData?.description,
                          style: {
                            "p": Style(
                                fontSize: FontSize(16),
                                color: Colors.black,
                                fontWeight: FontWeight.normal)
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: BLUEKALM),
                    borderRadius: const BorderRadiusDirectional.only(
                        topEnd: Radius.circular(10),
                        topStart: Radius.circular(10))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      TEXT(
                          "Dengan membaca syarat dan ketentuan,Anda dengan ini setuju, memahami dan menerima Syarat Dan Ketentuan tersebut",
                          style: COSTUM_TEXT_STYLE(
                              fonstSize: 12, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center),
                      SPACE(height: 15),
                      SizedBox(
                          width: Get.width / 1.4,
                          child: BUTTON("Selanjutnya",
                              onPressed: _.haveReadTnc
                                  ? () async => await _.submit(context: context)
                                  : null,
                              verticalPad: 15,
                              circularRadius: 30)),
                      SPACE(),
                    ],
                  ),
                ),
              )
            ],
          ));
    });
  }
}

class RegisterTncController extends GetxController {
  ScrollController scrollController = ScrollController();
  bool haveReadTnc = false;
  void onReaded() {
    haveReadTnc = true;
    update();
  }

  Future<void> submit({required BuildContext context}) async {
    var _res = await Api().POST(REGISTER, PRO.registerPayload?.toJson());
    if (_res?.statusCode == 200 || _res?.statusCode == 201) {
      var _userModel = UserModel.fromJson(_res?.data);
      await PRO.saveLocalUser(_userModel.data);
      await PRO.removeTempCode();
      Loading.hide();
      // Get.to(VerifyCodePage());
      await pushNewScreen(context, screen: VerifyCodePage());
    } else if (_res?.statusCode == 400) {
      Loading.hide();
      Get.offAll(() => RegisterPage());
    } else {
      Loading.hide();
      Get.offAll(() => RegisterPage());
    }
  }
}
