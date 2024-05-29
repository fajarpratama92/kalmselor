import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:counselor/model/counselor/client-get-to-know-model.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:get/get.dart';
import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/register_payload.dart';
import 'package:counselor/model/register_tnc_res_model/register_tnc_res_model.dart';
import 'package:counselor/pages/auth/login.dart';
import 'package:counselor/pages/auth/register_tnc.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/textfield.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';

class RegisterPage extends StatelessWidget {
  final _controller = Get.put(RegisterController());

  RegisterPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      initState: (st) async {},
      builder: (_) {
        return SAFE_AREA(
          useAppBar: false,
          context: context,
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
                        Image.asset('assets/icon/register_icon.png',
                            scale: 2.5),
                      SPACE(height: 20),
                      TEXT_FIELD(_.firstNameField,
                          focusNode: _.firstNameFocus,
                          onSubmitted: (val) =>
                              _.onSubmittedFirstName(val, context: context),
                          onChanged: (val) => _.onChangeFirstName(val),
                          prefixIcon: const Icon(Icons.person),
                          hint: 'Nama Depan ( Nama Panggilan )'),
                      SPACE(),
                      if (_.validateFirstName != null) _.validateFirstName!,
                      SPACE(),
                      TEXT_FIELD(_.lastNameField,
                          focusNode: _.lastNameFocus,
                          onSubmitted: (val) =>
                              _.onSubmittedLastName(val, context: context),
                          onChanged: (val) => _.onChangeLastName(val),
                          prefixIcon: const Icon(Icons.person),
                          hint: 'Nama Belakang ( Opsional )'),
                      SPACE(),
                      if (_.validateLastName != null) _.validateLastName!,
                      SPACE(),
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
                      TEXT_FIELD(_.passwodField,
                          obscureText: _.passwordObsecure,
                          onSubmitted: (val) =>
                              _.onSubmittedPassword(val, context: context),
                          focusNode: _.passwordFocus,
                          onChanged: (val) => _.onChangePassword(val),
                          prefixIcon: Icon(_.passwordObsecure
                              ? Icons.lock_outline
                              : Icons.lock_open_outlined),
                          hint: "Password",
                          suffixIcon: IconButton(
                              onPressed: () => _.onChangePasswordObsecure(),
                              icon: Icon(_.passwordObsecure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility))),
                      SPACE(),
                      if (_.validatePassword != null) _.validatePassword!,
                      SPACE(),
                      TEXT_FIELD(_.rePasswordField,
                          obscureText: _.rePasswordObsecure,
                          onSubmitted: (val) =>
                              _.onSubmittedRePassword(val, context: context),
                          focusNode: _.rePasswordFocus,
                          onChanged: (val) => _.onChangeRePassword(val),
                          prefixIcon: Icon(_.rePasswordObsecure
                              ? Icons.lock_outline
                              : Icons.lock_open_outlined),
                          hint: "Konfirmasi Password",
                          suffixIcon: IconButton(
                              onPressed: () => _.onChangeRePasswordObsecure(),
                              icon: Icon(_.rePasswordObsecure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility))),
                      SPACE(),
                      if (_.validateRePassword != null) _.validateRePassword!,
                      SPACE(height: 30),
                      BUTTON("Daftar",
                          verticalPad: 15,
                          circularRadius: 30,
                          onPressed: _.validationForm
                              ? () async => await _.submit(context: context)
                              : null),
                      SPACE(height: 20),
                      SizedBox(
                        width: Get.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TEXT("Sudah punya akun?"),
                            InkWell(
                                onTap: () => Get.offAll(() => LoginPage()),
                                child: TEXT("Login",
                                    style: COSTUM_TEXT_STYLE(
                                        color: ORANGEKALM,
                                        fontWeight: FontWeight.w600))),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class RegisterController extends GetxController {
  Widget? validateFirstName,
      validateLastName,
      validateEmail,
      validatePassword,
      validateRePassword;
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode rePasswordFocus = FocusNode();
  TextEditingController firstNameField = TextEditingController();
  TextEditingController lastNameField = TextEditingController();
  TextEditingController emailField = TextEditingController();
  TextEditingController passwodField = TextEditingController();
  TextEditingController rePasswordField = TextEditingController();
  bool passwordObsecure = true;
  bool rePasswordObsecure = true;
  bool get validationForm =>
      (validateFirstName == null &&
          validateEmail == null &&
          validatePassword == null &&
          validateRePassword == null) &&
      (firstNameField.text.isNotEmpty &&
          emailField.text.isNotEmpty &&
          passwodField.text.isNotEmpty &&
          rePasswordField.text.isNotEmpty);

  void onChangePasswordObsecure() {
    passwordObsecure = !passwordObsecure;
    update();
  }

  void onChangeRePasswordObsecure() {
    rePasswordObsecure = !rePasswordObsecure;
    update();
  }

  void onChangeFirstName(String val) {
    if (val.isEmpty) {
      validateFirstName = null;
    } else if (val.length < 4) {
      validateFirstName = ERROR_VALIDATION_FIELD("minimal 4 karakter");
    } else {
      // validateEmail = SUCCESS_VALIDATION_FIELD("Email Terverifikasi");
      validateFirstName = null;
    }
    update();
  }

  void onChangeLastName(String val) {
    if (val.isEmpty) {
      validateLastName = null;
    } else if (val.length < 4) {
      validateLastName = ERROR_VALIDATION_FIELD("minimal 4 karakter");
    } else {
      // validatePassword = SUCCESS_VALIDATION_FIELD("Password Terverifikasi");
      validateLastName = null;
    }
    update();
  }

  void onChangeEmail(String val) {
    if (val.isEmpty) {
      validateEmail = null;
    } else if (!val.isEmail) {
      validateEmail = ERROR_VALIDATION_FIELD("Format email salah");
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

  void onChangeRePassword(String val) {
    if (val.isEmpty) {
      validateRePassword = null;
    } else if (val != passwodField.text) {
      validateRePassword = ERROR_VALIDATION_FIELD("Password tidak sama");
    } else {
      // validateRePassword = SUCCESS_VALIDATION_FIELD("Password Terverifikasi");
      validateRePassword = null;
    }
    update();
  }

  void onSubmittedFirstName(String val, {required BuildContext context}) {
    firstNameFocus.unfocus();
    FocusScope.of(context).requestFocus(lastNameFocus);
  }

  void onSubmittedLastName(String val, {required BuildContext context}) {
    lastNameFocus.unfocus();
    FocusScope.of(context).requestFocus(emailFocus);
  }

  void onSubmittedEmail(String val, {required BuildContext context}) {
    emailFocus.unfocus();
    FocusScope.of(context).requestFocus(passwordFocus);
  }

  void onSubmittedPassword(String val, {required BuildContext context}) {
    passwordFocus.unfocus();
    FocusScope.of(context).requestFocus(rePasswordFocus);
  }

  void onSubmittedRePassword(String val,
      {required BuildContext context}) async {
    if (validationForm) {
      await submit(context: context);
    } else {
      return;
    }
    // rePasswordFocus.unfocus();
    // FocusScope.of(context).requestFocus(rePasswordFocus);
  }

  Future<String?> _installationId() async {
    if (Platform.localHostname == "Fajars-MacBook-PRO.local") {
      return "test-installation";
    } else {
      return await WonderPush.getInstallationId();
    }
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
          return null;
        }
      }
    } catch (e) {
      var rng = math.Random();
      var l = List.generate(8, (_) => rng.nextInt(100));
      return int.parse(l.join(',').replaceAll(',', ''));
    }
  }

  Future<void> submit({required BuildContext context}) async {
    // if (await _installationId() == null) {
    //   ERROR_SNACK_BAR('Perhatian',
    //       "Anda tidak mengizinkan fitur Notifikasi di ponsel Anda\n Silahkan restart aplikasi KALM untuk mengaktifkan notifikasi kembali");
    //   return;
    // } else
      if (await _deviceNum() == null) {
      return;
    }
    var _res = await Api().GET(TERM_AND_CONDITION_CATEGORY);
    try {
      if (_res?.statusCode == 200) {
        var _payload = RegisterPayload(
            firstName: firstNameField.text,
            lastName: lastNameField.text,
            email: emailField.text,
            password: passwodField.text,
            confirmPassword: rePasswordField.text,
            deviceType: Platform.isAndroid ? 0 : 1,
            deviceNumber: await _deviceNum(),
            installationId: await _installationId(),
            tempUserCode: PRO.userTempCode,
            gender: 1,
            language: "id",
            uniqueCodeRequest: "",
            role: "20");
        PRO.updateRegisterPayload(_payload);
        PRO.analyticObserver.analytics.logSignUp(signUpMethod: 'E-mail');
        Loading.hide();
        // Get.to(RegisterTncPage(
        //     registerTncResModel: RegisterTncResModel.fromJson(_res?.data)));
        pushNewScreen(context,
            screen: RegisterTncPage(
                registerTncResModel: RegisterTncResModel.fromJson(_res?.data)));
      } else {
        Loading.hide();
        return;
      }
    } catch (e) {
      Loading.hide();
      return;
    }
  }
}
