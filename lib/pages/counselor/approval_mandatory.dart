import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/user_model/user_data.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/pages/auth/login.dart';
import 'package:counselor/pages/auth/welcome_counselor.dart';
import 'package:counselor/widget/box_border.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/dialog.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApprovalMandatoryPage extends StatelessWidget {
  final _controller = Get.put(ApprovalMandatoryController());

  ApprovalMandatoryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return POP_SCREEN_DIALOG(
      content: "Apakah Anda yakin ingin keluar dari halaman ini?",
      onConfirm: () async {
        await PRO.removeTempCode();
        await Get.offAll(() => LoginPage());
      },
      child: SAFE_AREA(
        bottomPadding: PRO.userData?.status == 1 ? null : 0,
        context: context,
        canBack: true,
        useNotification: PRO.userData?.status == 1 ? true : false,
        onBackPressed: PRO.userData?.status == 1
            ? null
            : () async {
                await SHOW_DIALOG(
                    "Apakah Anda yakin ingin keluar dari halaman ini?",
                    onAcc: () async {
                  await PRO.removeTempCode();
                  await Get.offAll(() => LoginPage());
                });
                // await PRO.removeTempCode();
                // await Get.offAll(() => LoginPage());
              },
        // useAppBar: false,
        child: GetBuilder<ApprovalMandatoryController>(
          initState: (st) {
            // print(PRO.userData?.status); // 6
          },
          builder: (_) {
            return SizedBox(
              // width: Get.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SPACE(height: 20),
                      _refresh(_),
                      SPACE(height: 20),
                      TEXT("Menunggu Verifikasi", style: titleApp20),
                      SPACE(height: 20),
                      TEXT(
                          "Mohon menunggu. Kami akan menghubungi\nAnda dalam 2x24 jam melalui e-mail dan/\natau telepon",
                          textAlign: TextAlign.center),
                      SPACE(),
                      BOX_BORDER(Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TEXT("Dokumen Kredensial", style: titleApp20),
                        ),
                      )),
                      SPACE(height: 20),
                      _files(context, _),
                      SPACE(),
                      SizedBox(
                        width: Get.width / 1.6,
                        child: BUTTON(
                          "Selanjutnya",
                          onPressed: _.validationCredential(context)
                              ? () async => await _.submit()
                              : null,
                          verticalPad: 10,
                          circularRadius: 20,
                        ),
                      ),
                      SPACE(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  InkWell _refresh(ApprovalMandatoryController _) {
    return InkWell(
      onTap: () async => await _.getStatus(),
      child: BOX_BORDER(
          Row(
            children: [
              RotationTransition(
                turns:
                    Tween(begin: 0.0, end: 1.0).animate(_.animationController),
                child: Image.asset(
                  'assets/icon/reload.png',
                  scale: 7,
                  color: BLUEKALM,
                ),
              ),
              SPACE(),
              TEXT("Perbarui",
                  style: COSTUM_TEXT_STYLE(fontWeight: FontWeight.bold))
            ],
          ),
          width: Get.width / 2.7,
          circularRadius: 30),
    );
  }

  Column _files(BuildContext context, ApprovalMandatoryController _) {
    return Column(
      children: List.generate(
          STATE(context).userData?.counselorMandatoryFiles?.length ?? 0, (i) {
        var _data = STATE(context).userData?.counselorMandatoryFiles![i];
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: Get.width / 1.8,
                    child: TEXT(_data!.name, style: titleApp20)),
                Expanded(
                  child: InkWell(
                    onTap: () async => await _.showFile(_data),
                    child: BOX_BORDER(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TEXT(_.statusFile(_data.status),
                                  style: COSTUM_TEXT_STYLE(
                                      color: _.statusTextColor(_data.status),
                                      fontWeight: FontWeight.bold)),
                              _.statusIcon(_data.status),
                            ],
                          ),
                        ),
                        fillColor: _.statusFillColor(_data.status)),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1),
          ],
        );
      }),
    );
  }
}

class ApprovalMandatoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Animation<double>? animation;
  late AnimationController animationController;

  bool validationCredential(BuildContext context) {
    try {
      return STATE(context)
          .userData!
          .counselorMandatoryFiles!
          .where((e) => e?.isMandatory == 1)
          .every(
        (e) {
          return e?.status == 1;
        },
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> getStatus() async {
    animationController.forward();
    await PRO.getStatusFileMandatory();
    animationController.reset();
  }

  Color statusTextColor(int? status) {
    switch (status) {
      case 1:
        return Colors.white;
      case 5:
        return BLUEKALM;
      default:
        return Colors.white;
    }
  }

  Color statusFillColor(int? status) {
    switch (status) {
      case 1:
        return BLUEKALM;
      case 5:
        return Colors.white;
      default:
        return Colors.red;
    }
  }

  Widget statusIcon(int? status) {
    switch (status) {
      case 1:
        return Image.asset("assets/icon/accept.png", scale: 6);
      case 5:
        return Image.asset(
          "assets/icon/reload.png",
          scale: 10,
          color: ORANGEKALM,
        );

      default:
        return Image.asset(
          "assets/icon/decline.png",
          scale: 6,
          color: Colors.white,
        );
    }
  }

  String statusFile(int? status) {
    switch (status) {
      case 1:
        return "Disetujui";
      case 5:
        return "Ditinjau";
      case 0:
        return "Ditolak";
      default:
        return "Ditinjau";
    }
  }

  Future<void> showFile(CounselorMandatoryFiles? _data) async {
    await Get.dialog(
      Center(
        child: BOX_BORDER(
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.network("$COUNSELOR_IMAGE_URL${_data?.file}",
                  fit: BoxFit.fitHeight),
            ),
            fillColor: Colors.white,
            height: Get.height / 2,
            width: Get.width / 1.2,
            circularRadius: 0),
      ),
    );
  }

  Future<void> submit() async {
    var _res = await Api().POST(UPDATE_STATUS, {"status": 9}, useToken: true);
    // PR(_res?.data);
    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
      Loading.hide();
      Get.off(WelcomeCounselorPage());
    } else {
      Loading.hide();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    animationController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInCirc);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }
}
