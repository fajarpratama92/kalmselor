import 'dart:ui';

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/main_tab.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/pages/auth/login.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/dialog.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounselorTncPage extends StatelessWidget {
  CounselorTncPage({Key? key}) : super(key: key);
  final _controller = Get.put(CounselorTncController());

  @override
  Widget build(BuildContext context) {
    if (STATE(context).userData?.status == 1) {
      return _body(context: context);
    }
    return POP_SCREEN_DIALOG(
      content: "Apakah Anda yakin ingin keluar dari halaman ini?",
      onConfirm: PRO.userData?.status == 1
          ? () => Navigator.canPop(context)
          : () async {
              await PRO.removeTempCode();
              await Get.offAll(() => LoginPage());
            },
      child: _body(context: context),
    );
  }

  _body({required BuildContext context}) {
    return SAFE_AREA(
      // harusnya 7
      bottomPadding: PRO.userData?.status == 1 ? null : 0,
      context: context,
      canBack: true,
      useNotification: PRO.userData?.status == 1 ? true : false,
      // useLogo: PRO.userData?.status == 1 ? true : false,
      onBackPressed: PRO.userData?.status == 1
          ? null
          : () async {
              await SHOW_DIALOG(
                  "Apakah Anda yakin ingin keluar dari halaman ini?",
                  onAcc: () async {
                await PRO.removeTempCode();
                await Get.offAll(() => LoginPage());
              });
            },
      // useAppBar: false,
      child: GetBuilder<CounselorTncController>(
        initState: (st) async {},
        builder: (_) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SPACE(height: 20),
                    TEXT("PERSETUJUAN\nKALMSELOR-KLIEN",
                        style: COSTUM_TEXT_STYLE(
                            fontWeight: FontWeight.w800, fonstSize: 25),
                        textAlign: TextAlign.center),
                    SPACE(height: 5),
                    TEXT(
                        "Klien yang Anda terima akan melihat dan\nmenyetujui informasi ini sebelum memulai\nkonseling.",
                        textAlign: TextAlign.center),
                    SPACE(),
                    Column(children: _.formTnc),
                    SPACE(height: 5),
                    InkWell(
                      onTap: () => _.addField(),
                      child: const CircleAvatar(
                        minRadius: 40,
                        backgroundColor: BLUEKALM,
                        child: Icon(
                          Icons.add,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SPACE(),
                    SizedBox(
                      width: Get.width / 1.5,
                      child: BUTTON(
                        "Selanjutnya",
                        onPressed: () async => await _.submit(context: context),
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
    );
  }
}

class CounselorTncController extends GetxController {
  int tncLengthForm = 1;
  List<TextEditingController> editingJobTimeController = [
    TextEditingController()
  ];
  List<TextEditingController> editingDescController = [TextEditingController()];
  final String _desc =
      "Sesi chat saya dengan Anda tidak akan menggunakan waktu yang seketika, namun saya akan berusaha untuk membalas Anda secepatnya. Meskipun Anda bisa mengirimkan saya pesan kapan saja dan sesering apapun, namun jam kerja saya adalah antara 8 pagi - 8 malam WIB dan saya akan membalas pesan Anda dalam jam-jam tersebut. Saya tidak akan dapat merespon kepada keadaan mendesak dalam tepat waktu. Karena platform konseling online tidak memungkinkan untuk situasi darurat, krisis atau berbahaya, maka jika Anda menemukan diri Anda di dalam situasi tersebut, mohon segera hubungi 119 atau ke rumah sakit terdekat.";
  List<Column> formTnc = [];

  bool get validationTnc {
    return editingJobTimeController[0].text.isNotEmpty &&
        editingDescController[0].text.isNotEmpty;
  }

  List<Column> textfield() {
    List<Column> tncForm = [];
    for (var i = 0; i < tncLengthForm; i++) {
      tncForm.add(
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: BLUEKALM,
                      ),
                    ),
                    placeholder: "Waktu Kerja dan Situasi Darurat",
                    controller: editingJobTimeController[i],
                  ),
                ),
                if (i > 0)
                  IconButton(
                    onPressed: () => removeField(i),
                    icon: const Icon(
                      Icons.delete,
                      color: BLUEKALM,
                    ),
                  ),
              ],
            ),
            SPACE(),
            CupertinoTextField(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: BLUEKALM)),
              placeholder: _desc,
              controller: editingDescController[i],
              maxLines: 15,
              minLines: 10,
            ),
            SPACE(height: 20),
          ],
        ),
      );
    }
    return tncForm;
  }

  List<TncStoreModel> get payload {
    return List.generate(
      editingJobTimeController.length,
      (i) {
        return TncStoreModel(
          name: editingJobTimeController[i].text,
          nameEn: editingJobTimeController[i].text,
          description: editingDescController[i].text,
          descriptionEn: editingDescController[i].text,
          order: i + 1,
        );
      },
    );
  }

  void addField() {
    editingDescController.add(TextEditingController());
    editingJobTimeController.add(TextEditingController());
    tncLengthForm = tncLengthForm + 1;
    formTnc = textfield();
    update();
  }

  void removeField(int i) {
    editingDescController.removeAt(i);
    editingJobTimeController.removeAt(i);
    tncLengthForm = tncLengthForm - 1;
    formTnc = textfield();
    update();
  }

  Future<void> submit({required BuildContext context}) async {
    if (!validationTnc) {
      snackBars(
          message: "Buat minimal 1 poin persetujuan antara Anda dan Klien");
      return;
    }
    var _fixPayload = payload;
    _fixPayload.removeWhere((e) => e.name == null || e.name == "");
    var _res = await Api().POST(
      COUNSELOR_STORE_TERM_CONDITION,
      {
        "data": _fixPayload.map((e) => e.toJson()).toList(),
      },
      useToken: true,
    );
    if (_res?.statusCode == 200) {
      await updateUserStatus(context: context);
    } else {
      Loading.hide();
      snackBars(message: "${_res?.message}");
      return;
    }
  }

  Future<void> updateUserStatus({required BuildContext context}) async {
    var _res = await Api().POST(UPDATE_STATUS, {"status": 1}, useToken: true);
    // PR(_res?.data);
    if (_res?.statusCode == 200) {
      await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
      if (PRO.tabController.index == 3) {
        await snackBars(
            message:
                "${_res?.message == "OK" ? "Update success" : _res?.message}");
      }
      await Get.offAll(() => KalmMainTab(context: context));
    } else {
      Loading.hide();
      snackBars(message: "${_res?.message}");
      return;
    }
  }

  changeValueTesting() {
    editingJobTimeController[0].text = "Testing";
    editingDescController[0].text = "Testing";
  }

  Future getTnc() async {
    var _res = await Api().GET(COUNSELOR_TERM_CONDITION, useToken: true);
    if (_res?.statusCode == 200) {
      Map<String, dynamic> resTnc = _res!.data!;
      List<TncStoreModel> listTnc = [];
      for (var item in resTnc["data"]) {
        listTnc.add(TncStoreModel.fromJson(item));
      }
      if (listTnc.isNotEmpty) {
        editingJobTimeController = [];
        editingDescController = [];
        for (var i = 0; i < listTnc.length; i++) {
          editingJobTimeController.add(TextEditingController(
            text: listTnc[i].name,
          ));
          editingDescController.add(TextEditingController(
            text: listTnc[i].description,
          ));
        }
        tncLengthForm = listTnc.length;
        formTnc = textfield();
      } else {
        editingJobTimeController = [];
        editingDescController = [];
        editingJobTimeController.add(TextEditingController());
        editingDescController.add(TextEditingController());
        tncLengthForm = 1;
        formTnc = textfield();
      }
      update();
      Loading.hide();
    } else {
      Loading.hide();
      return;
    }
  }

  @override
  void onInit() async {
    formTnc = textfield();
    await getTnc();
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<CounselorTncController>();
    super.onClose();
  }
}

class TncStoreModel {
  int? id;
  String? name;
  String? nameEn;
  String? description;
  String? descriptionEn;
  int? order;

  TncStoreModel({
    this.id,
    this.name,
    this.nameEn,
    this.description,
    this.descriptionEn,
    this.order,
  });

  TncStoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    nameEn = json['name_en'] ?? "";
    description = json['description'] ?? "";
    descriptionEn = json['description_en'] ?? "";
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name ?? "";
    data['name_en'] = nameEn ?? "";
    data['description'] = description ?? "";
    data['description_en'] = descriptionEn ?? "";
    data['order'] = order;
    return data;
  }
}
