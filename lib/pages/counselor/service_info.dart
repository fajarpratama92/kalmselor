import 'dart:convert';

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/main_tab.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/widget/button/button.dart';
import 'package:counselor/widget/dialog.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceInfoPage extends StatelessWidget {
  final _controller = Get.put(ServiceInfoController());
  final _desc =
      "Sesi chat saya dengan Anda tidak akan menggunakan waktu yang seketika, namun saya akan berusaha untuk membalas Anda secepatnya. Meskipun Anda bisa mengirimkan saya pesan kapan saja dan sesering apapun, namun jam kerja saya adalah antara 8 pagi - 8 malam WIB dan saya akan membalas pesan Anda dalam jam-jam tersebut. Saya tidak akan dapat merespon kepada keadaan mendesak dalam tepat waktu. Karena platform konseling online tidak memungkinkan untuk situasi darurat, krisis atau berbahaya, maka jika Anda menemukan diri Anda di dalam situasi tersebut, mohon segera hubungi 119 atau ke rumah sakit terdekat.";
  @override
  Widget build(BuildContext context) {
    return SAFE_AREA(
      useAppBar: PRO.userData?.status != 1 ? false : true,
      context: context,
      bottomPadding: PRO.userData?.status != 1 ? 0 : null,
      child: GetBuilder<ServiceInfoController>(
        initState: (st) {
          _controller.initState();
        },
        builder: (_) {
          return Builder(
            builder: (context) {
              if (_.tncStoreModel == null) {
                return Center(child: CustomWaiting().defaut());
              } else {
                return ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    Column(
                      children: [
                        SPACE(height: 20),
                        const Text(
                          "PERSETUJUAN\nKALMSELOR-KLIEN",
                          // style: TEXTSTYLE(
                          //     fontWeight: FontWeight.w900,
                          //     colors: BLUEKALM,
                          //     fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        SPACE(),
                        const Text(
                          "Klien yang Anda terima akan melihat dan\nmenyetujui informasi ini sebelum memulai\nkonseling.",
                          textAlign: TextAlign.center,
                          // style: TEXTSTYLE(),
                        ),
                      ],
                    ),
                    SPACE(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: _.tncStoreModel!.isEmpty
                            ? [Container()]
                            : List.generate(_.tncStoreModel!.length, (i) {
                                return Column(
                                  children: [
                                    CupertinoTextField(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      controller: TextEditingController(
                                          text: _.tncStoreModel![i].name),
                                      // style: TEXTSTYLE(),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      placeholder:
                                          "Waktu Kerja dan Situasi Darurat",
                                      onChanged: (title) {
                                        _.tncStoreModel![i].name = title;
                                      },
                                    ),
                                    SPACE(),
                                    CupertinoTextField(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      // style: TEXTSTYLE(),
                                      controller: TextEditingController(
                                          text:
                                              _.tncStoreModel![i].description),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      textInputAction: TextInputAction.newline,
                                      maxLines: 16,
                                      placeholder: _desc,
                                      onChanged: (desc) {
                                        _.tncStoreModel![i].description = desc;
                                      },
                                    ),
                                    if (i != 0 && PRO.userData?.status != 1)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: BLUEKALM,
                                            ),
                                            onPressed: () => _.removeTnc(i)),
                                      ),
                                    if (i == 0) SPACE(height: 20),
                                    const Divider(thickness: 2)
                                  ],
                                );
                              }),
                      ),
                    ),
                    SPACE(height: 20),
                    GestureDetector(
                      onTap: () => _.addTnc(),
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: BLUEKALM),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SPACE(height: 20),
                    CustomButton(
                      // titleStyle: TEXTSTYLE(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w900,
                      //     colors: Colors.white),
                      onPressed: () => _.storeTnc(context),
                      padHorizontal: 60,
                      title:
                          PRO.userData?.status == 1 ? "Simpan" : "Selanjutnya",
                    ),
                    SPACE(height: 30),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}

// controller----------------------------------------------------------------------------------

class ServiceInfoController extends GetxController {
  List<TncStoreModel>? tncStoreModel;
  TncResModel? tncResModel;
  initState() async {
    if (PRO.userData?.status == 1) {
      try {
        await getTnc();
        tncStoreModel = List.generate(tncResModel!.data!.length, (i) {
          return TncStoreModel.fromJson(tncResModel!.data![i].toJson());
        });
      } catch (e) {
        snackBars(message: "Something Wrong");
      }
    } else {
      tncStoreModel = List.generate(1, (i) => TncStoreModel(id: 0));
      update();
    }
  }

  bool validationForm() {
    return (tncStoreModel?[0].description != "" &&
        tncStoreModel?[0].description != null &&
        tncStoreModel?[0].name != "" &&
        tncStoreModel?[0].name != null);
  }

  addTnc() {
    tncStoreModel?.add(TncStoreModel(id: 0));
    update();
  }

  removeTnc(int index) {
    tncStoreModel?.removeAt(index);
    update();
  }

  Future<void> getTnc() async {
    WrapResponse? _resData = await Api()
        .GET(COUNSELOR_TERM_CONDITION + PRO.userData!.code!, useToken: true);
    TncResModel _res = TncResModel.fromJson(_resData?.data);
    if (_res.status == 200) {
      tncResModel = _res;
      update();
    } else {
      snackBars(message: _res.message);
    }
  }

  Future<void> storeTnc(context) async {
    var _validation = tncStoreModel!
        .where((e) =>
            e.name == null ||
            e.name == "" ||
            e.description == null ||
            e.description == "")
        .length;
    var _removeNullPayload = tncStoreModel!
        .where((e) =>
            e.name != null &&
            e.name != "" &&
            e.description != null &&
            e.description != "")
        .map((e) => e.toJson())
        .toList();
    if (_validation >= 1 && validationForm()) {
      dialog(
        buttonTitle: "Lanjutkan",
        onPress: () async {
          Get.back();
          // Cms().loading(true);
          WrapResponse? _resData = await Api().POST(
              COUNSELOR_STORE_TERM_CONDITION + PRO.userData!.code!,
              {"data": _removeNullPayload},
              useToken: true);
          var _res = TncResModel.fromJson(_resData?.data);
          if (PRO.userData?.status == 1) {
            // Cms().loading(false);
            snackBars(message: _res.message);
            popScreen(context);
          } else {
            _updateUser(_res, context: context);
          }
        },
        desc:
            "Anda Belum mengisi semua data secara lengkap\nApakah Anda yakin ingin melanjutkannya?",
        context: context,
      );
    } else if (!validationForm()) {
      snackBars(
          message: "Buat minimal 1 poin persetujuan antara Anda dan Klien");
      return;
    } else {
      // Cms().loading(true);
      WrapResponse? _resData = await Api().POST(
          COUNSELOR_STORE_TERM_CONDITION + PRO.userData!.code!,
          {"data": tncStoreModel?.map((e) => e.toJson()).toList()},
          useToken: true);
      TncResModel _res = TncResModel.fromJson(_resData?.data);
      if (PRO.userData?.status == 1) {
        // Cms().loading(false);
        snackBars(message: _res.message);
        popScreen(context);
      } else {
        _updateUser(_res, context: context);
      }
    }
  }

  Future _updateUser(TncResModel _res, {required BuildContext context}) async {
    if (_res.status == 200 || _res.status == 201) {
      UserModel _update = await next();
      if (_update.status == 200) {
        await PRO.setUserSession(data: _update);
        // OneSignal().setSubscription(true);
        // Cms().loading(false);
        Get.offAll(() => KalmMainTab(context: context));
      } else {
        // Cms().loading(false);
        snackBars(message: "${_update.message}");
      }
    } else {
      // Cms().loading(false);
      snackBars(message: "${_res.status}");
    }
  }

  Future<UserModel> next() async {
    WrapResponse? _resData = await Api().POST(
        UPDATE_STATUS + PRO.userData!.code!, {"status": 1},
        useToken: true);
    var _res = UserModel.fromJson(_resData?.data);
    if (_res.status == 200) {
      return _res;
    } else {
      return _res;
    }
  }

  @override
  void onInit() {
    getTnc();
    super.onInit();
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

  factory TncStoreModel.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // name = json['name'];
    // nameEn = json['name_en'];
    // description = json['description'];
    // descriptionEn = json['description_en'];
    // order = json['order'];
    return TncStoreModel(
        id: json['id'],
        name: json['name'],
        nameEn: json['name_en'],
        description: json['description'],
        descriptionEn: json['description_en'],
        order: json['order']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['name_en'] = nameEn;
    data['description'] = description;
    data['description_en'] = descriptionEn;
    data['order'] = order;
    return data;
  }
}

class TncResModel {
  int status;
  String message;
  List<TncResData>? data;

  TncResModel(
      {required this.status, required this.message, required this.data});

  factory TncResModel.fromJson(Map<String, dynamic> json) {
    List<TncResData> data = <TncResData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(TncResData.fromJson(v));
      });
    }
    return TncResModel(
        status: json['status'], message: json['message'], data: data);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TncResData {
  int? id;
  int? userId;
  String? name;
  String? description;
  int? status;
  int? order;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;

  TncResData(
      {this.id,
      this.userId,
      this.name,
      this.description,
      this.status,
      this.order,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy});

  factory TncResData.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // userId = json['user_id'];
    // name = json['name'];
    // description = json['description'];
    // status = json['status'];
    // order = json['order'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    // createdBy = json['created_by'];
    // updatedBy = json['updated_by'];
    return TncResData(
        id: json['id'],
        userId: json['user_id'],
        name: json['name'],
        description: json['description'],
        status: json['status'],
        order: json['order'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        createdBy: json['created_by'],
        updatedBy: json['updated_by']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    data['order'] = order;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    return data;
  }
}
