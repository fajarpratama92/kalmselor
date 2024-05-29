import 'dart:developer';

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/counselor/counselor_get_to_know_model.dart';
import 'package:counselor/model/counselor/introduction_quetioner_res_model/counselor_questioner_payload.dart';
import 'package:counselor/model/user_model/user_data.dart';
import 'package:counselor/pages/auth/counselor_tnc.dart';
import 'package:counselor/pages/auth/upload_mandatory.dart';
import 'package:counselor/pages/counselor/counselor_matchup.dart';
import 'package:counselor/pages/counselor/counselor_questioner_match_up_page.dart';
import 'package:counselor/pages/counselor/counselor_experience.dart';
import 'package:counselor/pages/counselor/upload_mandatory_2.dart';
import 'package:counselor/pages/counselor/counselor_questioner_introduction_page.dart';
import 'package:counselor/pages/questioner_page.dart/user_questioner_match_up_page.dart';
import 'package:counselor/pages/setting_page/edit_profile.dart';
import 'package:counselor/utilities/date_format.dart';
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/image_cache.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final _controller = Get.put(ProfileController());

  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(initState: (state) async {
      if (PRO.counselorClientResModel == null) {
        await PRO.getCounselorQuestioner();
        await PRO.getClientQuestioner();
        await PRO.getCountry();
        await PRO.getStates(PRO.userData?.countryId);
        await PRO.getCity(PRO.userData?.stateId);
      }
    }, builder: (_) {
      return SAFE_AREA(
          context: context,
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    CircleAvatar(
                        backgroundColor: BLUEKALM,
                        radius: 100,
                        child: IMAGE_CACHE(
                          "$IMAGE_URL/users/${_.user(context)?.photo}",
                          width: 190,
                          height: 190,
                          circularRadius: 100,
                        )),
                    SPACE(),
                    TEXT(
                        "${_.user(context)?.firstName} ${_.user(context)?.lastName ?? ""}",
                        style: titleApp20),
                    SPACE(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(3, (i) {
                          return Column(
                            children: [
                              _properties(i),
                              SPACE(),
                              _propertiesText(i, context),
                            ],
                          );
                        })),
                    SPACE(height: 20),
                    Container(
                      constraints:
                          const BoxConstraints(maxWidth: 300, minWidth: 100),
                      child: Text(
                        STATE(context).userData?.aboutMe ?? "",
                        // "Exercitation sit anim irure dolor exercitation. Quis excepteur nulla ullamco elit.",
                        maxLines: 8,
                        textAlign: TextAlign.center,
                        style: bodyLargeBOLDBLUEKALM(
                            fontSize: 14, color: Colors.black),
                      ),
                    ),
                    const Divider(thickness: 1, color: BLUEKALM),
                    _optionList(_, context),
                  ],
                ),
              )
            ],
          ));
    });
  }

  Column _optionList(ProfileController _, BuildContext context) {
    return Column(
      children: List.generate(_.buttonTitle.length, (i) {
        return BUTTON(
          _.buttonTitle[i],
          onPressed: _.onPress(context)[i],
          verticalPad: 10,
          circularRadius: 20,
          titleMainAxisAlignment: MainAxisAlignment.start,
        );
      }),
    );
  }

  Text _propertiesText(int i, BuildContext context) {
    switch (i) {
      case 0:
        try {
          return TEXT(PRO.userData?.gender == 1 ? "Laki-Laki" : "Perempuan");
        } catch (e) {
          return TEXT("Not found");
        }
      case 1:
        return TEXT(
            "${VALIDATE_DOB_MATURE(STATE(context).userData!.dob!)!.toStringAsFixed(0)} Tahun");

      case 2:
        return TEXT(_country(PRO.userData!.countryId));
      default:
        return TEXT("Unknow");
    }
  }

  String _country(int? i) {
    try {
      switch (i) {
        case 1:
          return "Indonesia";
        case 2:
          return "Singapore";
        case 3:
          return "Lainnya";
        default:
          return "Unknow";
      }
    } catch (e) {
      return "Unknow";
    }
  }

  CircleAvatar _properties(int i) {
    return CircleAvatar(
        backgroundColor: ORANGEKALM,
        radius: 30,
        child: Image.asset(_controller.properties[i], scale: 3));
  }
}

class ProfileController extends GetxController {
  UserData? user(BuildContext context) {
    return STATE(context).userData;
  }

  List<String> properties = [
    "assets/image/gender.png",
    "assets/tab/setting.png",
    "assets/image/latitude.png"
  ];
  List<String> buttonTitle = [
    "informasi Pribadi",
    "Pendidikan & Pengalaman Kerja",
    "Kuisioner Pengenalan",
    "Jawaban Kuisioner Keahlian",
    "Dokumen Kredensial",
    "Persetujuan Kalmselor - Klien"
  ];

  List<Future<void> Function()> onPress(BuildContext context) {
    return List.generate(buttonTitle.length, (i) {
      return () async {
        switch (i) {
          case 0:
            await pushNewScreen(context, screen: EditProfilePage());
            break;
          case 1:
            await pushNewScreen(context, screen: CounselorExperiencePage());
            break;
          case 2:
            var _resData = await Api().GET(GET_TO_KNOW, useToken: true);
            try {
              var _res = CounselorGetToKnow.fromJson(_resData?.data);
              if (_res.status == 200) {
                // var _list = _res?.data['data'] as List<dynamic>;
                // var _model = _list.map((e) {
                //   try {
                //     return CounselorQuestionerPayload(
                //       questionnaireId: e['questionnaire_id'],
                //       question: e['question'],
                //       answer: e['answer'].runtimeType == int
                //           ? e['answer']
                //           : int.parse(
                //               e['answer'],
                //             ),
                //       answerDescription: e['answer_description'],
                //     );
                //   } catch (e) {
                //     return CounselorQuestionerPayload();
                //   }
                // }).toList();

                // _list.sort((a, b) {
                //   return DateTime.parse(b['created_at'])
                //       .compareTo(DateTime.parse(a['created_at']));
                // });
                // var _latestDate = _list.map((e) => e['created_at']).first;
                // var _filterData =
                //     _list.where((e) => e['created_at'] == _latestDate).toList();
                // var _model = _filterData.map((e) {
                //   try {
                //     return CounselorQuestionerPayload(
                //         answer: e['answer'].runtimeType == int
                //             ? e['answer']
                //             : int.parse(e['answer']));
                //   } catch (e) {
                //     // print(e);
                //     return CounselorQuestionerPayload();
                //   }
                // }).toList();
                try {
                  Loading.hide();
                  if (_res.data!.length < 16 && _res.data!.length > 4) {
                    await pushNewScreen(context,
                        screen: CounselorQustionerIntroductionPage(
                            counselorGetToKnow: _res, isFromWelcome: false));
                  } else {
                    throw Exception(
                        "Data tidak valid\nTotal data ${_res.data?.length}");
                  }
                  // await pushNewScreen(context,
                  //     screen: CounselorQustionerIntroductionPage(
                  //         counselorGetToKnow: _model));
                } catch (e) {
                  Loading.hide();
                  snackBars(message: e.toString());
                  // await pushNewScreen(context,
                  //     screen: CounselorQustionerIntroductionPage());
                }
              } else {
                Loading.hide();
              }
            } catch (e) {
              snackBars(message: e.toString());
            }

            break;
          case 3:
            var _gridAnswer = PRO.userData?.matchupJson?.map((e) {
              return e?.answer?.map((f) {
                if (f.runtimeType == int) {
                  return f as int;
                } else {
                  return int.parse(f);
                }
              }).toList();
            }).toList();
            // await pushNewScreen(context,
            //     screen: UserQustionerMatchupPage(
            //       isEdit: true,
            //       gridAnswer: _gridAnswer![1]!,
            //       languageAnswer: _gridAnswer[0]!,
            //     ));
            // pushNewScreen(context,
            //     screen: CounselorQustionerMatchupPage(
            //       isEdit: true,
            //       gridAnswer: _gridAnswer![1],
            //       languageAnswer: _gridAnswer[0],
            //     ));
            await pushNewScreen(context,
                screen:
                    CounselorMatchupPage(isEdited: true, isCurrentData: true));
            break;
          case 4:
            await pushNewScreen(context,
                screen: CounselorUploadMandatoryPage());
            // await pushNewScreen(context, screen: UploadMandatoryPage());

            break;
          case 5:
            // Get.to(() => CounselorTncPage());
            await pushNewScreen(context, screen: CounselorTncPage());
            // await pushNewScreen(context, screen: CounselorTncPage());
            break;
          default:
            return;
        }
      };
    });
  }

  int? _existingPayloadAnswer(int i) {
    var _u = PRO.userData;
    switch (i) {
      case 1:
        return 0;
      case 2:
        return 0;
      case 3:
        return _u?.gender;
      case 4:
        return _u?.gender;
      case 5:
        return 0;
      case 6:
        return 0;
      case 7:
        return 0;
      case 8:
        return 0;
      case 9:
        return 0;
      case 10:
        return 0;
      case 11:
        return 0;
      case 12:
        return 0;
      default:
        return 0;
    }
  }
}
