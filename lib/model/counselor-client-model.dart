import 'package:counselor/model/user_model/user_data.dart';

class CounselorClientResModel {
  int? status;
  String? message;
  List<CounselorClientResData>? data;

  CounselorClientResModel({this.status, this.message, this.data});

  CounselorClientResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CounselorClientResData>[];
      json['data'].forEach((v) {
        data?.add(CounselorClientResData.fromJson(v));
      });
    }
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

class CounselorClientResData {
  int? id;
  int? isReadTnc;
  int? isReadTncUpdate;
  int? isUniqueCode;
  int? userSubscriptionId;
  int? userId;
  int? counselorId;
  String? userReadTncAt;
  String? userReadTncUpdateAt;
  String? counselorConfirmedAt;
  String? forceConfimedAt;
  int? forceConfirmedBy;
  int? status;
  String? changeStatusAt;
  String? matchupAt;
  String? matchupAvailableAt;
  String? agreementToken;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? updatedBy;
  UserData? clientResData;
  CounselorClientResData({
    this.id,
    this.isReadTnc,
    this.isReadTncUpdate,
    this.isUniqueCode,
    this.userSubscriptionId,
    this.userId,
    this.counselorId,
    this.userReadTncAt,
    this.userReadTncUpdateAt,
    this.counselorConfirmedAt,
    this.forceConfimedAt,
    this.forceConfirmedBy,
    this.status,
    this.changeStatusAt,
    this.matchupAt,
    this.matchupAvailableAt,
    this.agreementToken,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
    this.clientResData,
  });

  CounselorClientResData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isReadTnc = json['is_read_tnc'];
    isReadTncUpdate = json['is_read_tnc_update'];
    isUniqueCode = json['is_unique_code'];
    userSubscriptionId = json['user_subscription_id'];
    userId = json['user_id'];
    counselorId = json['counselor_id'];
    userReadTncAt = json['user_read_tnc_at'];
    userReadTncUpdateAt = json['user_read_tnc_update_at'];
    counselorConfirmedAt = json['counselor_confirmed_at'];
    forceConfimedAt = json['force_confimed_at'];
    forceConfirmedBy = json['force_confirmed_by'];
    status = json['status'];
    changeStatusAt = json['change_status_at'];
    matchupAt = json['matchup_at'];
    matchupAvailableAt = json['matchup_available_at'];
    agreementToken = json['agreement_token'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    clientResData = UserData.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_read_tnc'] = isReadTnc;
    data['is_read_tnc_update'] = isReadTncUpdate;
    data['is_unique_code'] = isUniqueCode;
    data['user_subscription_id'] = userSubscriptionId;
    data['user_id'] = userId;
    data['counselor_id'] = counselorId;
    data['user_read_tnc_at'] = userReadTncAt;
    data['user_read_tnc_update_at'] = userReadTncUpdateAt;
    data['counselor_confirmed_at'] = counselorConfirmedAt;
    data['force_confimed_at'] = forceConfimedAt;
    data['force_confirmed_by'] = forceConfirmedBy;
    data['status'] = status;
    data['change_status_at'] = changeStatusAt;
    data['matchup_at'] = matchupAt;
    data['matchup_available_at'] = matchupAvailableAt;
    data['agreement_token'] = agreementToken;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['updated_by'] = updatedBy;
    data['user'] = clientResData;
    return data;
  }
}
