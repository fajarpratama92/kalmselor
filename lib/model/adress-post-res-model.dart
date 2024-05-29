
import 'package:flutter/foundation.dart';

class AddressPostModel {
  int? country;
  int? state;
  int? city;

  AddressPostModel({
    this.country,
    this.state,
    this.city,
  });

  factory AddressPostModel.fromJson(Map<String, dynamic> json) {
    return AddressPostModel(
      country: json['country'],
      state: json['state'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    return data;
  }
}

// class CountryResModel {
//   int? status;
//   String? message;
//   List<CountryData>? data;

//   CountryResModel({this.status, this.message, this.data});

//   factory CountryResModel.fromJson(Map<String, dynamic> json) {
//     // status = json['status'];
//     // message = json['message'];
//     List<CountryData> dataCountry = <CountryData>[];
//     if (json['data'] != null) {
//       json['data'].forEach((v) {
//         dataCountry.add(CountryData.fromJson(v));
//       });
//     }
//     return CountryResModel(
//       status: json['status'],
//       message: json['message'],
//       data: dataCountry,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data?.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class CountryData {
  int? id;
  String? name;
  String? code;
  int? status;
  int? order;

  CountryData({this.id, this.name, this.code, this.status, this.order});

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      status: json['status'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['status'] = status;
    data['order'] = order;
    return data;
  }
}

class StateResModel {
  int? status;
  String? message;
  List<StateResData>? data;

  StateResModel({this.status, this.message, this.data});

  factory StateResModel.fromJson(Map<String, dynamic> json) {
    List<StateResData> dataState = <StateResData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataState.add(StateResData.fromJson(v));
      });
    }
    return StateResModel(
      status: json['status'],
      message: json['message'],
      data: dataState,
    );
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

  @override
  String toString() {
    return 'StateResModel{status: $status, message: $message, data: $data}';
  }
}

class StateResData {
  int? id;
  int? countryId;
  String? name;
  int? status;
  int? order;

  StateResData({this.id, this.countryId, this.name, this.status, this.order});

  factory StateResData.fromJson(Map<String, dynamic> json) {
    return StateResData(
      id: json['id'],
      countryId: json['country_id'],
      name: json['name'],
      status: json['status'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_id'] = countryId;
    data['name'] = name;
    data['status'] = status;
    data['order'] = order;
    return data;
  }

  @override
  String toString() {
    return 'StateResData{id: $id, countryId: $countryId, name: $name, status: $status, order: $order}';
  }
}

class CityResModel {
  int? status;
  String? message;
  List<CityResData>? data;

  CityResModel({this.status, this.message, this.data});

  factory CityResModel.fromJson(Map<String, dynamic> json) {
    List<CityResData> dataCity = <CityResData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataCity.add(CityResData.fromJson(v));
      });
    }
    return CityResModel(
      status: json['status'],
      message: json['message'],
      data: dataCity,
    );
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

class CityResData {
  int? id;
  int? stateId;
  int? countryId;
  String? name;
  String? latitude;
  String? longitude;
  int? status;
  int? order;

  CityResData(
      {this.id,
      this.stateId,
      this.countryId,
      this.name,
      this.latitude,
      this.longitude,
      this.status,
      this.order});

  factory CityResData.fromJson(Map<String, dynamic> json) {
    try {
      return CityResData(
        id: json['id'],
        stateId: json['state_id'],
        countryId: json['country_id'],
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        status: json['status'],
        order: json['order'],
      );
    } catch (e) {
        print("Something Wrong with CityResData");
      return CityResData();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['state_id'] = stateId;
    data['country_id'] = countryId;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status'] = status;
    data['order'] = order;
    return data;
  }

  @override
  String toString() {
    return 'CityResData{id: $id, stateId: $stateId, countryId: $countryId, name: $name, latitude: $latitude, longitude: $longitude, status: $status, order: $order}';
  }
}
