import 'dart:developer';

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/counselor/client-get-to-know-model.dart';
import 'package:counselor/model/user_model/user_data.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/pages/auth/login.dart';
import 'package:counselor/pages/counselor/counselor_matchup.dart';
import 'package:counselor/pages/questioner_page.dart/user_questioner_match_up_page.dart';
import 'package:counselor/utilities/date_format.dart';
import 'package:counselor/utilities/date_picker.dart';
import 'package:counselor/utilities/util.dart';
import 'package:counselor/widget/box_border.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/dialog.dart';
import 'package:counselor/widget/expansion_tile.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/textfield.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProfileRegPage extends StatelessWidget {
  final _controller = Get.put(ProfileRegController());

  ProfileRegPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return POP_SCREEN_DIALOG(
      content: "Apakah Anda yakin ingin keluar dari halaman ini?",
      onConfirm: () async {
        await PRO.removeTempCode();
        await Get.offAll(() => LoginPage());
      },
      child: SAFE_AREA(
        context: context,
        useAppBar: true,
        useNotification: false,
        useLogo: true,
        bottomPadding: 0,
        child: GetBuilder<ProfileRegController>(
          initState: (st) async {
            await PRO.getCounselorQuestioner(
                useSnackbar: false, useLoading: false);
            await PRO.getClientQuestioner(
                useLoading: false, useSnackbar: false);
            await _controller.updateExisting();
            await _controller.initState(context);
          },
          didUpdateWidget: (oldWidget, newWidget) {
            // _controller.initState(context);
          },
          builder: (_) {
            if (_.userBankController == null) {
              return CustomWaiting().defaut();
            }
            // print(_.validatedFieldMessageGraduate.map((e) => e).toList());
            // print(_.graduateRegModelPayload.keys.map((e) => e).toList());
            return ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      _header(),
                      SPACE(),
                      const Divider(),
                      _question1(_, context),
                      const Divider(),

                      // SPACE(),
                      _question2(_, context),
                      const Divider(),
                      // SPACE(),
                      _question3(_, context),
                      const Divider(),
                      // SPACE(),
                      // if ((STATE(context).userData?.status == 2))
                      //   SizedBox(
                      //     width: Get.width / 1.4,
                      //     child: BUTTON(
                      //       "Lanjutkan",
                      //       onPressed: () async {
                      //         // await Get.to(
                      //         //     UserQustionerMatchupPage(useAppBar: true));
                      //         await pushNewScreen(context,
                      //             screen: UserQustionerMatchupPage(
                      //                 useAppBar: true));
                      //       } ,
                      //       circularRadius: 30,
                      //     ),
                      //   )
                      SizedBox(
                        width: Get.width / 1.4,
                        child: BUTTON("Lanjutkan",
                            onPressed: STATE(context).userData?.status == 2
                                ? () async {
                                    // await Get.to(
                                    //     UserQustionerMatchupPage(useAppBar: true));
                                    try {
                                      await Get.offAll(() =>
                                          CounselorMatchupPage(
                                              isEdited: true,
                                              isCurrentData: false));
                                    } catch (e) {
                                      Loading.hide();
                                      snackBars(message: e.toString());
                                    }
                                  }
                                : null,
                            circularRadius: 30,
                            verticalPad: 15,
                            expandedHorizontalPad: 10),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _question3(ProfileRegController _, BuildContext context) {
    return CostumExpansionTile(
      initiallyExpanded: _.expandedForm3,
      header: Expanded(
          child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: TEXT("Informasi Rekening Bank", style: titleApp20),
              trailing: !(STATE(context).userData?.status == 2)
                  ? null
                  : const Icon(Icons.check_circle_outline_outlined,
                      color: Colors.green))),
      children: STATE(context).userData?.counselorExperience == null
          ? []
          : List.generate(
              _.userBankModelPayload.keys.toList().length,
              (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SPACE(height: 15),
                      TEXT(_.question3(i)),
                      SPACE(height: 10),
                      CupertinoTextField(
                        onChanged: (val) => _.updateUserBankPayload(i, val),
                        controller: _.userBankController?[i],
                        keyboardType: _.userBankInputType[i],
                        inputFormatters: _.userBankInputFormatter?[i] != null
                            ? [_.userBankInputFormatter![i]!]
                            : null,
                      ),
                      if (_.validatedFieldMessageUserBank[i] != null &&
                          _.initValidateForm3 == true)
                        Column(
                          children: [
                            // SPACE(height: 5),
                            ERROR_VALIDATION_FIELD(
                                _.validatedFieldMessageUserBank[i]),
                          ],
                        ),
                      if ((i + 1) == _.userBankModelPayload.length)
                        _saveButton(_, "form3", context)
                    ],
                  ),
                );
              },
              // ),
            ),
    );
  }

  Widget _question2(ProfileRegController _, BuildContext context) {
    return Visibility(
      visible: PRO.userData?.status != null ? true : false,
      child: CostumExpansionTile(
        initiallyExpanded: _.expandedForm2,
        onExpansionChanged: (boolData) => print("DATA BERGANTI $boolData"),
        header: Expanded(
          child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: TEXT("Pendidikan & Pengalaman Kerja", style: titleApp20),
              trailing: STATE(context).userData?.counselorExperience == null
                  ? null
                  : const Icon(Icons.check_circle_outline_outlined,
                      color: Colors.green)),
        ),
        children: !(STATE(context).userData?.dob != null)
            ? []
            : List.generate(
                _.graduateRegModel?.toJson().keys.length ?? 0,
                (i) {
                  var _key = _.graduateRegModel?.toJson().keys.toList()[i];
                  return Builder(
                    builder: (context) {
                      if (_key == "experience") {
                        return _skckOrSip(_, i);
                      } else if (_key == "skck" || _key == "skckdate") {
                        if (_.isSkck) {
                          return _graduateField(_, i, _key, context);
                        } else {
                          return Container();
                        }
                      } else if (_key == "sip" || _key == "sipdate") {
                        if (!_.isSkck) {
                          return _graduateField(_, i, _key, context);
                        } else {
                          return Container();
                        }
                      } else if (_key == "organization") {
                        return Container();
                      } else {
                        return _graduateField(_, i, _key, context);
                      }
                    },
                  );
                },
              ),
      ),
    );
  }

  Padding _graduateField(
      ProfileRegController _, int i, String? key, BuildContext context) {
    bool isSkckSip = (key == "skckdate" || key == "sipdate");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SPACE(height: 15),
          TEXT(_.question2(i)),
          SPACE(height: 10),
          CupertinoTextField(
            onChanged: (val) => _.updateGraduatePayload(i, val),
            readOnly: isSkckSip,
            onTap: isSkckSip
                ? () async => await _.updateSkckSip(key == "skckdate", i)
                : null,
            controller: _.graduateRegController?[i],
            keyboardType: _.graduateInputType[i],
            inputFormatters: _.graduateInputFormatter?[i] != null
                ? [_.graduateInputFormatter![i]!]
                : null,
          ),
          if (_.validatedFieldMessageGraduate[i] != null &&
              _.initValidateForm2 == true)
            Column(
              children: [
                // SPACE(height: 5),
                ERROR_VALIDATION_FIELD(_.validatedFieldMessageGraduate[i]),
              ],
            ),
          if (i == 14 || i == 12) _saveButton(_, "form2", context)
        ],
      ),
    );
  }

  Center _saveButton(
      ProfileRegController _, String args, BuildContext context) {
    return Center(
      child: Column(
        children: [
          SPACE(),
          SizedBox(
              width: Get.width / 1.4,
              child: BUTTON("Simpan",
                  onPressed: !validateForm(args, _)
                      ? null
                      : () async => await _.submit(args, context)))
        ],
      ),
    );
  }

  bool validateForm(String args, ProfileRegController _) {
    switch (args) {
      case "form1":
        if (_.initValidateForm1 == false) {
          return true;
        }
        return _controller.validatedForm1;
      case "form2":
        if (_.initValidateForm2 == false) {
          return true;
        }
        return _controller.validatedForm2;
      case "form3":
        if (_.initValidateForm3 == false) {
          return true;
        }
        return _controller.validatedForm3;
      default:
        return false;
    }
  }

  Padding _skckOrSip(ProfileRegController _, int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BOX_BORDER(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TEXT(_.question2(i)),
              SPACE(height: 10),
              CupertinoTextField(
                readOnly: true,
                suffix: const Icon(Icons.arrow_drop_down),
                controller: _.graduateRegController![i],
                onTap: () async => await _.counselorExperience(i),
              ),
              if (_.validatedFieldMessageGraduate[i] != null)
                Column(
                  children: [
                    SPACE(height: 5),
                    ERROR_VALIDATION_FIELD(_.validatedFieldMessageGraduate[i]),
                  ],
                ),
              SPACE(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _.onChangeSkckOrSip(true),
                    child: Row(children: [
                      BOX_BORDER(
                          Card(
                              margin: const EdgeInsets.all(2),
                              color: _.isSkck ? ORANGEKALM : Colors.white),
                          width: 20,
                          height: 20,
                          circularRadius: 5),
                      SPACE(),
                      TEXT("SKCK*")
                    ]),
                  ),
                  InkWell(
                    onTap: () => _.onChangeSkckOrSip(false),
                    child: Row(children: [
                      BOX_BORDER(
                          Card(
                              margin: const EdgeInsets.all(2),
                              color: !_.isSkck ? ORANGEKALM : Colors.white),
                          width: 20,
                          height: 20,
                          circularRadius: 5),
                      SPACE(),
                      TEXT("SIP*")
                    ]),
                  ),
                  SPACE(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _question1(ProfileRegController _, BuildContext context) {
    return CostumExpansionTile(
      topBorderOn: false,
      bottomBorderOn: false,
      initiallyExpanded: _.expandedForm1,
      header: Expanded(
        child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: TEXT("Informasi Pribadi", style: titleApp20),
            trailing: !(STATE(context).userData?.dob != null)
                ? null
                : const Icon(Icons.check_circle_outline_outlined,
                    color: Colors.green)),
      ),
      children: List.generate(
        _.profileRegModel?.toJson().keys.length ?? 0,
        (i) {
          return Builder(
            builder: (context) {
              if (_.question1(i) == "Email*" ||
                  _.question1(i) == "Tentang Saya*") {
                return Container();
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TEXT(_.question1(i)),
                      SPACE(height: 10),
                      CupertinoTextField(
                          onChanged: (val) => _.updateProfilePayload(i, val),
                          readOnly: _.isDialogAnswer[i],
                          suffix: _.isDialogAnswer[i]
                              ? const Icon(Icons.arrow_drop_down)
                              : null,
                          onTap: _.isDialogAnswer[i]
                              ? () async => await _.listWheelAnswer(i)
                              : null,
                          controller: _.profileRegController![i],
                          keyboardType: _.profileRegInputType[i],
                          inputFormatters:
                              _.profileRegInputFormatter?[i] != null
                                  ? [_.profileRegInputFormatter![i]!]
                                  : null),
                      SPACE(height: 15),
                      if (_.validatedFieldMessageProfile[i] != null &&
                          _.initValidateForm1 == true)
                        Column(
                          children: [
                            SPACE(height: 5),
                            ERROR_VALIDATION_FIELD(
                                _.validatedFieldMessageProfile[i]),
                          ],
                        ),
                      if (i == 14) _saveButton(_, "form1", context)
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Text _header() {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
            text: "DATA KALMSELOR",
            style: COSTUM_TEXT_STYLE(
                fontWeight: FontWeight.w800, fonstSize: 25, color: BLUEKALM)),
        const TextSpan(
            text:
                "\n\nLengkapi formulir data untuk mulai memberikan layanan konseling",
            style: TextStyle(fontSize: 15))
      ]),
      textAlign: TextAlign.center,
    );
  }
}

class ProfileRegController extends GetxController {
  bool initValidateForm1 = false;
  bool initValidateForm2 = false;
  bool initValidateForm3 = false;
  bool expandedForm1 = true;
  bool expandedForm2 = false;
  bool expandedForm3 = false;
  initState(BuildContext context) {
    if (!(PRO.userData?.dob != null &&
        PRO.userData?.counselorExperience == null)) {
      log("KONDISI 3");

      expandedForm1 = false;
      expandedForm2 = false;
      expandedForm3 = true;
    } else if (!(PRO.userData?.dob != null)) {
      log("KONDISI 1");
      expandedForm1 = true;
      expandedForm2 = false;
      expandedForm3 = false;
    } else if (PRO.userData?.counselorExperience == null) {
      log("KONDISI 2");
      expandedForm1 = false;
      expandedForm2 = true;
      expandedForm3 = false;
    }
    update();
  }

  ///PROFILE REG
  ProfileRegModel? profileRegModel;
  Map<String, dynamic> profileRegModelPayload = ProfileRegModel().toJson();

  void updateProfilePayload(int i, dynamic answer) {
    profileRegModelPayload.update(
        profileRegModel!.toJson().keys.toList()[i], (value) => answer);
    update();
  }

  List<TextEditingController>? profileRegController;

  List<bool> get isDialogAnswer =>
      List.generate(profileRegModel?.toJson().keys.length ?? 0, (i) {
        if (question1(i) == "Tanggal Lahir*" ||
            question1(i) == "Jenis Kelamin*" ||
            question1(i) == "Agama*" ||
            question1(i) == "Jumlah Anak*" ||
            question1(i) == "Status*" ||
            question1(i) == "Negara*" ||
            question1(i) == "Provinsi*" ||
            question1(i) == "Kota*") {
          return true;
        } else {
          return false;
        }
      });

  List<TextInputType?> get profileRegInputType {
    return List.generate(profileRegModel?.toJson().keys.length ?? 0, (i) {
      if (question1(i) == "KTP/PASSPOR*" ||
          question1(i) == "Nomor Pokok Wajib Pajak*" ||
          question1(i) == "Nomor Handphone*") {
        return TextInputType.number;
      } else {
        return TextInputType.text;
      }
    });
  }

  List<TextInputFormatter?>? get profileRegInputFormatter {
    return List.generate(profileRegModel?.toJson().keys.length ?? 0, (i) {
      if (question1(i) == "KTP/PASSPOR*" ||
          question1(i) == "Nomor Pokok Wajib Pajak*" ||
          question1(i) == "Nomor Handphone*") {
        return FilteringTextInputFormatter.digitsOnly;
      } else {
        return null;
      }
    });
  }

  String question1(int i) {
    switch (profileRegModel?.toJson().keys.toList()[i]) {
      case "email":
        return "Email*";
      case "first_name":
        return "Nama Depan*";
      case "last_name":
        return "Nama Belakang*";
      case "id_number":
        return "KTP/PASSPOR*";
      case "npwp_number":
        return "Nomor Pokok Wajib Pajak*";
      case "phone":
        return "Nomor Handphone*";
      case "dob":
        return "Tanggal Lahir*";
      case "gender":
        return "Jenis Kelamin*";
      case "religion":
        return "Agama*";
      case "marital_status":
        return "Status*";
      case "amount_of_children":
        return "Jumlah Anak*";
      case "address":
        return "Alamat Domisili*";
      case "country_id":
        return "Negara*";
      case "state_id":
        return "Provinsi*";
      case "city_id":
        return "Kota*";
      case "about_me":
        return "Tentang Saya*";
      default:
        return "";
    }
  }

  List<String?>? listWheelAnswerData(int i) {
    switch (question1(i)) {
      case 'Agama*':
        return RELIGION_LIST;
      case 'Jenis Kelamin*':
        return GENDER_LIST;
      case 'Status*':
        return MARITAL_LIST()?.map((e) => e.answer).toList();
      case 'Jumlah Anak*':
        return AMOUNT_OF_CHILD_LIST()?.map((e) => e.answer).toList();
      case 'Negara*':
        return ADDRESS_ROOT()?.map((e) => e.name).toList();
      case 'Provinsi*':
        return STATES_DATA()?.map((e) => e.name).toList();
      case 'Kota*':
        return CITIES_DATA()?.map((e) => e.name).toList();
      default:
        return null;
    }
  }

  Future<void> listWheelAnswer(int i) async {
    if (question1(i) == 'Tanggal Lahir*') {
      await _selectDob(i);
    } else {
      if (listWheelAnswerData(i) == null || listWheelAnswerData(i)!.isEmpty) {
        return;
      }
      int _ans = 0;
      await Get.bottomSheet(StatefulBuilder(builder: (context, st) {
        return Container(
          height: Get.height / 3.5,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TEXT(question1(i),
                              style: COSTUM_TEXT_STYLE(fonstSize: 18)),
                        ),
                        SPACE(),
                        OUTLINE_BUTTON("Pilih", onPressed: () async {
                          profileRegController?[i].text =
                              listWheelAnswerData(i)![_ans]!;
                          if (question1(i) == 'Jenis Kelamin*') {
                            updateProfilePayload(i, (_ans));
                          } else if (question1(i) == 'Negara*' && profileRegController?[i].text == "Lainnya") {
                            profileRegController?[i + 1].text = "Lainnya";
                            updateProfilePayload((i + 1), null);
                            profileRegController?[i + 2].text = "Lainnya";
                            updateProfilePayload((i + 2), null);
                            await PRO.getStates(ADDRESS_ROOT()![_ans].id);
                            updateProfilePayload(i, ADDRESS_ROOT()![_ans].id);
                          } else if (question1(i) == 'Negara*' && profileRegController?[i].text != "Lainnya") {
                            profileRegController?[i + 1].text = "";
                            updateProfilePayload((i + 1), null);
                            profileRegController?[i + 2].text = "";
                            updateProfilePayload((i + 2), null);
                            await PRO.getStates(ADDRESS_ROOT()![_ans].id);
                            updateProfilePayload(i, ADDRESS_ROOT()![_ans].id);
                          } else if (question1(i) == 'Provinsi*' && profileRegController?[i - 1].text != "Lainnya") {
                            profileRegController?[i + 1].text = "";
                            updateProfilePayload((i + 1), null);
                            await PRO.getCity(STATES_DATA()![_ans].id);
                            updateProfilePayload(i, STATES_DATA()![_ans].id);
                          } else if (question1(i) == 'Kota*' && profileRegController?[i - 2].text != "Lainnya") {
                            updateProfilePayload(i, CITIES_DATA()![_ans].id);
                          } else {
                            updateProfilePayload(i, (_ans + 1));
                          }
                          Get.back();
                        }, useExpanded: false)
                      ])),
              Expanded(
                  child: ListWheelScrollView.useDelegate(
                      onSelectedItemChanged: (ans) {
                        st(() {
                          _ans = ans;
                        });
                      },
                      physics: const FixedExtentScrollPhysics(),
                      itemExtent: 40,
                      childDelegate: ListWheelChildListDelegate(
                          children: List.generate(
                              listWheelAnswerData(i)?.length ?? 0, (j) {
                        return BOX_BORDER(
                            Center(
                                child: TEXT(listWheelAnswerData(i)![j],
                                    style: COSTUM_TEXT_STYLE(
                                        color: _ans == j
                                            ? Colors.white
                                            : BLUEKALM))),
                            width: Get.width / 1.2,
                            fillColor: _ans == j ? BLUEKALM : Colors.white);
                      }))))
            ],
          ),
        );
      }));
    }
  }

  Future<void> _selectDob(int i) async {
    try {
      var _seletedDob = await DATE_PICKER(
        initialDateTime: _initDate(i),
        maxYears: (DateTime.now().year - 17),
      );
      assert(_seletedDob != null);
      profileRegController![i].text = DATE_FORMAT(_seletedDob!)!;
      updateProfilePayload(i, _seletedDob.toIso8601String());
    } catch (e) {
      return;
    }
  }

  DateTime? _initDate(int i) {
    try {
      return DateTime.parse(profileRegModelPayload['dob']);
    } catch (e) {
      return DateTime.now().subtract(Duration(days: (365.25 * 17).toInt()));
    }
  }

  bool get validatedForm1 {
    var _payload = profileRegModelPayload;
    _payload.remove("about_me");
    return _payload.values.every((e) {
      return ((e != null && e != '') || _payload['country_id'] == 3) &&
          validatedFieldMessageProfile
              .take(validatedFieldMessageProfile.length - 1)
              .every((e) => e == null);
    });
  }

  List<String?> get validatedFieldMessageProfile {
    return List.generate(profileRegController?.length ?? 0, (i) {
      if (profileRegInputType[i] == TextInputType.number) {
        if (profileRegController![i].text.isEmpty) {
          return 'Wajib diisi';
        } else if (profileRegController![i].text.length < 11) {
          return "Format tidak valid";
        } else {
          return null;
        }
      } else if (profileRegModel!.toJson().keys.toList()[i].contains('_id')) {
        if (profileRegModelPayload['country_id'] == 3) {
          return null;
        } else if (profileRegController![i].text.isEmpty) {
          return 'Wajib diisi';
        } else {
          return null;
        }
      } else if (profileRegController![i].text.isEmpty) {
        return 'Wajib diisi';
      } else {
        return null;
      }
    });
  }

  ///GRADUATE
  GraduateRegModel? graduateRegModel = GraduateRegModel();
  Map<String, dynamic> graduateRegModelPayload = GraduateRegModel().toJson();
  List<TextEditingController>? graduateRegController;

  void updateGraduatePayload(int i, dynamic answer) {
    graduateRegModelPayload.update(
        graduateRegModel!.toJson().keys.toList()[i], (value) => answer);
    update();
  }

  bool isSkck = true;

  void onChangeSkckOrSip(bool skck) {
    if (skck) {
      isSkck = true;
    } else {
      isSkck = false;
    }
    update();
  }

  Future<void> counselorExperience(int i) async {
    int _answer = 0;
    await Get.bottomSheet(StatefulBuilder(builder: (context, st) {
      return Container(
        height: Get.height / 4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TEXT(question2(i)),
                  OUTLINE_BUTTON("Pilih", useExpanded: false, onPressed: () {
                    graduateRegController?[i].text = EXPERIENCES_LIST[_answer];
                    updateGraduatePayload(i, _answer);
                    Get.back();
                  }),
                ],
              ),
              Expanded(
                  child: ListWheelScrollView.useDelegate(
                      onSelectedItemChanged: (j) {
                        st(() {
                          _answer = j;
                        });
                      },
                      itemExtent: 40,
                      childDelegate: ListWheelChildListDelegate(
                          children: List.generate(EXPERIENCES_LIST.length, (k) {
                        return BOX_BORDER(
                            Center(
                                child: TEXT(EXPERIENCES_LIST[k],
                                    style: COSTUM_TEXT_STYLE(
                                        fontWeight: _answer == k
                                            ? FontWeight.bold
                                            : FontWeight.w300,
                                        color: _answer == k
                                            ? Colors.white
                                            : BLUEKALM))),
                            fillColor: _answer == k ? BLUEKALM : Colors.white);
                      }))))
            ],
          ),
        ),
      );
    }));
  }

  String? question2(int i) {
    var key = graduateRegModel!.toJson().keys.toList()[i];
    switch (key.contains("degree")) {
      case true:
        if (key == "degree1") {
          return "Gelar Pendidikan S1*";
        } else if (key == "degree2") {
          return "Gelar Pendidikan S2*";
        } else {
          return "Gelar Pendidikan S3";
        }
      case false:
        if (key.contains("major")) {
          if (key == "major3") return "Universitas";
          return "Universitas*";
        } else if (key.contains("name")) {
          if (key == "name3") return "Jurusan";
          return "Jurusan*";
        } else if (key == "job") {
          return "Pekerjaan*";
        } else if (key == "skck") {
          return "SKCK*";
        } else if (key == "skckdate") {
          return "SKCK berlaku hingga*";
        } else if (key == "sip") {
          return "SIP*";
        } else if (key == "sipdate") {
          return "SIP berlaku hingga*";
        } else if (key == "organization") {
          return "Organisasi*";
        } else if (key == "experience") {
          return "Pengalaman menjadi Kalmselor*";
        } else {
          return "$key*";
        }
      default:
        break;
    }
    return null;
  }

  bool get validatedForm2 {
    return validatedFieldMessageGraduate.every((e) => e == null);
  }

  List<String?> get validatedFieldMessageGraduate {
    return List.generate(graduateRegController?.length ?? 0, (i) {
      var _optional = graduateRegModelPayload.keys.toList()[i];
      if (graduateRegController![i].text.isEmpty &&
          !_optional.contains("3") &&
          !_optional.contains("organization")) {
        if (_optional.contains("skck")) {
          return graduateRegController![i].text.isEmpty
              ? isSkck
                  ? "Wajib Diisi"
                  : null
              : null;
        } else if (_optional.contains("sip")) {
          return graduateRegController![i].text.isEmpty
              ? !isSkck
                  ? "Wajib Diisi"
                  : null
              : null;
        } else {
          return "Wajib Diisi";
        }
      } else {
        return null;
      }
    });
  }

  List<TextInputType?> get graduateInputType {
    return List.generate(graduateRegModel?.toJson().keys.length ?? 0, (i) {
      if (question2(i) == "SIP*" || question2(i) == "SKCK*") {
        return TextInputType.number;
      } else {
        return TextInputType.text;
      }
    });
  }

  List<TextInputFormatter?>? get graduateInputFormatter {
    return List.generate(graduateRegModel?.toJson().keys.length ?? 0, (i) {
      if (question2(i) == "SIP*" || question2(i) == "SKCK*") {
        return FilteringTextInputFormatter.digitsOnly;
      } else {
        return null;
      }
    });
  }

  Future<void> updateSkckSip(bool skck, int i) async {
    if (skck) {
      try {
        var _res = await DATE_PICKER(
            showUserAge: false,
            minYear: DateTime.now().year,
            maxYears: DateTime.now().year + 5);
        graduateRegController![i].text = DATE_FORMAT(_res)!;
        graduateRegController![i + 2].clear();
        graduateRegModelPayload['sip'] = null;
        graduateRegModelPayload['sipdate'] = null;
        updateGraduatePayload(i, _res?.toIso8601String());
      } catch (e) {
        return;
      }
    } else {
      try {
        var _res = await DATE_PICKER(
            showUserAge: false,
            minYear: DateTime.now().year,
            maxYears: DateTime.now().year + 5);
        graduateRegController![i].text = DATE_FORMAT(_res)!;
        graduateRegController![i - 2].clear();
        graduateRegModelPayload['skck'] = null;
        graduateRegModelPayload['skckdate'] = null;
        updateGraduatePayload(i, _res?.toIso8601String());
      } catch (e) {
        return;
      }
    }
  }

  ///BANK
  UserBankModel? userBankModel = UserBankModel();
  Map<String, dynamic> userBankModelPayload = UserBankModel().toJson();
  List<TextEditingController>? userBankController;

  String? question3(int i) {
    var key = userBankModel!.toJson().keys.toList()[i];
    switch (key) {
      case "bank_name":
        return "Nama Bank*";
      case "bank_branch_address":
        return "Alamat Cabang Bank*";
      case "account_number":
        return "Nomor Rekening*";
      case "account_holder":
        return "Nama Pemilik Rekening*";
      default:
    }
    return null;
  }

  List<TextInputFormatter?>? get userBankInputFormatter {
    return List.generate(userBankModel?.toJson().keys.length ?? 0, (i) {
      if (question3(i) == "Nomor Rekening*") {
        return FilteringTextInputFormatter.digitsOnly;
      } else {
        return null;
      }
    });
  }

  List<TextInputType?> get userBankInputType {
    return List.generate(
      userBankModel?.toJson().keys.length ?? 0,
      (i) {
        if (question3(i) == "Nomor Rekening*") {
          return TextInputType.number;
        } else {
          return TextInputType.text;
        }
      },
    );
  }

  void updateUserBankPayload(int i, dynamic answer) {
    userBankModelPayload.update(
        userBankModel!.toJson().keys.toList()[i], (value) => answer);
    update();
  }

  bool get validatedForm3 {
    return validatedFieldMessageUserBank.every((e) => e == null);
  }

  List<String?> get validatedFieldMessageUserBank {
    return List.generate(
      userBankController?.length ?? 0,
      (i) {
        if (userBankController![i].text.isEmpty) {
          return "Wajib diisi";
        } else {
          return null;
        }
      },
    );
  }

  Future<void> submit(String form, BuildContext context) async {
    switch (form) {
      case 'form1':
        initValidateForm1 = true;
        update();
        if (validatedForm1) {
          var _payload = profileRegModelPayload;
          _payload.remove("about_me");
          var _res = await Api().POST(USER_UPDATE, _payload, useToken: true);
          if (_res?.statusCode == 200) {
            await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
            SUCCESS_SNACK_BAR("Perhatian", _res?.message);
            Loading.hide();
            // expandedForm1 = false;
            // expandedForm2 = true;
            // expandedForm3 = false;
            // update();
            await Get.offAll(() => ProfileRegPage());
          } else {
            Loading.hide();
            return;
          }
        } else {
          snackBars(message: "Mohon mengisi semua form yang telah disediakan");
          return;
        }
        // print(PRO.userData?.status);
        // return;
        break;
      case 'form2':
        initValidateForm2 = true;
        update();

        // return;
        if (validatedForm2) {
          var _res = await Api()
              .POST(STORE_EXPERIENCE, graduateRegModelPayload, useToken: true);
          if (_res?.statusCode == 200) {
            await PRO.updateSession(useLoading: false, context: context);
            SUCCESS_SNACK_BAR("Perhatian", _res?.message);
            // expandedForm1 = false;
            // expandedForm2 = false;
            // expandedForm3 = true;
            // update();
            await Get.offAll(() => ProfileRegPage());

            Loading.hide();
          } else {
            Loading.hide();
            return;
          }
        } else {
          snackBars(message: "Mohon mengisi semua form yang telah disediakan");
          return;
        }
        break;
      case 'form3':
        initValidateForm3 = true;
        update();
        // print(PRO.userData?.status);
        // return;
        if (validatedForm3) {
          var _res = await Api()
              .POST(USER_PAYMENT_INFO, userBankModelPayload, useToken: true);
          if (_res?.statusCode == 200) {
            await PRO.saveLocalUser(UserModel.fromJson(_res?.data).data);
            SUCCESS_SNACK_BAR("Perhatian", _res?.message);
            Loading.hide();
            // expandedForm1 = false;
            // expandedForm2 = false;
            // expandedForm3 = false;
            // update();
            await Get.offAll(() => ProfileRegPage());
          } else {
            Loading.hide();
            return;
          }
        } else {
          snackBars(message: "Mohon mengisi semua form yang telah disediakan");
          return;
        }
        break;
      default:
        break;
    }
  }

  Future<void> updateExisting() async {
    try {
      await _updateExistingProfileReg();
      _updateExistingGraduate();
      _updateExistingUserBank();
      update();
    } catch (e) {
      print("Something wrong" + e.toString());
    }
  }

  void _updateExistingUserBank() {
    try {
      if (PRO.userData?.userBankModel != null) {
        var _data = PRO.userData?.userBankModel!.toJson();
        userBankModelPayload = _data!;
        userBankController = List.generate(_data.values.length,
            (i) => TextEditingController(text: _data.values.toList()[i]));
      } else {
        userBankController = List.generate(
            userBankModelPayload.values.length, (i) => TextEditingController());
      }
    } catch (e) {
      print("Something wrong form 3" + e.toString());
    }
  }

  void _updateExistingGraduate() {
    try {
      if (PRO.userData?.counselorExperience != null) {
        var _data = PRO.userData?.counselorExperience!.toJson();
        graduateRegModelPayload = _data!;
        graduateRegController = List.generate(_data.values.length, (i) {
          try {
            return TextEditingController(
                text: DATE_FORMAT(DateTime.parse(_data.values.toList()[i])));
          } catch (e) {
            try {
              if (graduateRegModelPayload.keys.toList()[i] == "experience") {
                return TextEditingController(
                    text: EXPERIENCES_LIST[_data.values.toList()[i]]);
              } else {
                return TextEditingController(text: _data.values.toList()[i]);
              }
            } catch (e) {
              return TextEditingController(text: _data.values.toList()[i]);
            }
          }
        });
      } else {
        var _graduateFix = graduateRegModel?.toJson();
        graduateRegController =
            List.generate(_graduateFix?.values.length ?? 0, (i) {
          return TextEditingController();
        });
      }
    } catch (e) {
      print("Something wrong form 2" + e.toString());
    }
  }

  Future<void> _updateExistingProfileReg() async {
    try {
      // await PRO.getCountry();
      if (PRO.userData?.countryId != null && PRO.userData?.countryId != 3) {
        await PRO.getStates(PRO.userData?.countryId);
        await PRO.getCity(PRO.userData?.stateId);
      }
      profileRegModel = ProfileRegModel.fromJson(PRO.userData!.toJson());
      profileRegModelPayload = profileRegModel!.toJson();
      profileRegController =
          List.generate(profileRegModel!.toJson().values.length, (i) {
        try {
          var _key = profileRegModel!.toJson().keys.toList()[i];
          if (_key == "country_id") {
            return TextEditingController(
                text: ADDRESS_ROOT()
                        ?.firstWhere((e) => e.id == PRO.userData?.countryId)
                        .name ??
                    "");
          } else if (_key == "state_id" &&
              profileRegModel!.toJson().values.toList()[i] != 3) {
            return TextEditingController(
                text: STATES_DATA()
                        ?.firstWhere((e) => e.id == PRO.userData?.stateId)
                        .name ??
                    "");
          } else if (_key == "city_id" &&
              profileRegModel!.toJson().values.toList()[i] != 3) {
            return TextEditingController(
                text: CITIES_DATA()
                        ?.firstWhere((e) => e.id == PRO.userData?.cityId)
                        .name ??
                    "");
          } else if (_key == "dob" && PRO.userData?.dob != null) {
            return TextEditingController(text: DATE_FORMAT(PRO.userData?.dob));
          } else if (_key == "gender" && PRO.userData?.gender != null) {
            return TextEditingController(
                text: GENDER_LIST[(PRO.userData!.gender!)]);
          } else if (_key == "religion" && PRO.userData?.religion != null) {
            return TextEditingController(
                text: RELIGION_LIST[(PRO.userData!.religion! - 1)]);
          } else if (_key == "marital_status" &&
              PRO.userData?.maritalStatus != null) {
            return TextEditingController(
                text: MARITAL_LIST()!
                    .firstWhere((e) => e.id == (PRO.userData!.maritalStatus))
                    .answer);
          } else if (_key == "amount_of_children" &&
              PRO.userData?.amountOfChildren != null) {
            return TextEditingController(
                text: AMOUNT_OF_CHILD_LIST()!
                    .firstWhere((e) => e.id == (PRO.userData!.amountOfChildren))
                    .answer);
          } else {
            return TextEditingController(
                text: profileRegModel!.toJson().values.toList()[i]);
          }
        } catch (e) {
          return TextEditingController();
        }
      });
    } catch (e) {
      print("Something wrong form 1" + e.toString());
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }
}
