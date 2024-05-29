import 'dart:io';
import 'package:counselor/pages/auth/how_to_use_auth.dart';
import 'package:counselor/pages/auth/sop_confirm.dart';
import 'package:counselor/pages/setting_page/notification.dart';
import 'package:counselor/pages/setting_page/payment_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/api/api.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/pages/setting_page/about_us.dart';
import 'package:counselor/pages/setting_page/account.dart';
import 'package:counselor/pages/setting_page/contact_us.dart';
import 'package:counselor/pages/setting_page/faq.dart';
import 'package:counselor/pages/setting_page/how_to_use.dart';
import 'package:counselor/pages/setting_page/packages.dart';
import 'package:counselor/pages/setting_page/pin_code.dart';
import 'package:counselor/pages/setting_page/privacy_policy.dart';
import 'package:counselor/pages/setting_page/profile.dart';
import 'package:counselor/pages/setting_page/term_and_condition.dart';
import 'package:counselor/utilities/deep_link_redirect.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/dialog.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'dart:math' as math;

class SettingPage extends StatelessWidget {
  final _controller = Get.put(SettingController());

  SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (_) {
      return SAFE_AREA(
          context: context,
          canBack: false,
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Column(
                      children: _.buttonTitle.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                            onTap: () async => await _.onPress(e, context),
                            child: SizedBox(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TEXT(e),
                                      Transform.rotate(
                                        angle: math.pi,
                                        child: const Icon(
                                            Icons.arrow_back_ios_new,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                      thickness: 1, color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SPACE(),
                    SizedBox(
                      width: Get.width / 1.3,
                      child: BUTTON(
                        "Keluar",
                        circularRadius: 30,
                        verticalPad: 15,
                        onPressed: () async {
                          await SHOW_DIALOG(
                            "Apakah Anda yakin akan keluar dari akun ini?",
                            onAcc: () async {
                              Get.back();
                              try {
                                await Api().POST(LOGOUT, {}, useToken: true);
                                PRO.updateInitialIndexTab(0);
                                Loading.hide();
                                await PRO.clearAllData();
                              } catch (e) {
                                Loading.hide();
                                return;
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SPACE(),
                    TEXT("APP VERSION"),
                    SPACE(),
                    TEXT(STATE(context).APP_VERSION,
                        style: COSTUM_TEXT_STYLE(color: Colors.grey))
                  ],
                ),
              ),
            ],
          ));
    });
  }
}

class SettingController extends GetxController {
  List<String> buttonTitle = [
    'Tentang KALM',
    'Akun',
    'Profil',
    'Pin Code',
    'Informasi Pembayaran',
    'Notifikasi',
    'FAQ',
    'Cara Penggunaan',
    'SOP',
    'Kebijakan Privasi',
    'Syarat dan Ketentuan',
    'Hubungi Kami',
    'Dukung Kami',
    // 'Theme (Developer Preview)',
  ];

  Future<void> onPress(String title, BuildContext context) async {
    switch (title) {
      case "Tentang KALM":
        if (PRO.aboutResModel == null) {
          await PRO.getAboutUs();
          Loading.hide();
          await pushNewScreen(context, screen: AboutUsPage());
        } else {
          await pushNewScreen(context, screen: AboutUsPage());
        }
        break;
      case "Akun":
        await pushNewScreen(context, screen: AccountPage());
        break;
      case "Profil":
        // if (PRO.userData?.status != 1) {
        //   await SHOW_DIALOG(
        //       "Pastikan Anda telah melengkapi data Kuisioner di menu chat",
        //       onAcc: () {
        //     Get.back();
        //     PRO.updateInitialIndexTab(2);
        //   });
        //   return;
        // }
        await pushNewScreen(context, screen: ProfilePage());
        break;
      case "Informasi Pembayaran":
        // await pushNewScreen(context, screen: PaymentInformationPage());
        // Get.to(() => PaymentInformationPage());
        pushNewScreen(context, screen: PaymentInformationPage());
        // if (PRO.subscriptionListResModel != null) {
        //   await pushNewScreen(context, screen: PackagesPage());
        // } else {
        //   await PRO.getSubSubcriptionList();
        //   Loading.hide();
        //   await pushNewScreen(context, screen: PackagesPage());
        // }
        break;
      case "Notifikasi":
        await pushNewScreen(context, screen: NotificationPage());
        break;
      case "FAQ":
        if (PRO.faqResModel == null) {
          await PRO.getFaq();
          Loading.hide();
          await pushNewScreen(context, screen: FaqPage());
        } else {
          await pushNewScreen(context, screen: FaqPage());
        }
        break;
      case "Cara Penggunaan":
        if (PRO.howToResModel == null) {
          await PRO.getHowTo();
          Loading.hide();
          await pushNewScreen(context, screen: HowToUseAuthPage());
        } else {
          await pushNewScreen(context, screen: HowToUseAuthPage());
        }
        break;
      case "SOP":
        await pushNewScreen(context, screen: SopConfirmPage());
        break;
      case "Pin Code":
        await pushNewScreen(context, screen: PincodePage());
        break;
      case "Kebijakan Privasi":
        if (PRO.privacyPolicyResModel == null) {
          await PRO.getPrivacyPolicy();
          Loading.hide();
          await pushNewScreen(context, screen: PrivacyPolicyPage());
        } else {
          await pushNewScreen(context, screen: PrivacyPolicyPage());
        }
        break;
      case "Syarat dan Ketentuan":
        if (PRO.termAndConditionResModel == null) {
          await PRO.getTermAndCondition();
          Loading.hide();
          await pushNewScreen(context, screen: TermAndConditionPage());
        } else {
          await pushNewScreen(context, screen: TermAndConditionPage());
        }
        break;
      case "Hubungi Kami":
        if (PRO.contactUsResModel == null) {
          await PRO.getContactUs();
          Loading.hide();
          await pushNewScreen(context, screen: ContactUsPage());
        } else {
          await pushNewScreen(context, screen: ContactUsPage());
        }
        break;
      case 'Dukung Kami':
        await GO_TO_STORE();
        break;
      // case "Dukung Kami AppStore":
      //   await GO_TO_STORE();
      //   break;
      default:
        Loading.hide();
    }
  }
}
