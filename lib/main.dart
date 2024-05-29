import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/main_tab.dart';
import 'package:counselor/pages/auth/login.dart';
import 'package:counselor/pages/auth/profile_reg.dart';
import 'package:counselor/pages/auth/register.dart';
import 'package:counselor/pages/auth/verify_code.dart';
import 'package:counselor/pages/auth/welcome_counselor.dart';
import 'package:counselor/pages/counselor/upload_mandatory_2.dart';
import 'package:counselor/pages/setting_page/pin_code.dart';
import 'package:counselor/sdk/firebase.dart';
import 'package:counselor/splash_screen.dart';
import 'package:counselor/translation/translation.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
    _enableRotation();
    await _runApp();
  } else {
    Firebase.app();
    await Firebase.initializeApp(
        name: Platform.isIOS ? "kalmselor" : "kalmselor",
        options: Platform.isIOS ? iosFirebaseOption : androidFirebaseOption);
    _enableRotation();
    await _runApp();
  }
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future<void> _runApp() async {
  if (await checkNetwork() == ConnectivityResult.none) {
    runApp(
      _deviceNotCompatible(
        "Pastikan Anda terhubung ke Internet",
        "Coba Lagi",
        onTap: () async {
          await _runApp();
        },
      ),
    );
    return;
  }

  await GetStorage.init();
  await WonderPush.subscribeToNotifications();
  Loading.hide();
  if (await GetStorage.init()) {
    if (await WonderPush.isSubscribedToNotifications()) {
      if (kDebugMode) {
        WonderPush.setLogging(false);
      }
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserController>(
              create: (_) => UserController(),
            )
          ],
          child: KalmApp(),
        ),
      );
    } else {
      await WonderPush.subscribeToNotifications();
      if (kDebugMode) {
        WonderPush.setLogging(false);
      }
      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<UserController>(
              create: (_) => UserController())
        ],
        child: KalmApp(),
      ));
    }
  } else {
    runApp(
      _deviceNotCompatible(
        "Sorry your device not compatible with this app",
        "EXIT",
        onTap: () {
          exit(0);
        },
      ),
    );
  }
}

MaterialApp _deviceNotCompatible(String title, String buttonTitle,
    {void Function()? onTap}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    navigatorObservers: <NavigatorObserver>[UserController().analyticObserver],
    home: NON_MAIN_SAFE_AREA(
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (buttonTitle == "Coba Lagi")
              const Icon(Icons.wifi_off_outlined, size: 100)
            else
              const Icon(Icons.error_outline_outlined, size: 100),
            SPACE(),
            TEXT(title),
            SPACE(),
            InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: BLUEKALM)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TEXT(buttonTitle),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

class KalmApp extends StatelessWidget {
  final _controller = Get.put(KalmAppController());

  KalmApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onReady: () async {
        PRO.readLocalUser();
        // await PRO.getOrs();
        await PRO.firebaseSignin();
        await PRO.getCounselorQuestioner(useLoading: false, useSnackbar: false);
        await PRO.getClientQuestioner(useLoading: false, useSnackbar: false);
        await PRO.getCountry(useLoading: false, useSnackbar: false);
        // await PRO.getSurvey();
        await PRO.updateSession(useLoading: false, context: context);
        await Future.microtask(
          () async {
            await STARTING(context: context);
          },
        );
      },
      onInit: () async {
        if (Platform.isAndroid) {
          WebView.platform = SurfaceAndroidWebView();
        }
      },
      theme: ThemeData(fontFamily: 'MavenPro'),
      // theme: ThemeData(
      //   textTheme: TextTheme(
      //     caption: TextStyle(
      //         fontFamily: "MavenPro",
      //         fontSize: 16,
      //         color: Colors.blue[300],
      //         fontStyle: FontStyle.italic,
      //         fontWeight: FontWeight.w600),
      //     button: const TextStyle(
      //         fontFamily: "MavenPro",
      //         fontSize: 16,
      //         color: Colors.white,
      //         fontWeight: FontWeight.w600),
      //     bodyText1: const TextStyle(
      //         fontFamily: "MavenPro", fontSize: 16, color: Colors.black54),
      //     bodyText2: const TextStyle(
      //         fontFamily: "MavenPro",
      //         fontSize: 18,
      //         color: BLUEKALM,
      //         fontWeight: FontWeight.w600),
      //     headline1: const TextStyle(
      //         fontFamily: "MavenPro",
      //         fontSize: 20,
      //         fontWeight: FontWeight.w700,
      //         color: BLUEKALM),
      //     headline2: const TextStyle(
      //         fontFamily: "MavenPro",
      //         fontSize: 25,
      //         fontWeight: FontWeight.w700,
      //         color: BLUEKALM),
      //   ),
      // ),

      debugShowCheckedModeBanner: false,
      home: _splashScreen(),
      locale: const Locale('id'),
      translations: Translating(),
      supportedLocales: const <Locale>[
        Locale('en'),
      ],
    );
  }

  Stack _splashScreen() {
    return Stack(
      children: [
        SplashScreen(),
        if (PIN_LOCK != null) PincodePage(isLock: true, createCode: PIN_LOCK)
      ],
    );
  }
}

Future<void> STARTING({
  bool isLock = true,
  required BuildContext context,
}) async {
  if (PIN_LOCK != null && isLock) {
    return;
  } else {
    if (PRO.userTempCode != null) {
      ERROR_SNACK_BAR(
          'Perhatian', 'Anda Belum menyelesaikan proses registrasi');
      // await Get.offAll(ProfileRegPage()); harusnya kesini
      Get.offAll(() => RegisterPage());
    } else if (PRO.userData?.status == 8 || PRO.userData?.status == 2) {
      ERROR_SNACK_BAR(
          'Perhatian', 'Anda Belum menyelesaikan proses registrasi');
      Get.offAll(() => ProfileRegPage());
    } else {
      if (PRO.userData != null) {
        if (PRO.userData?.status == 1) {
          PRO.analyticObserver.analytics.logLogin(loginMethod: "E-Mail");
          // await PRO.getCounselorQuestioner(
          //     useLoading: false, useSnackbar: false);
          Get.offAll(() => KalmMainTab(context: context));
        } else if (PRO.userData?.status == 5) {
          Get.offAll(() => VerifyCodePage(resendCode: true));
        } else if (PRO.userData?.status == 6) {
          await PRO.getStatusFileMandatory();
          // Get.offAll(() => ApprovalMandatoryPage());
          Get.offAll(() => CounselorUploadMandatoryPage());
        } else if (PRO.userData?.status == 7) {
          await PRO.getStatusFileMandatory();
          ERROR_SNACK_BAR(
              'Perhatian', 'Anda Belum menyelesaikan proses registrasi');
          Get.offAll(() => CounselorUploadMandatoryPage());
        } else if (PRO.userData?.status == 9) {
          await PRO.getStatusFileMandatory();
          Get.offAll(() => WelcomeCounselorPage());
        } else {
          Get.offAll(() => LoginPage());
        }
      } else {
        Get.offAll(() => LoginPage());
      }
    }
  }
}
