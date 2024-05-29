import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';

import '../../api/api.dart';
import '../../color/colors.dart';
import '../../controller/global/user_controller.dart';
import '../../model/installation_id_model.dart';
import '../../model/user_model/user_model.dart';
import '../../widget/box_border.dart';
import '../../widget/loading.dart';
import '../../widget/snack_bar.dart';
import '../../widget/space.dart';
import '../../widget/text.dart';

class NotificationPage extends StatelessWidget {
  final _controller = Get.put(NotificationController());

  NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(PRO.userData?.userNotificationSetting?.toJson());
    return GetBuilder<NotificationController>(builder: (_) {
      return SAFE_AREA(
          context: context,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SPACE(height: 20),
                  _options(
                      "Email Saya",
                      "Ketika Kalmselor Mengirimi saya pesan",
                      _.emailController(context)),
                  SPACE(height: 20),
                  _options(
                      "Push Notification",
                      "Ketika Kalmselor Mengirimi saya pesan",
                      _.notifController(context)),
                ],
              ),
            ),
          ));
    });
  }

  Column _options(String title, String content, bool isActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TEXT(title, style: titleApp20),
        SPACE(),
        InkWell(
          onTap: () async {
            await _controller.onChange(
                title == "Email Saya", title == "Push Notification");
          },
          child: BOX_BORDER(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  BOX_BORDER(
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          color: isActive ? ORANGEKALM : Colors.white,
                          margin: const EdgeInsets.all(0),
                        ),
                      ),
                      height: 20,
                      width: 20,
                      circularRadius: 2),
                  SPACE(),
                  TEXT(content,
                      style: Get.textTheme.subtitle2,
                      textOverflow: TextOverflow.visible)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationController extends GetxController {
  bool emailController(BuildContext context) {
    try {
      return STATE(context).userData?.userSetting?.emailClientSendMessage == 1;
    } catch (e) {
      return false;
    }
  }

  bool notifController(BuildContext context) {
    try {
      return STATE(context)
              .userData
              ?.userSetting
              ?.notificationClientSendMessage ==
          1;
    } catch (e) {
      return false;
    }
  }

  Future<void> onChange(bool isEmail, isNotif) async {
    if (isEmail) {
      bool isActive = PRO.userData?.userSetting?.emailClientSendMessage == 1;
      var _res = await Api().POST(
          EMAIL_SUBSCRIPTION, {'value': isActive ? 0 : 1},
          useToken: true);
      if (_res?.statusCode == 200) {
        await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
        Loading.hide();
      } else {
        Loading.hide();
        return;
      }
    } else {}
    if (isNotif) {
      await WonderPush.subscribeToNotifications();
      await WonderPush.getInstallationId();
      await requestPermission();
      bool isActive =
          PRO.userData?.userSetting?.notificationClientSendMessage == 1 &&
              await Permission.notification.isGranted;
      await postInstallationId();
      var _res = await Api().POST(
          NOTIF_SUBSCRIPTION, {'value': isActive ? 0 : 1},
          useToken: true);
      await Permission.notification.isGranted
          ? WonderPush.subscribeToNotifications()
          : WonderPush.unsubscribeFromNotifications();
      if (_res?.statusCode == 200) {
        if (await Permission.notification.isPermanentlyDenied) {
          openAppSettings();
          requestPermission();
        }
        await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
        Loading.hide();
      } else {
        if (await Permission.notification.isPermanentlyDenied) {
          openAppSettings();
          requestPermission();
        }
        Loading.hide();
        return;
      }
    } else {
      if (await Permission.notification.isPermanentlyDenied) {
        openAppSettings();
        requestPermission();
      }
    }
  }

  Future<void> postInstallationId() async {
    print("------sending installation id------");
    var _installationId = await WonderPush.getInstallationId();
    var _payload = InstallationIdPayload(
        installationId: _installationId, userCode: PRO.userData?.code);
    var _res = await Api().POST(
      INSTALLATION_ID,
      _payload.toJson(),
      useToken: true,
      useLoading: true,
    );
    if (_res?.statusCode == 200) {
      print("------installation id sent!------");
      Loading.hide();
    } else {
      openAppSettings();
    }
  }

  Future<void> requestPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      var result = await Permission.notification.request();
      var isPermanentlyDenied = result.isPermanentlyDenied;
      if (result.isGranted) {
        SUCCESS_SNACK_BAR("Success", 'Notification status changed');
      } else if (isPermanentlyDenied) {
        openAppSettings();
      }
    } else if (status.isGranted) {
      SUCCESS_SNACK_BAR("Success", 'Notification status changed');
    }
  }
}


// class Contoh extends StatelessWidget {
//   const Contoh({ Key? key }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<NotificationController>(
//   init: NotificationController(),
//   initState: (_) {

//   },
//   builder: (_) {
//     return ;
//   },
// )
//   }
// }