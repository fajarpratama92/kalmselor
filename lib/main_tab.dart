import 'dart:async';

import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/pages/counselor/counselor_questioner_introduction_page.dart';
import 'package:counselor/pages/questioner_page.dart/user_questioner_match_up_page.dart';
import 'package:counselor/pages/setting_page/notification.dart';
import 'package:counselor/tab_pages/chat_page.dart';
import 'package:counselor/tab_pages/discovery_page.dart';
import 'package:counselor/tab_pages/home_page.dart';
import 'package:counselor/tab_pages/setting_page.dart';
import 'package:counselor/widget/curved_nav_bar.dart';
import 'package:counselor/widget/persistent_tab/persistent_kalm_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';


@override
GetBuilder<KalmAppController> KalmMainTab({required BuildContext context}) {
  late StreamSubscription<bool> keyboardSubscription;
  return GetBuilder<KalmAppController>(initState: (st) async {
    await PRO.checkAppVersion();
    await PRO.getCounselorClientList(PRO.userData!.code!);
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen(
      (bool visible) {
        PRO.updateKeyboardVisibility(visible);
      },
    );
    await PRO.userBadgesReference(PRO.userData!.code);
    await PRO.setUserProperty();
    PRO.matchupRef.onValue.listen(
      (event) async {
        await PRO.updateSession(context: context);
      },
    );
    //     keyboardVisibilityController.onChange.listen((visible) {
    //   TAB_CONTROLER().setKeyboardListener(show: visible);
    // });
  }, builder: (_) {
    return Container(
      color: BLUEKALM,
      child: SafeArea(
        top: false,
        bottom: false,
        minimum: const EdgeInsets.only(bottom: 5),
        child: PersistentTabView.custom(
          context,
          backgroundColor: Colors.transparent,
          bottomScreenMargin: 0,
          handleAndroidBackButtonPress: true,
          onWillPop: (v) => _.onWillpop(),
          controller: PRO.tabController,
          confineInSafeArea: false,
          screens: _.pages(context),
          customWidget: _navBar(_, context),
          itemCount: _.pages(context).length,
        ),
      ),
    );
  });
}

Builder _navBar(KalmAppController _, BuildContext context) {
  return Builder(
    builder: (context) {
      return CurvedNavigationBar(
        items: <String>[
          "assets/tab/home.png",
          _chatBadge(context),
          "assets/tab/discovery.png",
          "assets/tab/setting.png"
        ],
        itemsTitle: const <String>[
          "Home",
          "Chat",
          "Resource",
          "Setting",
        ],
        onTap: (index) => PRO.onChangeTab(index),
        index: STATE(context).tabController.index,
        // height: 60,
      );
    },
  );
}

String _chatBadge(context) {
  return STATE(context).newBadge
      ? "assets/tab/badge-chat.png"
      : "assets/tab/chat.png";
}

class KalmAppController extends GetxController {
  Future<bool> onWillpop() async {
    return await Future.value(true);
  }

  List<Widget> pages(BuildContext context) {
    return [HomePage(), CounselorChatPage(), DiscoveryPage(), SettingPage()];
  }

  Widget page3(BuildContext context) {
    if (STATE(context).statusTestDebug != null) {
      switch (STATE(context).statusTestDebug) {
        case 5:
          return CounselorQustionerIntroductionPage(isFromWelcome: true);
        case 2:
          return UserQustionerMatchupPage();
        default:
          return CounselorChatPage();
      }
    } else {
      return CounselorChatPage();
    }
  }

  List<Widget> items(BuildContext context) {
    return [
      Image.asset("assets/tab/home.png", scale: 3),
      Image.asset(_chatBadge(context), scale: 3),
      Image.asset("assets/tab/discovery.png", scale: 3),
      Image.asset("assets/tab/setting.png", scale: 3),
    ];
  }

  // int selectedIndex = 0;

  Future<void> _updateRead() async {
    var _snap =
        PRO.database.ref("chats/${PRO.counselorData?.matchupId ?? "100111"}");
    var _getRead = await _snap
        .orderByChild("code")
        // .equalTo("CONS-210409025411162")
        .equalTo(PRO.counselorData?.counselor?.code)
        .once();
    var _chatModel = Map<String, dynamic>.from(
        _getRead.snapshot.value as Map<Object?, Object?>);
    _chatModel.forEach(
      (key, value) {
        _snap.child(key).child("status").set("read");
      },
    );
  }
}
