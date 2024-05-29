import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/address_payload.dart';
import 'package:counselor/model/client_quetioner_res_model/client_questioner_data.dart';
import 'package:counselor/model/client_quetioner_res_model/client_quetioner_res_model.dart';
import 'package:counselor/model/user_model/user_data.dart';
import 'package:counselor/model/user_questioner_payload.dart';
import 'package:counselor/utilities/date_format.dart';
import 'package:counselor/utilities/util.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/date_picker.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/loading_content.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientQuestionerIntroductionPage extends StatelessWidget {
  final List<UserQuestionerPayload?>? existingAnswer;
  final UserData? client;

  ClientQuestionerIntroductionPage({
    Key? key,
    this.existingAnswer,
    required this.client,
  }) : super(key: key);
  final _controller = Get.put(UserQustionerIntroductionController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserQustionerIntroductionController>(
      initState: (st) async {
        _controller.clientDataFull = client;
        await _controller.getClientQuestioner(useLoading: false);
        await PRO.getCountry(useLoading: false);
        if (_controller.clientDataFull?.status == 1) {
          await PRO.getStates(_controller.clientDataFull?.countryId);
          await PRO.getCity(_controller.clientDataFull?.stateId);
          for (var i = 0; i < existingAnswer!.length; i++) {
            if (i == 0) {
              try {
                String? tempCountry = ADDRESS_ROOT()
                    ?.where(
                        (e) => e.id == _controller.clientDataFull?.countryId)
                    .first
                    .name;
                _controller.setSelectingTempCountry(tempCountry);
                String? tempState = STATES_DATA()
                    ?.where((e) => e.id == _controller.clientDataFull?.stateId)
                    .first
                    .name;
                _controller.setSelectingTempState(tempState);
                String? tempCity = CITIES_DATA()
                    ?.where((e) => e.id == _controller.clientDataFull?.cityId)
                    .first
                    .name;
                _controller.setSelectingTempCity(tempCity);
              } catch (e) {}
            } else if (i == 1) {
              DateTime? tempDob = _controller.clientDataFull?.dob;
              _controller.setSelectedDate(tempDob);
            }
          }
        }
      },
      builder: (_) {
        return SAFE_AREA(
          context: context,
          child: Builder(
            builder: (context) {
              if ((_.clientQuestionerResModel == null) &&
                  _.clientQuestionerResModel?.questionerData == null) {
                return LOADING(context: context);
              } else {
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          TEXT(
                            "Bantu Kami mengenal Anda lebih baik",
                            style: titleApp20,
                            textAlign: TextAlign.center,
                          ),
                          SPACE(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                _.clientQuestionerResModel!.questionerData!.map(
                              (e) {
                                var _index = _
                                    .clientQuestionerResModel?.questionerData
                                    ?.indexWhere((element) =>
                                        element.question == e.question);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _question(_index, e),
                                    SPACE(height: 20),
                                    _answer(existingAnswer, e, _index!, _),
                                    SPACE(height: 20),
                                  ],
                                );
                              },
                            ).toList(),
                          ),
                          SPACE(height: 20),
                        ],
                      ),
                    )
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }

  Row _question(int? _index, ClientQuestionerData e) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: BLUEKALM,
          radius: 15,
          child: TEXT('${_index! + 1}',
              style: COSTUM_TEXT_STYLE(color: Colors.white)),
        ),
        SPACE(),
        Expanded(child: TEXT(e.question)),
      ],
    );
  }

  Widget _answer(List<UserQuestionerPayload?>? existingAnswer,
      ClientQuestionerData e, int i, UserQustionerIntroductionController _) {
    int? condition = existingAnswer?[i]?.answer;
    return Builder(builder: (context) {
      try {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5,
              mainAxisExtent: 40,
              crossAxisCount:
                  (e.answer?.length ?? 2) < 4 ? (e.answer?.length ?? 2) : 2,
            ),
            children: e.answer!.map((ans) {
              return OUTLINE_BUTTON(
                ans.answer ?? "",
                backgroundColor: (condition == ans.id)
                    ? existingAnswer != null
                        ? Colors.grey
                        : BLUEKALM
                    : Colors.white,
                textColor: (condition == ans.id) ? Colors.white : BLUEKALM,
              );
            }).toList(),
          ),
        );
      } catch (err) {
        if (i == 0) {
          return _selectAddress(_, context);
        } else {
          return _dobQuestion(_, e, i);
        }
      }
    });
  }

  Column _selectAddress(
      UserQustionerIntroductionController _, BuildContext context) {
    return Column(
      children: [
        CupertinoTextField(
          controller: TextEditingController(text: _.selectingTempCountry),
          style: const TextStyle(fontFamily: "MavenPro"),
          placeholder: "Pilih Negara",
          readOnly: true,
        ),
        if (_.addressPayload['country'] != 3)
          CupertinoTextField(
            controller: TextEditingController(text: _.selectingTempState),
            style: const TextStyle(fontFamily: "MavenPro"),
            placeholder: "Pilih Wilayah",
            readOnly: true,
          ),
        if (_.addressPayload['country'] != 3)
          CupertinoTextField(
            controller: TextEditingController(text: _.selectingTempCity),
            style: const TextStyle(fontFamily: "MavenPro"),
            placeholder: "Pilih kota",
            readOnly: true,
          ),
      ],
    );
  }

  String? addressCondition(String? condition) {
    if (condition == "country") {
      return _controller.selectingTempCountry;
    } else if (condition == "state") {
      return _controller.selectingTempState;
    } else {
      return _controller.selectingTempCity;
    }
  }

  Column _dobQuestion(
      UserQustionerIntroductionController _, ClientQuestionerData e, int i) {
    return Column(
      children: [
        CupertinoTextField(
          placeholder: "Tanggal Lahir",
          style: const TextStyle(fontFamily: "MavenPro"),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.date_range_outlined,
              color: BLUEKALM,
            ),
          ),
          suffix: Builder(builder: (context) {
            try {
              if (VALIDATE_DOB_MATURE(_.selectedDate)! <= 12.999) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.dangerous_outlined,
                    color: Colors.red,
                  ),
                );
              } else {
                return Container();
              }
            } catch (e) {
              return Container();
            }
          }),
          readOnly: true,
          controller: TextEditingController(
            text: DATE_FORMAT(_.selectedDate),
          ),
        ),
      ],
    );
  }
}

class UserQustionerIntroductionController extends GetxController {
  Map<String, dynamic> payload = <String, dynamic>{};
  String codeUser = PRO.userData!.code!;
  ClientQuetionerResModel? clientQuestionerResModel;
  UserData? clientDataFull;
  Future<void> getClientQuestioner({bool useLoading = true}) async {
    var _res =
        await Api().GET(QUESTIONER10, useToken: true, useLoading: useLoading);
    clientQuestionerResModel = ClientQuetionerResModel.fromJson(_res?.data);
    update();
  }

  late DatePickerController dateController;
  bool validateDob13 = false;

  DateTime? selectedDate;

  void setSelectedDate(DateTime? date) {
    selectedDate = date;
    update();
  }

  String? selectingTempCountry;
  int? intSelectingTempCountry;

  setSelectingTempCountry(String? value) {
    selectingTempCountry = value;
    update();
  }

  String? selectingTempState;
  int? intSelectingTempState;

  setSelectingTempState(String? value) {
    selectingTempState = value;
    update();
  }

  String? selectingTempCity;
  int? intSelectingTempCity;

  setSelectingTempCity(String? value) {
    selectingTempCity = value;
    update();
  }

  Map<String, int?> addressPayload = AddressPayload().toJson();

  @override
  void onInit() async {
    super.onInit();
    dateController = DatePickerController(
      initialDateTime: DateTime.now(),
      minYear: 1900,
      maxYear: DateTime.now().year,
    );
  }
}
