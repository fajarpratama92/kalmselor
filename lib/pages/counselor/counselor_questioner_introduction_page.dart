import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/counselor/counselor_answer.dart';
import 'package:counselor/model/counselor/counselor_get_to_know_model.dart';
import 'package:counselor/model/counselor/introduction_quetioner_res_model/counselor_questioner_res_model.dart';
import 'package:counselor/model/counselor/welcome_questioner_res_model/counselor_welcome_questioner_data.dart';
import 'package:counselor/model/counselor/welcome_questioner_res_model/counselor_welcome_questioner_res_model.dart';
import 'package:counselor/model/questioner-post-model.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/pages/auth/register.dart';
import 'package:counselor/widget/box_border.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/button/button.dart';
import 'package:counselor/widget/dialog.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounselorQustionerIntroductionPage extends StatelessWidget {
  final CounselorGetToKnow? counselorGetToKnow;
  final bool isFromWelcome;
  // final bool useSnackbars;
  CounselorQustionerIntroductionPage(
      {Key? key, this.counselorGetToKnow, required this.isFromWelcome})
      : super(key: key);
  final CounselorNoticeController _questionerController =
      Get.put(CounselorNoticeController());

  @override
  Widget build(BuildContext context) {
    print(counselorGetToKnow.toString());
    return SAFE_AREA(
      useAppBar: PRO.userData?.status != 1 ? false : true,
      context: context,
      bottomPadding: PRO.userData?.status != 1 ? 0 : null,
      child: GetBuilder<CounselorNoticeController>(
        initState: (state) {
          _questionerController.getQuestioner(useSnackbar: isFromWelcome);
        },
        builder: (_) {
          return Builder(
            builder: (context) {
              switch (_.questionerResModel == null) {
                case true:
                  return CustomWaiting().defaut();
                case false:
                  return ListView(
                    children: [
                      SPACE(height: 20),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: Get.size.width),
                            child: const Text(
                              "KUESIONER PENGENALAN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: BLUEKALM,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      const Divider(thickness: 3),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _questions(context),
                            SPACE(height: 10),
                            if (PRO.userData?.status != 1)
                              _submitButton(context)
                          ],
                        ),
                      )
                    ],
                  );
                default:
                  return Container();
              }
            },
          );
        },
      ),
    );
  }

  Widget? _listQuestion({required int i, required BuildContext context}) {
    var _data =
        _questionerController.questionerResModel!.welcomeQuestionerData!;

    if (_data[i].id == 13 && PRO.userData?.status == 1) {
      _questionerController.controllerLanguage.text =
          _currentAnswer(_data[i].id!) ?? "Data tidak ditemukan";
    } else if (_data[i].id == 14 && PRO.userData?.status == 1) {
      _questionerController.controllerEducation.text =
          _currentAnswer(_data[i].id!) ?? "Data tidak ditemukan";
    }
    // DIHILANGKAN SAJA
    if (_data[i].id == 14 || _data[i].id == 13) {
      return Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 5),
        child: CupertinoTextField(
          controller: _data[i].id == 13
              ? _questionerController.controllerLanguage
              : _data[i].id == 14
                  ? _questionerController.controllerEducation
                  : null,
          readOnly: true,
          suffix: const Icon(Icons.arrow_drop_down),
          onTap: PRO.userData?.status != 1
              ? () => _questionerController.bottomSheet(i)
              : null,
          // onTap: () async => await _questionerController.bottomSheet(i),
        ),
      );
    } else if (_data[i].id == 15 || _data[i].id == 16 || _data[i].id == 17) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0)),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: Platform.isAndroid ? 4 : 5,
              ),
              children: List.generate(
                _data[i].answer!.length,
                (j) {
                  var _ansList = _data[i].answer;
                  List<bool> _btnController =
                      _questionerController.btnController![i];
                  var _alert = _data[i]
                      .answer!
                      .where((element) => element.alert != null)
                      .first
                      .alert;
                  return CustomOutlineButton(
                    borderWidth: 0,
                    fillColor: (_currentAnswer(_data[i].id!) != null) &&
                            _ansList!
                                .map((e) =>
                                    e.answer == _currentAnswer(_data[i].id!))
                                .toList()[j]
                        ? BLUEKALM
                        : _btnController[j]
                            ? BLUEKALM
                            : Colors.white,
                    borderColor: Colors.grey,
                    radiusCircular: 5,
                    child: Text(
                      "${_ansList![j].answer}",
                      style: TextStyle(
                        fontSize: 18,
                        color: (_currentAnswer(_data[i].id!) != null) &&
                                _ansList
                                    .map((e) =>
                                        e.answer ==
                                        _currentAnswer(_data[i].id!))
                                    .toList()[j]
                            ? Colors.white
                            : _btnController[j]
                                ? Colors.white
                                : Colors.grey,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onPress: PRO.userData?.status != 1
                        ? () {
                            if (_currentAnswer(_data[i].id!) != null) {
                              return;
                            }
                            _questionerController.selected(_btnController, j,
                                _alert, i, _ansList, context);
                          }
                        : null,
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
    return null;
  }

  String? _currentAnswer(int intQuestionId) {
    switch (counselorGetToKnow != null) {
      case true:
        try {
          if (intQuestionId == 15 ||
              intQuestionId == 16 ||
              intQuestionId == 17) {
            return "Ya";
          }
          var data = counselorGetToKnow!.data!
              .firstWhere((e) => e.questionnaireId! == intQuestionId);
          // Merubah String "Ya" menjadi Ya
          data.answerDescription?.replaceAll('"', '');
          data.answerDescription?.replaceAll('"', '');
          return data.answerDescription;
        } catch (e) {
          if (intQuestionId == 13 || intQuestionId == 14) {
            return "Data tidak ditemukan";
          }
          return "Ya";
        }
      case false:
        return null;
      default:
        return null;
    }
  }

  _submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CustomButton(
        padHorizontal: 40,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
        title: "sent".tr,
        onPressed: _questionerController.validationForm() &&
                _questionerController.btnValidation
            ? () => _questionerController.submit(context: context)
            : null,
      ),
    );
  }

  Column _questions(BuildContext context) {
    return Column(
      children: List.generate(
          _questionerController
              .questionerResModel!.welcomeQuestionerData!.length, (i) {
        var _data =
            _questionerController.questionerResModel!.welcomeQuestionerData!;
        return Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _data[i].question.toString(),
                    style: const TextStyle(color: BLUEKALM, fontSize: 18),
                  ),
                ),
                _listQuestion(i: i, context: context) ?? Container(),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class CounselorNoticeController extends GetxController {
  CounselorQuestionerPostModel? payload;
  List<List<bool>>? btnController;
  CounselorWelcomeQuestionerResModel? questionerResModel;

  TextEditingController controllerLanguage = TextEditingController();
  TextEditingController controllerEducation = TextEditingController();

  bool get btnValidation =>
      btnController?.where((element) => element.contains(true)).length == 5;
  bool validationForm() {
    try {
      return payload!.data!.where((element) => element.answer == null).isEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> getQuestioner({required bool useSnackbar}) async {
    WrapResponse? _response =
        await Api().GET(QUESTIONER, useSnackbar: useSnackbar);
    var _res = CounselorWelcomeQuestionerResModel.fromJson(_response?.data);
    questionerResModel = _res;
    initState();
    update();
    if (useSnackbar == true) {
      snackBars(message: _res.dataWelcome ?? "");
    }
  }

  initState() {
    btnController = List.generate(
      questionerResModel!.welcomeQuestionerData!.length,
      (i) => List.generate(
        questionerResModel!.welcomeQuestionerData![i].answer!.length,
        (b) {
          if (questionerResModel!.welcomeQuestionerData![i].id == 13 ||
              questionerResModel!.welcomeQuestionerData![i].id == 14) {
            return true;
          } else {
            return false;
          }
        },
      ),
    );
    payload = CounselorQuestionerPostModel(
      role: USER_ROLE,
      data: List.generate(
        questionerResModel!.welcomeQuestionerData!.length,
        (i) {
          return QuestPostData(
            questionnaireId: questionerResModel!.welcomeQuestionerData![i].id,
            question: questionerResModel!.welcomeQuestionerData![i].question,
            questionCategory:
                questionerResModel!.welcomeQuestionerData![i].questionCategory,
            answer: null,
            answerDescription: null,
          );
        },
      ),
    );
  }

  void setPayload({
    required int answerId,
    required String answerDescription,
    required int i,
  }) {
    payload!.data![i].answer = answerId;
    payload!.data![i].answerDescription = answerDescription;
    update();
  }

  _processing({required BuildContext context}) async {
    WrapResponse? _resData =
        await Api().POST(POST_QUESTIONER, payload!.toJson());

    var _res = CounselorQuestionerResModel.fromJson(_resData?.data);

    if (_res.status == 200 || _res.status == 201) {
      PRO.saveTempCode(_res.data?.tempUserCode);
      Loading.hide();
      dialog(
        radiusButtonCircular: 10,
        barrierDismissible: false,
        title: "Selamat!\n",
        buttonTitle: "Selanjutnya",
        desc: "${_res.wording}",
        onPress: () async {
          Get.back();

          await Get.offAll(() => RegisterPage());
        },
        context: context,
      );
    } else {
      Loading.hide();
      dialog(
        title: "Perhatian!",
        buttonTitle: "Kembali",
        desc: "${_res.message}",
        onPress: () {
          Get.back();
        },
        context: context,
      );
    }
  }

  void selected(List<bool> _btnController, int j, String? _alert, int i,
      List<CounselorAnswer>? _ansList, BuildContext context) {
    for (var k = 0; k < _btnController.length; k++) {
      if (j == k) {
        if (j == 1) {
          dialogCustom(
              context: context,
              radiusButtonCircular: 10,
              barrierDismissible: false,
              title: "Perhatian",
              desc: _alert,
              buttonTitle: "Kembali",
              onPress: () {
                Get.back();
              });
          btnController![i][k] = false;
        } else {
          btnController![i][k] = true;
        }
      } else {
        btnController![i][k] = false;
      }
    }
    setPayload(
      answerId: _ansList![j].id!,
      answerDescription: _ansList[j].answer!,
      i: i,
    );
  }

  void submit({required BuildContext context}) async {
    SHOW_DIALOG(
      "Apakah Anda yakin akan mengirimkan Kuesioner Pengenalan?",
      onAcc: () async {
        Get.back();
        _processing(context: context);
      },
    );
  }

  Future<void> bottomSheet(int index) async {
    var _data = questionerResModel!.welcomeQuestionerData!;
    int _selectedIndex = 0;

    await Get.bottomSheet(StatefulBuilder(
      builder: (context, st) {
        return BOX_BORDER(
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            height: Get.height / 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TEXT(_data[index].question,
                            style: titleApp20, maxLines: 2),
                      ),
                      OUTLINE_BUTTON(
                        'Pilih',
                        onPressed: () async {
                          switch (index) {
                            case 0:
                              try {
                                onConfirm(
                                    _data[0].answer![_selectedIndex].answer!,
                                    index);
                              } catch (e) {
                                ERROR_SNACK_BAR("Perrhatian",
                                    'Terjadi Kesalahan saat memilih jawaban');
                                Get.back();
                              }
                              break;
                            case 1:
                              // scrollAnswered(index,
                              //     _data[1].answer?[_selectedIndex].answer ?? "");
                              // update();
                              onConfirm(
                                _data[1].answer![_selectedIndex].answer!,
                                index,
                              );

                              break;
                          }
                          Get.back();
                        },
                        useExpanded: false,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListWheelScrollView.useDelegate(
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: 40,
                    onSelectedItemChanged: (i) {
                      st(() {
                        _selectedIndex = i;
                        switch (index) {
                          case 0:
                            controllerLanguage.text =
                                '${_data[index].answer?[i].answer}';
                            break;
                          case 1:
                            controllerEducation.text =
                                '${_data[index].answer?[i].answer}';
                            break;
                        }
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _data[index].answer?.length,
                      builder: (context, i) {
                        switch (index) {
                          case 0:
                            return _optionListAnswerCounselor(
                              i,
                              _selectedIndex,
                              _data[index],
                            );
                          case 1:
                            return _optionListAnswerCounselor(
                              i,
                              _selectedIndex,
                              _data[index],
                            );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          fillColor: Colors.white,
        );
      },
    ), isDismissible: true);
  }

  Widget _optionListAnswerCounselor(int i, int _selectedIndex,
      CounselorWelcomeQuestionerData dataQuestionerCounselor) {
    CounselorWelcomeQuestionerData _data = dataQuestionerCounselor;
    if (_selectedIndex == i) {
      return BOX_BORDER(
        Center(
          child: TEXT(
            _data.answer?[i].answer ?? "Not Found",
            style: COSTUM_TEXT_STYLE(
              color: Colors.white,
              fonstSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        fillColor: BLUEKALM,
      );
    } else {
      return BOX_BORDER(
        Center(
          child: TEXT(
            _data.answer?[i].answer,
            style: COSTUM_TEXT_STYLE(color: Colors.grey),
          ),
        ),
      );
    }
  }

  void onConfirm(String answered, int i) {
    final _answered = questionerResModel!.welcomeQuestionerData![i].answer!
        .where((element) => element.answer == answered)
        .first;
    scrollAnswered(i, _answered.answer!);
    setPayload(
        answerId: _answered.id!, answerDescription: _answered.answer!, i: i);
  }

  scrollAnswered(int i, String answered) {
    switch (i) {
      case 0:
        controllerLanguage.text = answered;
        break;
      case 1:
        controllerEducation.text = answered;
        break;
      default:
    }
  }

  @override
  void onClose() {
    btnController = <List<bool>>[];
    payload = null;
    super.onClose();
  }
}
