import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/counselor/matchup-post-model.dart';
import 'package:counselor/model/matchup_res_model.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/pages/auth/login.dart';
import 'package:counselor/pages/auth/profile_reg.dart';
import 'package:counselor/pages/counselor/upload_mandatory_2.dart';
import 'package:counselor/tab_pages/setting_page.dart';
import 'package:counselor/translation/translation.dart';
import 'package:counselor/utilities/custom-picker.dart';
import 'package:counselor/widget/box_border.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/button/button.dart';
import 'package:counselor/widget/dialog.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounselorMatchupPage extends StatelessWidget {
  final bool isEdited;
  final bool isCurrentData;

  CounselorMatchupPage(
      {Key? key, this.isEdited = true, this.isCurrentData = true})
      : super(key: key);
  final _matchupController = Get.put(CounselorMatchupController());

  int _crossAxisCount({required int quesId}) {
    switch (quesId) {
      case 21:
        return 2;
      case 36:
        return 3;
      case 37:
        return 3;
      case 48:
        return 2;
      default:
        return 1;
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     top: true,
  //     bottom: true,
  //     child: GetBuilder<CounselorMatchupController>(
  //         dispose: (d) {},
  //         initState: (state) async {
  //           await _matchupController.matchupData(isCurrentData);
  //         },
  //         builder: (_) {
  //           final _data = _.matchupResModel;
  //           // ignore: missing_return
  //           return Builder(builder: (context) {
  //             switch (PRO.userData?.status != 1) {
  //               case true:
  //                 // ignore: missing_return
  //                 return Scaffold(
  //                   appBar: PreferredSize(
  //                       child: Align(
  //                         alignment: Alignment.centerLeft,
  //                         child: IconButton(
  //                             icon: const Icon(Icons.arrow_back_ios),
  //                             onPressed: () {
  //                               Get.off(() => ProfileRegPage());
  //                             }),
  //                       ),
  //                       preferredSize: const Size(0, 30)),
  //                   body: Builder(builder: (context) {
  //                     switch (_data == null ||
  //                         (_.answerController == null ||
  //                             _.loadingInitCurrentData)) {
  //                       case true:
  //                         return CustomWaiting().defaut();
  //                       case false:
  //                         return _body(_data!, _, context);
  //                       default:
  //                         return Container();
  //                     }
  //                   }),
  //                 );
  //               case false:
  //                 return Scaffold(body: Builder(builder: (context) {
  //                   switch ((_data == null) ||
  //                       (_.answerController == null) ||
  //                       _.loadingInitCurrentData) {
  //                     case true:
  //                       return CustomWaiting().defaut();
  //                     case false:
  //                       return _body(_data!, _, context);
  //                     default:
  //                       return Container();
  //                   }
  //                 }));
  //               default:
  //                 return Container();
  //             }
  //           });
  //         }),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    if (PRO.userData?.status == 1) {
      return _mainbody(context);
    }
    return POP_SCREEN_DIALOG(
      content: "Apakah Anda yakin ingin keluar dari halaman ini?",
      onConfirm: () async {
        await PRO.removeTempCode();
        await Get.offAll(() => LoginPage());
      },
      child: _mainbody(context),
    );
  }

  _mainbody(BuildContext context) {
    return SAFE_AREA(
      // harusnya 7
      bottomPadding: PRO.userData?.status == 1 ? null : 0,
      useNotification: PRO.userData?.status == 1 ? true : false,
      context: context,
      // canBack: PRO.userData?.status == 1 ? true : false,
      child: _body(),
    );
  }

  GetBuilder<CounselorMatchupController> _body() {
    return GetBuilder<CounselorMatchupController>(
      initState: (state) async {
        await _matchupController.matchupData(isCurrentData);
      },
      builder: (_) {
        if (_.matchupResModel == null ||
            (_.answerController == null || _.loadingInitCurrentData)) {
          return CustomWaiting().defaut();
        }
        return Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        SPACE(),
                        Center(
                          child: Text(
                            Translating().MATCHING_QUESTIONER.tr.toUpperCase(),
                            style: titleApp24,
                          ),
                        ),
                        SPACE(height: 10),
                        const Divider(thickness: 2),
                        SPACE(height: 10),
                        // const Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 25),
                        //   child: Divider(thickness: 1, color: Colors.black87),
                        // ),
                        Column(
                          children: List.generate(
                            _.matchupResModel!.length,
                            (i) {
                              switch (_.matchupResModel![i].id) {
                                case 1:
                                  return _selectLanguage(
                                      _.matchupResModel!, i, context, _);
                                case 5:
                                  return Column(
                                    children: [
                                      Column(
                                        children: [
                                          const Divider(thickness: 1),
                                          SPACE(),
                                          Text(
                                            _.matchupResModel![i].question ??
                                                "",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: BLUEKALM,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SPACE(),
                                          const Divider(thickness: 1),
                                        ],
                                      ),
                                      _gridAnswer(_.matchupResModel!, _, i),
                                    ],
                                  );
                                default:
                                  return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    isEdited
                        ? CustomButton(
                            padHorizontal: 60,
                            title: "next".tr,
                            onPressed: () {
                              // Get.offAll(LoginPage());
                              _.finalProcess(context, isCurrentData);
                            },
                            padvertical: 15)
                        : Container(),
                    // Builder(builder: (context) {
                    //   switch (isEdited) {
                    //     case true:
                    //       return CustomButton(
                    //           padHorizontal: 60,
                    //           title: "next".tr,
                    //           onPressed: () {
                    //             // Get.offAll(LoginPage());
                    //             _.finalProcess(context, isCurrentData);
                    //           },
                    //           padvertical: 15);
                    //     case false:
                    //       return Container();
                    //     default:
                    //       return Container();
                    //   }
                    // }),

                    SPACE(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Widget _body(List<MatchupResData> _data, CounselorMatchupController _,
  //     BuildContext context) {
  //    }

  Widget _selectLanguage(List<MatchupResData> _data, int i,
      BuildContext context, CounselorMatchupController _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _data[i].question ?? "No Data",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: BLUEKALM),
        ),
        SPACE(),
        GestureDetector(
          onTap:
              !isEdited ? null : () => bottomSheetAddress(_data, i, context, _),
          child: Container(
            color: Colors.white,
            child: CupertinoTextField(
                placeholder: "Pilih Bahasa",
                enabled: false,
                controller: TextEditingController(text: _.languange),
                suffix: const Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                )),
          ),
        ),
        SPACE(height: 10),
      ],
    );
  }

  Future<void> bottomSheetAddress(List<MatchupResData> _data, int index,
      BuildContext context, CounselorMatchupController _) async {
    List<String> _dataList = List.generate(_data[index].matchupAnswers!.length,
        (j) => _data[index].matchupAnswers![j].answer!);
    int _selectedIndex = 0;
    await Get.bottomSheet(
      StatefulBuilder(
        builder: (context, st) {
          return BOX_BORDER(
            Container(
              padding: const EdgeInsets.all(10),
              height: Get.height / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TEXT("Pilih Bahasa", style: titleApp20),
                      OUTLINE_BUTTON(
                        'Pilih',
                        onPressed: () async {
                          _.languange = _dataList[_selectedIndex];
                          _.setLangunge(lang: _dataList[_selectedIndex]);
                          final _indexLang = _data[index]
                              .matchupAnswers!
                              .indexWhere((element) =>
                                  element.answer == _dataList[_selectedIndex]);
                          final _answer = [_indexLang + 1];
                          _.payload![index].answer = _answer;
                          Get.back();
                        },
                        useExpanded: false,
                      )
                    ],
                  ),
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      physics: const FixedExtentScrollPhysics(),
                      itemExtent: 40,
                      onSelectedItemChanged: (i) {
                        st(() {
                          _selectedIndex = i;
                          // _.languange = _dataList[i];
                          // _.setLangunge(lang: _dataList[_selectedIndex]);
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: _dataList.length,
                        builder: (context, i) {
                          return _langList(i, _selectedIndex, _dataList[i]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isDismissible: true,
    );
  }

  Widget _langList(int i, int _selectedIndex, String _data) {
    if (_selectedIndex == i) {
      return BOX_BORDER(
        Center(
          child: TEXT(
            _data,
            style: COSTUM_TEXT_STYLE(
                color: BLUEKALM, fonstSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        height: 100,
      );
    } else {
      return Center(
          child: TEXT(_data, style: COSTUM_TEXT_STYLE(color: Colors.grey)));
    }
  }

  _answerHeader(int i, int j, answer) {
    return Text(
      answer,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w700, color: BLUEKALM),
    );
  }

  Column _gridAnswer(
    List<MatchupResData> _data,
    CounselorMatchupController _,
    int i,
  ) {
    return Column(
      children: List.generate(
        _data[i].matchupAnswers!.length,
        (j) {
          int? _answerId = _data[i].matchupAnswers![j].id;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child:
                      _answerHeader(i, j, _data[i].matchupAnswers![j].answer),
                ),
                GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        _data[i].matchupAnswers![j].answerChildren!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 50,
                      crossAxisCount: _crossAxisCount(quesId: _answerId!),
                    ),
                    itemBuilder: (context, k) {
                      return TextButton(
                          onPressed: !isEdited
                              ? null
                              : () {
                                  _.selectEvent(i, j, k, _data);
                                },
                          child: Row(
                            children: <Widget>[
                              _checkBox(i, j, k, _),
                              const SizedBox(
                                width: 10,
                              ),
                              _answerDesc(_data, i, j, k)
                            ],
                          ));
                    }),
                SPACE(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(thickness: 2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Flexible _answerDesc(List<MatchupResData> _data, int i, int j, int k) {
    return Flexible(
      child: Text(
        _data[i].matchupAnswers![j].answerChildren![k].answer!,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Builder _checkBox(i, j, k, CounselorMatchupController _) {
    return Builder(builder: (context) {
      switch (_.answerController![i].contains(null) ||
          _.answerController![i][j].contains(null)) {
        case true:
          return const CupertinoActivityIndicator(radius: 10);
        case false:
          return Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black45, width: 1.3),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: _.answerController![i][j][k]
                      ? !isEdited
                          ? Colors.grey
                          : ORANGEKALM
                      : Colors.white,
                )),
          );
        default:
          return Container();
      }
    });
  }
}

class CounselorMatchupController extends GetxController {
  List<MatchupResData>? matchupResModel;
  bool loadingInitCurrentData = false;
  List<List<List<bool>>>? answerController;
  List<MatchupPostModel>? payload;
  TextEditingController uniqCodeController = TextEditingController();
  String? languange;
  void setMatchupData({
    required List<MatchupResData> data,
    List<MatchupResData>? counselorData,
  }) {
    if (counselorData != null) {
      matchupResModel = counselorData;
      update();
    } else {
      matchupResModel = data;
      update();
    }
  }

  void setPayload(List<MatchupPostModel> data) {
    payload = data;
    update();
  }

  void setUniqCode({required String code}) {
    uniqCodeController.text = code;
    update();
  }

  void setAnswerController(List<List<List<bool>>> data) {
    answerController = data;
  }

  void setLoadingCurrentData(bool loading) {
    loadingInitCurrentData = loading;
    update();
  }

  Future<void> matchupData(bool isCurrentData) async {
    // await PROVIDER().updateSession();
    WrapResponse? _resData = await Api().GET(MATCHUP, useToken: true);
    MatchupResModel? _res = MatchupResModel.fromJson(_resData?.data);
    if (_res.status == 200) {
      final _query = _res.data;
      matchupResModel = _query!
          .where((e) =>
              (e.category == 1 && e.id == 1) || (e.category == 2 || e.id == 5))
          .toList();
      setLanguangeController(isCurrentData);
      setAnswer(matchupResModel!, isCurrentData);
      update();
    } else {
      snackBars(message: _res.message!);
    }
  }

  void setLanguangeController(bool isCurrentData) {
    try {
      if (!isCurrentData) {
        return;
      }
      dynamic _matchupJsonLang;
      var _langAnswer = matchupResModel?.first.matchupAnswers;
      if (isCurrentData) {
        _matchupJsonLang = PRO.userData?.matchupJson?.first?.answer?.first;
      }
      if (_langAnswer != null) {
        setLangunge(
          lang: _langAnswer
              .where((element) => element.id == _matchupJsonLang)
              .first
              .answer,
        );
      }
    } catch (e) {}
  }

  void setLangunge({String? lang}) {
    languange = lang;
    update();
  }

  void selectEvent(int i, int j, int k, List<MatchupResData> _data) {
    answerController![i][j][k] = !answerController![i][j][k];
    try {
      if (answerController![i][j][k]) {
        payload![i]
            .answer
            ?.add(_data[i].matchupAnswers![j].answerChildren![k].id);
      } else {
        payload![i]
            .answer!
            .remove(_data[i].matchupAnswers![j].answerChildren![k].id);
      }

      update();
    } catch (e) {
      snackBars(message: e.toString());
    }
  }

  void setAnswer(List<MatchupResData> _data, bool isCurrentData) {
    try {
      dynamic _matchupAnswer;
      late dynamic _queryJson;
      if (!isCurrentData) {
        _queryJson = null;
      } else {
        _matchupAnswer = PRO.userData?.matchupJson;
        _queryJson = _matchupAnswer
            .where((element) => element.question == 1 || element.question == 5)
            .toList();
      }

      answerController = List.generate(_data.length, (i) {
        return List.generate(_data[i].matchupAnswers!.length, (j) {
          return List.generate(
              _data[i].matchupAnswers![j].answerChildren!.length, (k) {
            if ((_queryJson != null) &&
                _queryJson[i].answer.contains(
                    _data[i].matchupAnswers![j].answerChildren![k].id)) {
              return true;
            } else {
              return false;
            }
          });
        });
      });
      if (!isCurrentData) {
        payload = List.generate(_data.length, (i) {
          return MatchupPostModel(question: _data[i].id, answer: []);
        });
        return;
      } else {
        if (_queryJson != null) {
          payload = List.generate(_queryJson.length,
              (i) => MatchupPostModel.fromJson(_queryJson[i].toJson()));
        } else {
          payload = List.generate(_data.length, (i) {
            return MatchupPostModel(question: _data[i].id, answer: []);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> submit() async {
    try {
      WrapResponse? _resData = await Api().POST(
          POST_MATCHUP,
          {
            "user_code": PRO.userData?.code,
            'data': List.generate(payload!.length, (i) => payload![i].toJson())
          },
          useToken: true);
      UserModel? res = UserModel.fromJson(_resData?.data);
      return res;
    } catch (e) {
      return UserModel(status: 404, message: "user data not found", data: null);
    }
  }

  Future finalProcess(BuildContext context, bool isCurrentData) async {
    try {
      var _validation = payload?.map((e) => e.answer!.isEmpty);
      if (_validation!.first) {
        snackBars(message: "Anda belum memilih bahasa");
      } else if (_validation.last) {
        snackBars(message: "Anda belum memilih kategori kuesioner");
      } else {
        // loading(true);
        var _res = await submit();
        if (_res?.status == 200) {
          await PRO.setUserSession(data: _res);
          if (isCurrentData && PRO.userData?.status == 1) {
            popScreen(context);
            snackBars(message: _res?.message ?? "");
            await pushRemoveUntilScreen(context, screen: SettingPage());
          } else {
            // for register
            // var _getStatusCredential = await _getStatus();
            await Get.offAll(() => CounselorUploadMandatoryPage());
            // if (_getStatusCredential[0]) {
            //   Loading.hide();
            //   // await pushRemoveUntilScreen(context,
            //   //     screen: CounselorUploadMandatoryPage());
            // } else {
            //   Loading.hide();
            //   print(_getStatusCredential[1]);
            // }
          }
        } else {
          Loading.hide();
          snackBars(message: _res?.message ?? "");
        }
      }
    } catch (e) {
      snackBars(message: e.toString());
    }
  }

  Future<List> _getStatus() async {
    WrapResponse? _resData = await Api().GET(APPROVAL_MANDATORY_FILES);
    UserModel? _res = UserModel.fromJson(_resData?.data);
    if (_res.status == 200) {
      PRO.setUserSession(data: _res);
      return [true, "${_res.message}"];
    } else {
      return [false, "${_res.message}"];
    }
  }
}
