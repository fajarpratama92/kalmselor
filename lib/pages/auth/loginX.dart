import 'dart:math' as math;

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/pages/auth/profile_reg.dart';
import 'package:counselor/pages/auth/verify_code.dart';
import 'package:counselor/pages/auth/welcome_counselor.dart';
import 'package:counselor/pages/counselor/upload_mandatory_2.dart';
import 'package:counselor/pages/setting_page/notification.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';

import '../../main_tab.dart';
import 'login.dart';
// import 'package:app_settings/app_settings.dart';

class LoginXPage extends StatelessWidget {
  final _controller = Get.put(LoginXController());

  LoginXPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginXController>(
      builder: (_) {
        return NON_MAIN_SAFE_AREA(
          bottomPadding: 0,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Image.asset(
                      'assets/wave/wave5.png',
                      width: Get.width,
                      alignment: Alignment.topCenter,
                      color: BLUEKALM.withOpacity(0.5),
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/wave/login_wave.png',
                      width: Get.width,
                      alignment: Alignment.bottomCenter,
                      color: BLUEKALM.withOpacity(0.5),
                      colorBlendMode: BlendMode.srcATop,
                    ),
                  ),
                ],
              ),
              Container(
                // decoration: const BoxDecoration(
                //     color: Colors.white,
                //     image: DecorationImage(
                //         colorFilter:
                //             ColorFilter.mode(BLUEKALM, BlendMode.srcATop),
                //         opacity: 0.5,
                //         image: AssetImage('assets/wave/wave5.png'),
                //         alignment: Alignment.topCenter)),
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          if (MediaQuery.of(context).viewInsets.bottom == 0.0)
                            Column(
                              children: [
                                Image.asset('assets/icon/counselor.png',
                                    scale: 2.5),
                                SPACE(),
                                Image.asset(
                                  'assets/icon/counselor_login.png',
                                  scale: 2.5,
                                ),
                                SPACE(),
                                TEXT(
                                  "DEVELOPER",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 50,
                                    fontFamily: "Courier",
                                    fontWeight: FontWeight.bold,
                                    color: TEXTBLUEKALM,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(10.0, 10.0),
                                        blurRadius: 10.0,
                                        color: Colors.grey,
                                      ),
                                      Shadow(
                                        offset: Offset(10.0, 10.0),
                                        blurRadius: 15.0,
                                        color: TEXTBLUEKALM,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          SPACE(),
                          TEXT_FIELD(_.userCodeField,
                              focusNode: _.userCodeFocus,
                              onSubmitted: (val) =>
                                  _.onSubmittedUserCode(val, context: context),
                              prefixIcon: const Icon(Icons.person_rounded),
                              hint: 'User code'),
                          SPACE(),
                          SPACE(),
                          TEXT_FIELD(
                            _.tokenField,
                            onSubmitted: (val) async =>
                                await _.onSubmittedToken(val, context: context),
                            focusNode: _.tokenFocus,
                            onChanged: (val) => _.onChangeToken(val),
                            prefixIcon: Icon(Icons.key),
                            hint: "Token",
                          ),
                          SPACE(),
                          SPACE(height: 20),
                          BUTTON("Masuk",
                              verticalPad: 15,
                              circularRadius: 30,
                              onPressed: _.validationForm
                                  ? () async => await _.submit(context: context)
                                  : null),
                          SPACE(),
                          SPACE(height: 20),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 10),
                    child: IconButton(
                      onPressed: () {
                        PRO.devMode = false;
                        Get.offAll(LoginPage());
                      },
                      color: Colors.lightBlue,
                      icon: Icon(Icons.keyboard_double_arrow_left_sharp),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class LoginXController extends GetxController {
  Widget? validateEmail, validatePassword;
  FocusNode userCodeFocus = FocusNode();
  FocusNode tokenFocus = FocusNode();
  TextEditingController userCodeField = TextEditingController();
  TextEditingController tokenField = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  bool get validationForm =>
      userCodeField.text.isNotEmpty && tokenField.text.isNotEmpty;

  void onChangeToken(String val) {
    if (val.isEmpty) {
      validatePassword = null;
    } else {
      // validatePassword = SUCCESS_VALIDATION_FIELD("Password Terverifikasi");
      validatePassword = null;
    }
    update();
  }

  void onSubmittedUserCode(String val, {required BuildContext context}) {
    userCodeFocus.unfocus();
    FocusScope.of(context).requestFocus(tokenFocus);
  }

  void clearField() {
    userCodeField.clear();
    tokenField.clear();
    userCodeFocus.unfocus();
    tokenFocus.unfocus();
    update();
  }

  Future<void> onSubmittedToken(String val,
      {required BuildContext context}) async {
    validationForm ? await submit(context: context) : null;
  }

  Future<int?> _deviceNum() async {
    try {
      if (await FlutterDeviceIdentifier.checkPermission()) {
        try {
          var _serialNumber = await FlutterDeviceIdentifier.imeiCode;
          return double.parse(_serialNumber.replaceAll(RegExp(r"\D"), ''))
              .floor();
        } catch (e) {
          var rng = math.Random();
          var l = List.generate(8, (_) => rng.nextInt(100));
          return int.parse(l.join(',').replaceAll(',', ''));
        }
      } else {
        if (await FlutterDeviceIdentifier.requestPermission()) {
          try {
            var _serialNumber = await FlutterDeviceIdentifier.imeiCode;
            return double.parse(_serialNumber.replaceAll(RegExp(r"\D"), ''))
                .floor();
          } catch (e) {
            var rng = math.Random();
            var l = List.generate(8, (_) => rng.nextInt(100));
            return int.parse(l.join(',').replaceAll(',', ''));
          }
        } else {
          ERROR_SNACK_BAR("Perhatian", 'Izinkan aplikasi untuk melanjutkan');
          await Future.delayed(const Duration(seconds: 2));
          FlutterDeviceIdentifier.openSettings();
          // AppSettings.openNotificationSettings();
          return null;
        }
      }
    } catch (e) {
      var rng = math.Random();
      var l = List.generate(8, (_) => rng.nextInt(100));
      return int.parse(l.join(',').replaceAll(',', ''));
    }
  }

  submit({required BuildContext context}) async {
    final deviceNum = await _deviceNum();
    if (deviceNum == null) {
      return;
    }
    final _installationId = await WonderPush.getInstallationId();

    WrapResponse? _resData = await Api().GET(SESSION(userCodeField.text),
        customToken: tokenField.text,
        useToken: true);

    if (_resData?.statusCode == 200) {
      clearField();
      UserModel _user = UserModel.fromJson(_resData?.data);

      await PRO.saveLocalUser(_user.data);
      await Permission.notification.isGranted
          ? await NotificationController().postInstallationId()
          : await Permission.notification.status;
      if (PRO.userTempCode != null) {
        ERROR_SNACK_BAR(
            'Perhatian', 'Anda Belum menyelesaikan proses registrasi');

        ///harusnya kesini
        await Get.offAll(ProfileRegPage());
        // await Get.offAll(() => RegisterPage());
      } else if (PRO.userData?.status == 8 || PRO.userData?.status == 2) {
        ERROR_SNACK_BAR(
            'Perhatian', 'Anda Belum menyelesaikan proses registrasi');
        await Get.offAll(() => ProfileRegPage());
      } else {
        if (PRO.userData != null) {
          if (PRO.userData?.status == 1) {
            PRO.analyticObserver.analytics.logLogin(loginMethod: "");
            await PRO.setUserProperty();
            await PRO.saveLocalUser(_user.data);
            await pushReplacementNewScreen(context,
                screen: KalmMainTab(context: context));
            // await PRO.getCounselorQuestioner(
            //     useLoading: false, useSnackbar: false);
          } else if (PRO.userData?.status == 5) {
            await pushReplacementNewScreen(context,
                screen: VerifyCodePage(resendCode: true));
          } else if (PRO.userData?.status == 6) {
            await PRO.getStatusFileMandatory();
            // await Get.offAll(() => ApprovalMandatoryPage());
            await pushReplacementNewScreen(context,
                screen: CounselorUploadMandatoryPage());
          } else if (PRO.userData?.status == 7) {
            await PRO.getStatusFileMandatory();
            ERROR_SNACK_BAR(
                'Perhatian', 'Anda Belum menyelesaikan proses registrasi');
            await pushReplacementNewScreen(context,
                screen: CounselorUploadMandatoryPage());
          } else if (PRO.userData?.status == 9) {
            await PRO.getStatusFileMandatory();
            await pushReplacementNewScreen(context,
                screen: WelcomeCounselorPage());
          } else {
            await pushReplacementNewScreen(context, screen: LoginXPage());
          }
        } else {
          await pushReplacementNewScreen(context, screen: LoginXPage());
        }
      }
    } else {
      Loading.hide();

      snackBars(message: _resData?.message ?? "");
    }
  }
}
