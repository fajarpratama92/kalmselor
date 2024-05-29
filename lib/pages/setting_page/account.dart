import 'package:counselor/tab_pages/setting_page.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/change_password_payload.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/textfield.dart';

import '../../model/delete_account_payload.dart';
import '../../widget/dialog.dart';

class AccountPage extends StatelessWidget {
  final _controller = Get.put(AccountController());

  AccountPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(dispose: (d) {
      _controller.clearTextController();
    }, builder: (_) {
      return SAFE_AREA(
          context: context,
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    TEXT("GANTI PASSWORD", style: titleApp24),
                    Column(
                      children: List.generate(4, (i) {
                        return Builder(builder: (context) {
                          if (i == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SPACE(),
                                TEXT("Email", style: titleApp20),
                                _textField(_.textController[i],
                                    onSubmitted:
                                        _.onSubmitted(context: context)[i],
                                    onChanged: _.onChange()[i],
                                    focusNode: _.focusNode[i],
                                    obscureText: _.obsecureController[i],
                                    onPressedSecure: _.onPressSecure()[i],
                                    isRead: i == 0),
                                SPACE(),
                                TEXT("Ubah Password", style: titleApp20),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                _textField(_.textController[i],
                                    onSubmitted:
                                        _.onSubmitted(context: context)[i],
                                    onChanged: _.onChange()[i],
                                    focusNode: _.focusNode[i],
                                    obscureText: _.obsecureController[i],
                                    onPressedSecure: _.onPressSecure()[i],
                                    isRead: i == 0,
                                    placeholder: _.placeholder[i]),
                                if (!_.validationField[i] &&
                                    _.textController[i].text.isNotEmpty)
                                  ERROR_VALIDATION_FIELD(_.errorMessageField[i])
                              ],
                            );
                          }
                        });
                      }),
                    ),
                    SPACE(),
                    BUTTON("Kirim",
                        onPressed: !_.validationField.contains(false)
                            ? () async => await _.submit(context)
                            : null,
                        verticalPad: 15,
                        circularRadius: 30),

                    SPACE(height: 100),
                    SizedBox(
                      width: Get.width / 1.3,
                      child: BUTTON("Hapus akun",
                          circularRadius: 30,
                          verticalPad: 15, onPressed: () async {
                            SHOW_DIALOG("Apakah Anda yakin ingin menghapus akun ini?",
                                onAcc: () async => await _.deleteAccount(context),
                                reject: () => Get.back(),
                                barrierDismissible: true);
                          }
                      ),
                    ),
                  ],
                ),
              )
            ],
          ));
    });
  }

  Padding _textField(
    TextEditingController controller, {
    bool obscureText = true,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    void Function()? onPressedSecure,
    bool isRead = false,
    String? placeholder,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: 40,
        child: CupertinoTextField(
          padding: const EdgeInsets.all(10.0),
          placeholder: placeholder,
          readOnly: isRead,
          focusNode: focusNode,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          obscureText: obscureText,
          controller: controller,
          prefix: isRead
              ? const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.email),
                )
              : null,
          suffix: isRead
              ? null
              : IconButton(
                  onPressed: onPressedSecure,
                  icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility)),
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: BLUEKALM),
              borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}

class AccountController extends GetxController {
  List<TextEditingController> textController = List.generate(4, (i) {
    if (i == 0) {
      return TextEditingController(text: PRO.userData?.email);
    } else {
      return TextEditingController();
    }
  });
  List<bool> obsecureController = List.generate(4, (i) {
    if (i == 0) {
      return false;
    } else {
      return true;
    }
  });
  List<bool> validationField = List.generate(4, (i) {
    if (i == 0) {
      return true;
    } else {
      return false;
    }
  });

  List<FocusNode> focusNode = List.generate(4, (i) => FocusNode());
  List<String> placeholder = [
    "Email",
    "Password Lama",
    "Password Baru",
    "Konfirmasi Password Baru"
  ];
  List<String> errorMessageField = [
    "",
    "Minimal 6 karakter",
    "Minimal 6 karakter dan pastikan tidak sama dengan password lama",
    "Konfirmasi Password sesuai"
  ];

  List<Function(String val)> onChange() {
    return List.generate(4, (i) {
      return (v) {
        if (v.isNotEmpty && v.length < 6) {
          validationField[i] = false;
        } else if (i == 2) {
          if ((v.isNotEmpty) && v == textController[1].text) {
            validationField[i] = false;
          } else {
            validationField[i] = true;
          }
        } else if (i == 3) {
          if ((v.isNotEmpty) && v != textController[2].text) {
            validationField[i] = false;
          } else {
            validationField[i] = true;
          }
        } else {
          validationField[i] = true;
        }
        update();
      };
    });
  }

  List<Function(String val)> onSubmitted({required BuildContext context}) {
    return List.generate(4, (i) {
      return (v) async {
        try {
          if (i == 3) {
            await submit(context);
          }
          focusNode[i].unfocus();
          FocusScope.of(context).requestFocus(focusNode[i + 1]);
        } catch (e) {
          focusNode[i].unfocus();
        }
      };
    });
  }

  List<Function()> onPressSecure() {
    return List.generate(4, (i) {
      return () {
        obsecureController[i] = !obsecureController[i];
        update();
      };
    });
  }

  void clearTextController() {
    for (var i = 0; i < textController.length; i++) {
      if (i != 0) {
        textController[i].clear();
      }
    }
  }

  ChangePasswordPayload get changePasswordPayload => ChangePasswordPayload(
      currentPassword: textController[1].text,
      newPassword: textController[2].text,
      confirmPassword: textController[3].text);

  Future<void> submit(BuildContext context) async {
    var _res = await Api()
        .POST(CHANGE_PASSWORD, changePasswordPayload.toJson(), useToken: true);
    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
      Loading.hide();
      // SUCCESS_SNACK_BAR("Perhatian", _res?.message);
      // snackBars(message: _res?.message ?? "");
      SUCCESS_SNACK_BAR("Perhatian", _res?.message);
      await pushRemoveUntilScreen(context, screen: SettingPage());
    } else {
      Loading.hide();
      return;
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      var _payload = DeleteAccountPayload(
        userCode: PRO.userData?.code,
      );
      var _res =
      await Api().POST(DELETE_ACCOUNT, _payload.toJson(), useToken: true, useLoading: true);
      if (_res?.statusCode == 200) {
        await PRO.clearAllData();
        Loading.hide();
        update();
      } else {
        Loading.hide();
        return;
      }
    } catch (e) {
      print(e);
    }
  }

}
