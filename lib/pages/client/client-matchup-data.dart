import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/matchup_model/matchup_json.dart';
import 'package:counselor/model/matchup_res_model.dart';
import 'package:counselor/widget/appbar/main-appbar.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientMatchupPage extends StatelessWidget {
  final String email;
  ClientMatchupPage({Key? key, required this.email}) : super(key: key);
  final _matchupController = Get.put(ClientMatchupController());
  @override
  Widget build(BuildContext context) {
    try {
      return SAFE_AREA(
        context: context,
        // bottomPadding: 0,
        child: GetBuilder<ClientMatchupController>(
          initState: ((state) =>
              _matchupController.matchupData(email, context: context)),
          didUpdateWidget: (a, b) {},
          builder: (_) {
            final _data = _.matchupResModel;
            return Builder(
              builder: (context) {
                return Scaffold(
                  body: Builder(
                    builder: (context) {
                      switch ((_data == null || _data.isEmpty) ||
                          (_.answerController == null ||
                              _.answerController!.isEmpty) ||
                          _.loadingInitCurrentData) {
                        case true:
                          return Center(child: CustomWaiting().defaut());
                        case false:
                          return _body(_data, _, context);
                        default:
                          return Container();
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      );
    } catch (e) {
      return const Scaffold(
        body: Center(
          child: Text("Something Wrong"),
        ),
      );
    }
  }

  ListView _body(List<MatchupResData>? _data, ClientMatchupController _,
      BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SPACE(),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "KUESIONER PENCOCOKAN",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: BLUEKALM),
                ),
              ),
              SPACE(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Divider(thickness: 1, color: Colors.black87),
              ),
              _data!.isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: List.generate(
                          _data.length,
                          (i) {
                            return Builder(
                              builder: (context) {
                                switch (_data[i].id) {
                                  case 1:
                                    return _selectLanguage(
                                        _data, i, context, _);
                                  case 5:
                                    return Column(
                                      children: [
                                        _gridAnswer(_data, _, i),
                                      ],
                                    );
                                  default:
                                    return Container();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
        SPACE(),
      ],
    );
  }

  Widget _selectLanguage(List<MatchupResData> _data, int i,
      BuildContext context, ClientMatchupController _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1),
        SPACE(),
        Text(
          _data[i].question ?? "",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: BLUEKALM),
        ),
        SPACE(),
        const Divider(thickness: 1),
        SPACE(),
        Container(
          color: Colors.white,
          child: CupertinoTextField(
            placeholder: "Pilih Bahasa",
            enabled: false,
            controller: TextEditingController(text: _.languange),
            suffix: const Icon(
              Icons.arrow_drop_down,
              size: 30,
            ),
          ),
        ),
        SPACE(),
      ],
    );
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
    ClientMatchupController _,
    int i,
  ) {
    if (_data[i].matchupAnswers == null || _data[i].matchupAnswers!.isEmpty) {
      return Column();
    }
    return Column(
      children: List.generate(
        _data[i].matchupAnswers!.length,
        (index) {
          int _answerId = _data[i].matchupAnswers![index].id!;
          if (_data[i].matchupAnswers![index].answerChildren == null ||
              _data[i].matchupAnswers![index].answerChildren!.isEmpty) {
            return Column();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 1),
              SPACE(),
              _answerHeader(i, index, _data[i].matchupAnswers![index].answer),
              SPACE(),
              const Divider(thickness: 1),

              GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      _data[i].matchupAnswers![index].answerChildren!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      // crossAxisSpacing: _.crossAxisSpacing(quesId: _answerId),
                      // childAspectRatio: _.childAspectRatio(quesId: _answerId),
                      mainAxisExtent: 50,
                      crossAxisCount: _.crossAxisCount(quesId: _answerId)),
                  itemBuilder: (context, k) {
                    return SizedBox(
                      child: Row(
                        children: <Widget>[
                          _checkBox(i, index, k, _),
                          const SizedBox(width: 10),
                          _answerDesc(_data, i, index, k)
                        ],
                      ),
                    );
                  }),
              SPACE(),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   child: Divider(thickness: 2),
              // ),
            ],
          );
        },
      ),
    );
  }

  Flexible _answerDesc(List<MatchupResData> _data, int i, int index, int k) {
    return Flexible(
      child: Text(
        _data[i].matchupAnswers![index].answerChildren![k].answer!,
        style: const TextStyle(),
      ),
    );
  }

  Builder _checkBox(i, index, k, ClientMatchupController _) {
    return Builder(
      builder: (context) {
        switch (_.answerController![i].contains(null) ||
            _.answerController![i][index].contains(null)) {
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
                  color: _.answerController![i][index][k]
                      ? ORANGEKALM
                      : Colors.white,
                ),
              ),
            );
          default:
            return Container();
        }
      },
    );
  }
}

// controller

class ClientMatchupController extends GetxController {
  List<MatchupResData>? matchupResModel;
  bool loadingInitCurrentData = false;
  List<List<List<bool>>>? answerController;
  List<MatchupJson?>? clientmatchupAnswer(String? email,
          {required BuildContext context}) =>
      STATE(context, isListen: false)
          .counselorClientResModel
          ?.data!
          .where((e) => e.clientResData?.email == email)
          .map((e) => e.clientResData?.matchupJson)
          .first;
  String? languange;

  void setLangunge({required String lang}) {
    languange = lang;
    update();
  }

  void setAnswerController(List<List<List<bool>>> data) {
    answerController = data;
  }

  void setLoadingCurrentData(bool loading) {
    loadingInitCurrentData = loading;
    update();
  }

  Future<void> matchupData(String email,
      {required BuildContext context}) async {
    var _resData = await Api().GET(MATCHUP, useToken: true, useLoading: false);
    var _res = MatchupResModel.fromJson(_resData?.data);
    if (_res.status == 200) {
      final _query = _res.data;
      matchupResModel = _query?.where((e) {
        return (e.category == 1 && e.id == 1) || (e.category == 2 || e.id == 5);
      }).toList();
      setLanguangeController(email, context: context);
      setAnswer(matchupResModel, email, context: context);
      update();
    } else {
      snackBars(message: _res.message ?? "");
    }
  }

  void setLanguangeController(String email, {required BuildContext context}) {
    try {
      List<MatchupAnswers>? _langAnswer = matchupResModel?.first.matchupAnswers;
      var _matchupJsonLang =
          clientmatchupAnswer(email, context: context)?.first?.answer?.first;
      setLangunge(
        lang: _langAnswer!.isEmpty
            ? ""
            : _langAnswer
                    .where((element) => element.id == _matchupJsonLang)
                    .first
                    .answer ??
                "",
      );
    } catch (e) {
      print(e);
    }
  }

  void setAnswer(List<MatchupResData>? _data, String email,
      {required BuildContext context}) {
    try {
      List<MatchupJson?>? _queryJson =
          clientmatchupAnswer(email, context: context) == null
              ? []
              : clientmatchupAnswer(email, context: context)
                  ?.where((element) =>
                      element?.question == 1 || element?.question == 5)
                  .toList();
      if (_data == null || _data.isEmpty) {}

      List<List<List<bool>>> answerController = List.generate(
        _data!.length,
        (i) {
          return List.generate(
            _data[i].matchupAnswers!.length,
            (index) {
              return _data[i].matchupAnswers![index].answerChildren == null &&
                      _data[i].matchupAnswers![index].answerChildren!.isNotEmpty
                  ? []
                  : List.generate(
                      _data[i].matchupAnswers![index].answerChildren!.length,
                      (k) {
                        if ((_queryJson != null) &&
                            _queryJson[i]!.answer!.contains(_data[i]
                                .matchupAnswers![index]
                                .answerChildren![k]
                                .id)) {
                          return true;
                        } else {
                          return false;
                        }
                      },
                    );
            },
          );
        },
      );
      // payload = List.generate(
      //     _queryJson.length, (i) => MatchupPostModel.fromJson(_queryJson[i].toJson()));

      setAnswerController(answerController);
    } catch (e) {
      print(e);
    }
  }

  double childAspectRatio({required int quesId}) {
    switch (quesId) {
      case 21:
        return 5;
      case 30:
        return 8;
      case 36:
        return 2.5;
      case 37:
        return 2.5;
      case 38:
        return 9;
      case 42:
        return 9;
      case 48:
        return 5;
      default:
        return 10;
    }
  }

  double crossAxisSpacing({required int quesId}) {
    switch (quesId) {
      case 30:
        return 0;
      case 48:
        return 0;
      default:
        return 10;
    }
  }

  int crossAxisCount({required int quesId}) {
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

  @override
  void onInit() async {
    super.onInit();
  }
}
