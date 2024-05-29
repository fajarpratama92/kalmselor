import 'dart:async';

import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/client_quetioner_res_model/client_answer.dart';
import 'package:counselor/model/client_quetioner_res_model/client_questioner_data.dart';
import 'package:counselor/model/counselor/introduction_quetioner_res_model/counselor_questioner_data.dart';
import 'package:counselor/model/country_res_model/country_data.dart';
import 'package:counselor/model/state_res_model/address_item_data.dart';
import 'package:intl/intl.dart';

Timer? _debouncer;
void TEXTFIELD_DEBOUNCER(String v, void Function() callback, {int? second}) {
  if (_debouncer?.isActive ?? false) _debouncer?.cancel();
  _debouncer = Timer(Duration(seconds: second ?? 3), callback);
}

void TAB_CHANGE_DEBOUNCER(int v, void Function() callback, {int? second}) {
  if (_debouncer?.isActive ?? false) _debouncer?.cancel();
  _debouncer = Timer(Duration(seconds: second ?? 3), callback);
}

List<CountryData>? ADDRESS_ROOT() {
  try {
    return PRO.countryResModel?.data;
  } catch (e) {
    return null;
  }
}

List<String> GENDER_LIST = ['Perempuan', 'Laki-Laki'];

String GENDER(int i) {
  try {
    if (i == 0) {
      return 'Perempuan';
    } else {
      return 'Laki-Laki';
    }
  } catch (e) {
    return "Pilih Jenis Kelamin";
  }
}

String RELIGION(int i) {
  try {
    switch (i) {
      case 1:
        return "Islam";
      case 2:
        return "Protestan";
      case 3:
        return "Katolik";
      case 4:
        return "Hindu";
      case 5:
        return "Budha";
      default:
        return "Pilih Agama";
    }
  } catch (e) {
    return "Pilih Agama";
  }
}

int CHOSERELIGION(String i) {
  try {
    switch (i) {
      case "Islam":
        return 1;
      case "Protestan":
        return 2;
      case "Katolik":
        return 3;
      case "Hindu":
        return 4;
      case "Budha":
        return 5;
      default:
        return 0;
    }
  } catch (e) {
    return 0;
  }
}

List<String> RELIGION_LIST = [
  'Islam',
  'Protestan',
  "Katolik",
  "Hindu",
  'Budha'
];

List<CounselorQuestionerData>? get _questionerDataCounselor =>
    PRO.counselorQuestionerResModel?.questionerData;
List<ClientQuestionerData>? get _questionerDataClient =>
    PRO.clientQuestionerResModel?.questionerData;

String? DOB_ALERT_MESSAGE() {
  var _desc =
      _questionerDataCounselor?.firstWhere((e) => e.id == 2).description;
  try {
    return "${_desc?.replaceRange(0, _desc.indexOf("Anda"), '')}";
  } catch (err) {
    return _desc;
  }
}

String? STATE_NAME(int id) {
  try {
    return PRO.stateResItem?.data?.firstWhere((e) => e.id == id).name;
  } catch (e) {
    return "";
  }
}

List<AddressItemData>? STATES_DATA() {
  try {
    return PRO.stateResItem?.data?.toList();
  } catch (e) {
    return null;
  }
}

String? CITY_NAME(int id) {
  try {
    return PRO.cityResItem?.data?.firstWhere((e) => e.id == id).name;
  } catch (e) {
    return "";
  }
}

List<AddressItemData>? CITIES_DATA() {
  try {
    return PRO.cityResItem?.data?.toList();
  } catch (e) {
    return null;
  }
}

List<ClientAnswer>? MARITAL_LIST() {
  try {
    return _questionerDataClient?.map((e) => e).toList()[10].answer;
  } catch (e) {
    return null;
  }
}

String? MARITAL(int i) {
  try {
    return _questionerDataClient
        ?.map((e) => e)
        .toList()[10]
        .answer
        ?.map((e) => e.answer)
        .toList()[(i - 1)];
  } catch (e) {
    return "";
  }
}

String? AMOUNT_OF_CHILD(int i) {
  try {
    return _questionerDataClient
        ?.map((e) => e)
        .toList()[11]
        .answer
        ?.map((e) => e.answer)
        .toList()[(i - 1)];
  } catch (e) {
    return "";
  }
}

List<ClientAnswer>? AMOUNT_OF_CHILD_LIST() {
  try {
    return _questionerDataClient?.map((e) => e).toList()[11].answer;
  } catch (e) {
    return null;
  }
}

List<String> EXPERIENCES_LIST = [
  "< 1 tahun",
  "1-3 tahun",
  "3-5 tahun",
  "5-10 tahun",
  "> 10 tahun"
];

final PARSE_TO_CURRENCY = new NumberFormat("#,##0");
