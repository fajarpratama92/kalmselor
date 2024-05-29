import 'dart:convert';
import 'dart:developer';

import 'package:counselor/api/api.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/main_tab.dart';
import 'package:counselor/translation/translation.dart';
import 'package:counselor/utilities/translation.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../color/colors.dart';
import '../../controller/counselor-chat-controller.dart';
import '../../widget/space.dart';

class TransferClientPage extends StatelessWidget {
  final ClientStatusModel client;
  TransferClientPage({Key? key, required this.client}) : super(key: key);
  final _changeCounselorController = Get.put(TransferClientController());

  @override
  Widget build(BuildContext context) {
    return SAFE_AREA(
      context: context,
      // context: context,
      child: GetBuilder<TransferClientController>(
        initState: (_) {
          // print(_changeCounselorController.description.length.toString());
          _changeCounselorController.checkBoxController = List.generate(
              _changeCounselorController.description.length, (i) => false);
        },
        builder: (_) {
          // return Column(children: [
          //   Text("Hallo"),
          //   // Text(_.description?.toString() ?? ""),
          // ]);
          return ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    SPACE(),
                    const Text(
                      'Transfer Client',
                      style: TextStyle(
                          fontSize: 30,
                          color: BLUEKALM,
                          fontWeight: FontWeight.w900),
                    ),
                    SPACE(),
                    const Divider(thickness: 2),
                    _selectReason(_, context),
                    SPACE(),
                    Builder(
                      builder: (context) {
                        switch (_.checkBoxController!.last) {
                          case true:
                            return CupertinoTextField(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5),
                                  borderRadius: BorderRadius.circular(5)),
                              placeholder: "Wajib Diisi",
                              onChanged: (val) => _.onChanged(client.code!),
                              maxLines: null,
                              controller: _.editingController,
                              keyboardType: TextInputType.multiline,
                            );
                          case false:
                            return Container();
                          default:
                        }
                        return Container();
                      },
                    ),
                    const Divider(thickness: 2),
                    _footerDesc(_),
                    SPACE(height: 20),
                    BUTTON(
                      "Submit".tr,
                      onPressed: _.submitValidation
                          ? () => _.submit(context: context)
                          : null,
                      // verticalPad: 30,
                      // expandedHorizontalPad: 60,
                    ),
                    //     onPressed: _.submitValidation ? () => _.submit() : null,
                    //     heigth: 30,
                    //     padHorizontal: 60,
                    //     title: Translating().SUBMIT.tr),
                    const Text("*Wajib pilih salah satu",
                        style: TextStyle(color: Colors.grey)),
                    SPACE(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Column _footerDesc(TransferClientController _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_.footerDescription.length, (i) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_.footerDescription[i],
                style: const TextStyle(fontWeight: FontWeight.w200)),
            if (i != (_.footerDescription.length - 1))
              const Divider(thickness: 2),
          ],
        );
      }),
    );
  }

  Column _selectReason(TransferClientController _, context) {
    return Column(
      children: List.generate(
        _.description.length,
        (i) {
          return Column(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    minimumSize: Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft),
                onPressed: () => _.setCheckBoxController(i, client.code!),
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _.checkBoxController![i]
                                ? ORANGEKALM
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    SPACE(),
                    Flexible(
                      child: Text(
                        _.description[i],
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              // SPACE(),
            ],
          );
        },
      ),
    );
  }
}

class TransferClientController extends GetxController {
  List<dynamic> get description =>
      jsonDecode(Translating().TRANFER_CLIENT_DESC.tr);
  List<dynamic> get footerDescription =>
      jsonDecode(Translating().COUN_CHANGE_DESC2.tr);

  List<bool>? checkBoxController;
  Map<String, dynamic>? _payload;
  TextEditingController editingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool get submitValidation =>
      ((checkBoxController!.contains(true) && !checkBoxController!.last) ||
          (checkBoxController!.last && _payload!['reason'].length > 0));

  void setCheckBoxController(int index, String clientCode) {
    for (var i = 0; i < checkBoxController!.length; i++) {
      if (i == index) {
        checkBoxController![i] = true;
      } else {
        checkBoxController![i] = false;
      }
    }
    if (index == (description.length - 1)) {
      _payload = {"user_code": clientCode, "reason": editingController.text};
    } else {
      _payload = {"user_code": clientCode, "reason": description[index]};
    }
    update();
  }

  void onChanged(String clientCode) {
    _payload = {"user_code": clientCode, "reason": editingController.text};
    update();
  }

  Future<void> submit({required BuildContext context}) async {
    print(_payload.toString());
    // Loading.hide();

    WrapResponse? _res = await Api().POST(REQUEST_TRANSFER_CLIENT, _payload,
        useToken: true, useSnackbar: false);
    // berhasil tapi error

    if (_res?.statusCode == 200) {
      PRO.removeCounselorClientList();
      await PRO.updateSession(context: context);
      // KalmAppController().selectedIndex = 1;
      PRO.onChangeTab(1);
      Loading.hide();
      pushRemoveUntilScreen(context, screen: KalmMainTab(context: context));
      // Get.offAll(() => KalmMainTab(context: context));
      // Get.snackbar('Perhatian', _res?.message ?? "No Message");
      // snackBars(message: "Ok");
    } else {
      PRO.removeCounselorClientList();
      await PRO.updateSession(context: context);
      // KalmAppController().selectedIndex = 1;
      PRO.onChangeTab(1);
      Loading.hide();
      // Get.offAll(() => KalmMainTab(context: context));
      pushRemoveUntilScreen(context, screen: KalmMainTab(context: context));
      // snackBars(message: "Ok");
    }
  }
}
