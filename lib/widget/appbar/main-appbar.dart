import 'package:counselor/widget/safe_area.dart';
import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../color/colors.dart';
import '../persistent_tab/persistent_tab_util.dart';

class CustomScaffold {
  scaffold({
    required BuildContext context,
    required body,
    double? actionIconSize,
    Icon? actionIcon,
    Function()? actionOnPressed,
    PreferredSizeWidget? preferredSizeWidget,
    PreferredSizeWidget? bottomPreferredSizeWidget,
    Color? backgroundColor,
    bool useKalmselorIcon = true,
    bool userNotifIcon = true,
  }) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      appBar: preferredSizeWidget ??
          appBar(
            useKalmselorIcon: useKalmselorIcon,
            actionIcon: actionIcon,
            iconSize: actionIconSize!,
            userNotifIcon: userNotifIcon,
            bottomPreferredSizeWidget: bottomPreferredSizeWidget,
            context: context,
          ),
      body: body,
    );
  }

  appBar(
      {Icon? actionIcon,
      required double iconSize,
      required bool userNotifIcon,
      required bool useKalmselorIcon,
      PreferredSizeWidget? bottomPreferredSizeWidget,
      required BuildContext context}) {
    return AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.grey),
        centerTitle: true,
        actions: [
          if (userNotifIcon)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 5),
              child: IconButton(
                  iconSize: 20,
                  icon: actionIcon ??
                      const ImageIcon(
                        AssetImage("assets/others/bell.png"),
                        color: BLUEKALM,
                      ),
                  onPressed: () {
                    pushNewScreen(context,
                        screen: const NotificationListPage());
                  }),
            ),
        ],
        title: useKalmselorIcon
            ? Image.asset(
                APP_ICON,
                scale: 5,
              )
            : Container(),
        bottom: bottomPreferredSizeWidget
        // ?? PreferredSize(child: Container(), preferredSize: Size(double.infinity, 10)),
        );
  }
}

class NotificationListPage extends StatelessWidget {
  const NotificationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: SAFE_AREA(
        context: context,
        useNotification: false,
        child: Builder(
          builder: (context) {
            return const Center(child: Text("Tidak ada notifikasi"));
          },
        ),
      ),
    );
  }
}
