import 'package:connectivity/connectivity.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/main_tab.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoConnectionPage extends StatelessWidget {
  final _controller = Get.put(NoConnectionController());

  NoConnectionPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoConnectionController>(
        dispose: (ds) {},
        initState: (st) async {},
        builder: (_) {
          return NON_MAIN_SAFE_AREA(
              child: SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_outlined,
                  size: 100,
                  color: BLUEKALM,
                ),
                SizedBox(
                  width: Get.width / 1.5,
                  child: BUTTON("Coba Lagi", onPressed: () async {
                    await PRO.updateSession(context: context);
                    await pushRemoveUntilScreen(context,
                        screen: KalmMainTab(context: context),
                        withNavBar: true);
                  }),
                )
              ],
            ),
          ));
        });
  }
}

class NoConnectionController extends GetxController {
  Connectivity connectivity = Connectivity();
}
