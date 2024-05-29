import 'dart:io';
import 'dart:math' as math;

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/login_payload.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/pages/auth/onboarding.dart';
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
// import 'loginX.dart';
// import 'package:app_settings/app_settings.dart';

class LoginPage extends StatelessWidget {
  final _controller = Get.put(LoginController());

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (_) {
      return NON_MAIN_SAFE_AREA(
          bottomPadding: 0,
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/wave/login_wave.png'),
                    alignment: Alignment.bottomCenter)),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      if (MediaQuery.of(context).viewInsets.bottom == 0.0)
                        Column(
                          children: [
                            Image.asset('assets/icon/counselor.png',
                                scale: 2.5),
                            SPACE(),
                            Image.asset('assets/icon/counselor_login.png',
                                scale: 2.5),
                          ],
                        ),
                      TEXT_FIELD(_.emailField,
                          focusNode: _.emailFocus,
                          onSubmitted: (val) =>
                              _.onSubmittedEmail(val, context: context),
                          onChanged: (val) => _.onChangeEmail(val),
                          prefixIcon: const Icon(Icons.email_outlined),
                          hint: 'Email'),
                      SPACE(),
                      if (_.validateEmail != null) _.validateEmail!,
                      SPACE(),
                      TEXT_FIELD(
                        _.passwodField,
                        obscureText: _.passwordObsecure,
                        onSubmitted: (val) async =>
                            await _.onSubmittedPassword(val, context: context),
                        focusNode: _.passwordFocus,
                        onChanged: (val) => _.onChangePassword(val),
                        prefixIcon: Icon(_.passwordObsecure
                            ? Icons.lock_outline
                            : Icons.lock_open_outlined),
                        hint: "Password",
                        suffixIcon: IconButton(
                          onPressed: () => _.onChangeObsecure(),
                          icon: Icon(
                            _.passwordObsecure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      SPACE(),
                      if (_.validatePassword != null) _.validatePassword!,
                      SPACE(height: 20),
                      BUTTON("Masuk",
                          verticalPad: 15,
                          circularRadius: 30,
                          onPressed: _.validationForm
                              ? () async => await _.submit(context: context)
                              : null),
                      SPACE(),
                      StreamBuilder(
                        stream: _controller.registerRef(),
                        builder:
                            (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                          if (snapshot.hasData) {
                            Map? data = (snapshot.data?.snapshot.value as Map?);
                            return BUTTON(
                              "Daftar",
                              verticalPad: 15,
                              circularRadius: 30,
                              onPressed: () {
                                if (data != null) {
                                  if (data['enable'] == true) {
                                    pushNewScreen(context,
                                        screen: OnBoardingPage());
                                  } else if (data['enable'] == false) {
                                    snackBars(message: data['message']);
                                  }
                                }
                              },
                            );
                          }
                          return BUTTON(
                            "Daftar",
                            verticalPad: 15,
                            circularRadius: 30,
                            onPressed: null,
                          );
                        },
                      ),
                      // BUTTON("Daftar", verticalPad: 15, circularRadius: 30,
                      //     onPressed: () {
                      //   // Get.to(OnBoardingPage());
                      //   pushNewScreen(context, screen: OnBoardingPage());
                      // }),
                      SPACE(height: 20),
                      _forgetPassword(_),
                    ],
                  ),
                )
              ],
            ),
          ));
    });
  }

  InkWell _forgetPassword(LoginController _) {
    return InkWell(
        onTap: () async {
          TextEditingController _emailController = TextEditingController();
          bool _validateEmail = false;
          await Get.bottomSheet(StatefulBuilder(builder: (context, st) {
            return Container(
                color: Colors.white,
                height: Get.height / 3.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      TEXT("Lupa Password", style: titleApp20),
                      SPACE(),
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                            child: CupertinoTextField(
                              onChanged: (val) {
                                st(() {
                                  if (val.isEmail) {
                                    _validateEmail = true;
                                  } else {
                                    _validateEmail = false;
                                  }
                                });
                              },
                              placeholder: "Email",
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 0.5, color: BLUEKALM)),
                              controller: _emailController,
                            ),
                          ),
                          if (!_validateEmail &&
                              _emailController.text.length > 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child:
                                  ERROR_VALIDATION_FIELD("Email tidak valid"),
                            )
                        ],
                      ),
                      SPACE(),
                      Row(
                        children: [
                          BUTTON(
                            "Lanjutkan",
                            onPressed: () async {
                              Get.back();
                              await _.forgotPassword(_emailController.text);
                            },
                            isExpanded: true,
                            expandedHorizontalPad: 5,
                          ),
                          BUTTON("Batalkan", onPressed: () {
                            Get.back();
                          }, isExpanded: true, expandedHorizontalPad: 5),
                        ],
                      ),
                    ],
                  ),
                ));
          }), barrierColor: BLUEKALM.withOpacity(0.6));
        },
        child: TEXT("Lupa Kata Sandi?",
            style: COSTUM_TEXT_STYLE(
                color: ORANGEKALM, fontWeight: FontWeight.w600)));
  }
}

class LoginController extends GetxController {
  Widget? validateEmail, validatePassword;
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  TextEditingController emailField = TextEditingController();
  TextEditingController passwodField = TextEditingController();
  bool passwordObsecure = true;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Stream<DatabaseEvent> registerRef() {
    return ref.child("open_register").onValue;
  }

  bool get validationForm =>
      (validateEmail == null && validatePassword == null) &&
      (emailField.text.isNotEmpty && passwodField.text.isNotEmpty);

  void onChangeObsecure() {
    passwordObsecure = !passwordObsecure;
    update();
  }

  void onChangeEmail(String val) {
    // if (val == "CraniumDevModeOn") {
    //   Get.offAll(LoginXPage());
    // } else
      if (val.isEmpty) {
      validateEmail = null;
    } else if (!val.isEmail) {
      validateEmail = ERROR_VALIDATION_FIELD("Email tidak valid");
    } else {
      // validateEmail = SUCCESS_VALIDATION_FIELD("Email Terverifikasi");
      validateEmail = null;
    }
    update();
  }

  void onChangePassword(String val) {
    if (val.isEmpty) {
      validatePassword = null;
    } else if (val.length < 6) {
      validatePassword = ERROR_VALIDATION_FIELD("Password minimal 6 digit");
    } else {
      // validatePassword = SUCCESS_VALIDATION_FIELD("Password Terverifikasi");
      validatePassword = null;
    }
    update();
  }

  void onSubmittedEmail(String val, {required BuildContext context}) {
    emailFocus.unfocus();
    FocusScope.of(context).requestFocus(passwordFocus);
  }

  void clearField() {
    emailField.clear();
    passwodField.clear();
    emailFocus.unfocus();
    passwordFocus.unfocus();
    update();
  }

  Future<void> onSubmittedPassword(String val,
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

  // Future<String?> _installationId() async {
  // print(Platform.localHostname);
  // if (Platform.localHostname == "Fajars-MacBook-PRO.local") {
  //   return "test-installation";
  // } else {
  //   return
  // await WonderPush.getInstallationId();
  // }
  // }

  Future<void> forgotPassword(String email) async {
    var _res =
        await Api().POST(FORGOT_PASSWORD, {"email": email, "role": "20"});
    if (_res?.statusCode == 200) {
      Loading.hide();
      SUCCESS_SNACK_BAR("Perhatian", _res?.data['message']);
      return;
    } else {
      Loading.hide();
      return;
    }
  }

  Future<List> _getStatusCredential() async {
    WrapResponse? _resData =
        await Api().GET(APPROVAL_MANDATORY_FILES, useToken: true);
    var _res = UserModel.fromJson(_resData?.data);

    if (_res.status == 200) {
      PRO.setUserSession(data: _res);
      return [true, "${_res.message ?? ""}"];
    } else {
      return [false, "${_res.message ?? ""}"];
    }
  }

  // Future<void> submit({required BuildContext context}) async {
  //   if (await _installationId() == null) {
  //     ERROR_SNACK_BAR('Perhatian',
  //         "Anda tidak mengizinkan fitur Notifikasi di ponsel Anda\n Silahkan restart aplikasi KALM untuk mengaktifkan notifikasi kembali");
  //     return;
  //   } else if (await _deviceNum() == null) {
  //     return;
  //   }
  //   var _firebaseToken = await PRO.firebaseAuth.currentUser?.getIdToken();
  //   var _payload = LoginPayload(
  //     email: emailField.text,
  //     password: passwodField.text,
  //     deviceNumber: await _deviceNum(),
  //     installationId: await _installationId(),
  //     deviceType: Platform.isAndroid ? 0 : 1,
  //     firebaseToken: _firebaseToken,
  //     role: "20",
  //   );
  //   var _res = await Api().POST(AUTH, _payload.toJson());
  //   if (_res?.statusCode == 200) {
  //     var _user = UserModel.fromJson(_res?.data).data;
  //     await PRO.saveLocalUser(_user);
  //     print('${PRO.userData?.status}');
  //     print('${PRO.userTempCode}');
  //     print(_res.toString());
  //     // if (PRO.userData?.status == null) {
  //     //   ERROR_SNACK_BAR(
  //     //       'Perhatian', 'Anda Belum menyelesaikan proses registrasi');
  //     //   clearField();
  //     //   await Get.offAll(() => ProfileRegPage());
  //     if (PRO.userTempCode != null) {
  //       ERROR_SNACK_BAR(
  //           'Perhatian', 'Anda Belum menyelesaikan proses registrasi');
  //       clearField();
  //       await Get.offAll(() => RegisterPage(),);
  //     } else if (PRO.userData?.status == 8 || PRO.userData?.status == 2) {
  //       ERROR_SNACK_BAR(
  //           'Perhatian', 'Anda Belum menyelesaikan proses registrasi');
  //       clearField();
  //       await Get.offAll(() => ProfileRegPage());
  //       // pushRemoveUntilScreen(context, screen: ProfileRegPage());
  //     } else {
  //       if (PRO.userData != null) {
  //         if (PRO.userData?.status == 1) {
  //           await Get.offAll(() => KalmMainTab(context: context));
  //         } else if (PRO.userData?.status == 5) {
  //           await Get.offAll(() => VerifyCodePage(resendCode: true));
  //         } else if (PRO.userData?.status == 6) {
  //           await PRO.getStatusFileMandatory();
  //           await Get.offAll(() => ApprovalMandatoryPage());
  //         } else if (PRO.userData?.status == 7) {
  //           await PRO.getStatusFileMandatory();
  //           ERROR_SNACK_BAR(
  //               'Perhatian', 'Anda Belum menyelesaikan proses registrasi');
  //           clearField();
  //           await Get.offAll(() => CounselorUploadMandatoryPage());
  //         } else if (PRO.userData?.status == 9) {
  //           await PRO.getStatusFileMandatory();
  //           await Get.offAll(() => WelcomeCounselorPage());
  //         } else {
  //           clearField();
  //           var _user = UserModel.fromJson(_res?.data).data;
  //           // PR(_res);
  //           await _redirectPage(_user, context: context);
  //         }
  //       } else {
  //         clearField();
  //         var _user = UserModel.fromJson(_res?.data).data;
  //         // PR(_res);
  //         await _redirectPage(_user, context: context);
  //       }
  //     }
  //   } else {
  //     Loading.hide();
  //     return;
  //   }
  // }

  // Future<void> _redirectPage(UserData? _user,
  //     {required BuildContext context}) async {
  //   switch (_user?.status == 1 || _user?.status == 2 || _user?.status == 3) {
  //     case true:
  //       await PRO.saveLocalUser(_user);
  //       if (_user?.userHasActiveCounselor != null) {
  //         await PRO.getCounselor(useLoading: true);
  //       }
  //       Loading.hide();
  //       await Get.offAll(() => KalmMainTab(context: context));
  //       break;
  //     case false:
  //       await PRO.saveLocalUser(_user);
  //       if (_user?.status == 5) {
  //         Loading.hide();
  //         await Get.offAll(() => VerifyCodePage());
  //       } else if (_user?.status == 6) {
  //         await _getStatusCredential();

  //         // Cms().loading(false);
  //         Get.offAll(() => ApprovalMandatoryPage());
  //       } else if (_user?.status == 7) {
  //         await _getStatusCredential();
  //         // Cms().loading(false);
  //         Get.offAll(() => CounselorUploadMandatoryPage());
  //       } else if (_user?.status == 8) {
  //         // Cms().loading(false);
  //         Get.offAll(() => ProfileRegPage());
  //       } else if (_user?.status == 9) {
  //         // Cms().loading(false);
  //         if (_user?.aboutMe == null) {
  //           Get.offAll(() => const WelcomeNewCounselorPage());
  //         } else {
  //           Get.offAll(() => ServiceInfoPage());
  //         }
  //       } else {
  //         Loading.hide();
  //         return;
  //       }
  //       break;
  //     default:
  //       Loading.hide();
  //       break;
  //   }
  // }
  submit({required BuildContext context}) async {
    // focusNode.forEach((element) {
    //   element.unfocus();
    // });

    // bool _isEmulator = Platform.localHostname == "craniums-MacBook-Pro.local";
    // Cms().loading(true);

    // var _userId = await OnsignalSdk().getPermissionState();

    // final LoginBody _body = LoginBody(
    //     email: textEditingController[0].text,
    //     password: textEditingController[1].text,
    //     role: USER_ROLE,
    //     firebaseToken: FIREBASE_TOKEN,
    //     installationId: _installationId,
    //     deviceNumber: await _deviceIdentify(),
    //     deviceType: Platform.isIOS ? 1 : 0);
    // User _res = User.fromJson(await Api()
    //     .postDatas(endpoint: LOGIN_API, payload: _body.toJson(), errorMessagePage: "Try Login")
    //     .catchError((e) async {
    //   return jsonDecode(e);
    // }));
    final deviceNum = await _deviceNum();
    if (deviceNum == null) {
      return;
    }
    final _installationId = await WonderPush.getInstallationId();
    // if (_installationId == null) {
    //   ERROR_SNACK_BAR('Perhatian',
    //       "Anda tidak mengizinkan fitur Notifikasi di ponsel Anda\n Silahkan restart aplikasi KALM untuk mengaktifkan notifikasi kembali");
    //   return;
    // }

    var _firebaseToken = await PRO.firebaseAuth.currentUser?.getIdToken();
    var _payload = LoginPayload(
      email: emailField.text,
      password: passwodField.text,
      deviceNumber: deviceNum,
      // installationId: _installationId,
      deviceType: Platform.isAndroid ? 0 : 1,
      firebaseToken: _firebaseToken,
      role: "20",
    );
    WrapResponse? _resData = await Api().POST(AUTH, _payload.toJson());

    if (_resData?.statusCode == 200) {
      emailField.clear();
      passwodField.clear();
      emailFocus.unfocus();
      passwordFocus.unfocus();
      update();
      UserModel _user = UserModel.fromJson(_resData?.data);
      // print("onesignal token ${_userId.subscriptionStatus.userId}");
      // await PRO.clearAllDataWithoutNavigation();
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
            // await PRO.saveLocalUser(_user.data);
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
            await pushReplacementNewScreen(context, screen: LoginPage());
          }
        } else {
          await pushReplacementNewScreen(context, screen: LoginPage());
        }
      }
    } else {
      Loading.hide();

      snackBars(message: _resData?.message ?? "");
    }
  }

// Future<List> _getStatusCredential() async {
//   var _resData = await Api()
//       .GET(APPROVAL_MANDATORY_FILES, useToken: true, useLoading: false);
//   var _res = UserModel.fromJson(_resData?.data);
//   if (_res.status == 200) {
//     PRO.setUserSession(data: _res);
//     return [true, (_res.message ?? "")];
//   } else {
//     return [false, (_res.message ?? "")];
//   }
// }
}
