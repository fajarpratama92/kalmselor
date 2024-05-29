import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/pages/setting_page/contact_us.dart';
import 'package:counselor/properties/properties.dart';
import 'package:counselor/widget/button/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utilities/util.dart';

class CounselorExperiencePage extends StatelessWidget {
  final _controller = Get.put(CounselorExperienceController());

  CounselorExperiencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SAFE_AREA(
        context: context,
        child: GetBuilder<CounselorExperienceController>(
          initState: (state) {
            _controller.getExperience();
          },
          builder: (_) {
            return Builder(
              builder: (context) {
                if (_.experienceResModel == null) {
                  return Center(child: CustomWaiting().defaut());
                } else {
                  var _data = _.experienceResModel!.data!.toJson();
                  _data.removeWhere((key, value) =>
                      key == 'created_at' ||
                      key == "updated_at" ||
                      key == "user_id" ||
                      key == "id" ||
                      key == "license" ||
                      value == null);

                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Text(
                                "${COUN_EXPERIENCE["EXPERIENCE_TITLE"]}"
                                    .toUpperCase(),
                                style: titleApp20,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Column(
                                children: _data.entries.map((e) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: _textField(e, _),
                              );
                            }).toList()),
                            SPACE(height: 10),
                            CustomButton(
                                titleRow: const Text(
                                  "Hubungi Admin Untuk Memperbaharui Data",
                                  textAlign: TextAlign.center,
                                  // style: TEXTSTYLE(
                                  //     fontWeight: FontWeight.w900,
                                  //     fontSize: 13,
                                  //     colors: Colors.white),
                                ),
                                padHorizontal: 40,
                                onPressed: () async {
                                  if (PRO.contactUsResModel == null) {
                                    await PRO.getContactUs();
                                    Loading.hide();
                                    await pushNewScreen(context,
                                        screen: ContactUsPage());
                                  } else {
                                    await pushNewScreen(context,
                                        screen: ContactUsPage());
                                  }
                                },
                                heigth: 40),
                            SPACE(height: 20),
                          ],
                        ),
                      )
                    ],
                  );
                }
              },
            );
          },
        ));
  }

  TextField _textField(
      MapEntry<String, dynamic> e, CounselorExperienceController _) {
    return TextField(
      // style: TEXTSTYLE(colors: Colors.grey, fontSize: 20),
      enabled: false,
      controller: TextEditingController(text: _answer(e.value, e.key)),
      decoration: InputDecoration(
          // contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          labelText: _.placeholder(e.key),
          floatingLabelBehavior: FloatingLabelBehavior.always),
    );
  }

  String _answer(dynamic answer, String key) {
    dynamic _skckDate = PRO.userData?.counselorExperience?.skckdate;
    // try {
    //   return "$answer";
    // } catch (e) {
    if (answer == null) return "";
    if ((answer != null) && answer.runtimeType == int && key == "experience") {
      return EXPERIENCES_LIST.elementAt(answer);
    } else if (key == "skckdate") {
      return DateFormat("dd/MMMM/y").format(DateTime.parse(_skckDate));
    }
    return "$answer";
  }
}

class CounselorExperienceController extends GetxController {
  ExperienceResModel? experienceResModel;

  Future<void> getExperience() async {
    WrapResponse? resData = await Api().GET(GET_EXPERIENCE, useToken: true);
    ExperienceResModel _res = ExperienceResModel.fromJson(resData?.data);
    if (_res.status == 200) {
      experienceResModel = _res;
      update();
    } else {
      snackBars(message: "${_res.message}");
    }
  }

  String placeholder(String key) {
    switch (COUN_EXPERIENCE.keys.contains(key.toUpperCase())) {
      case true:
        return COUN_EXPERIENCE[key.toUpperCase()];
        break;
      default:
        return "";
    }
  }
}

class ExperienceResModel {
  int? status;
  String? message;
  ExperienceResData? data;

  ExperienceResModel({this.status, this.message, this.data});

  ExperienceResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? ExperienceResData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class ExperienceResData {
  int? id;
  int? userId;
  String? degree1;
  String? name1;
  String? major1;
  String? degree2;
  String? name2;
  String? major2;
  String? degree3;
  String? name3;
  String? major3;
  String? license;
  int? experience;
  String? job;
  String? certificates;
  String? organization;
  String? skck;
  String? skckdate;
  String? sip;
  String? sipdate;
  String? createdAt;
  String? updatedAt;

  ExperienceResData(
      {this.id,
      this.userId,
      this.degree1,
      this.name1,
      this.major1,
      this.degree2,
      this.name2,
      this.major2,
      this.degree3,
      this.name3,
      this.major3,
      this.license,
      this.experience,
      this.job,
      this.certificates,
      this.organization,
      this.skck,
      this.skckdate,
      this.sip,
      this.sipdate,
      this.createdAt,
      this.updatedAt});

  ExperienceResData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    degree1 = json['degree1'];
    name1 = json['name1'];
    major1 = json['major1'];
    degree2 = json['degree2'];
    name2 = json['name2'];
    major2 = json['major2'];
    degree3 = json['degree3'];
    name3 = json['name3'];
    major3 = json['major3'];
    license = json['license'];
    experience = json['experience'];
    job = json['job'];
    certificates = json['certificates'];
    organization = json['organization'];
    skck = json['skck'];
    skckdate = json['skckdate'];
    sip = json['sip'];
    sipdate = json['sipdate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['degree1'] = degree1;
    data['name1'] = name1;
    data['major1'] = major1;
    data['degree2'] = degree2;
    data['name2'] = name2;
    data['major2'] = major2;
    data['degree3'] = degree3;
    data['name3'] = name3;
    data['major3'] = major3;
    data['license'] = license;
    data['experience'] = experience;
    data['job'] = job;
    data['certificates'] = certificates;
    data['organization'] = organization;
    data['skck'] = skck;
    data['skckdate'] = skckdate;
    data['sip'] = sip;
    data['sipdate'] = sipdate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
