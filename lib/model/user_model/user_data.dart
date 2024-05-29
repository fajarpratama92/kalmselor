import 'dart:convert';

import 'package:counselor/model/matchup_model/matchup_json.dart';
import 'package:counselor/model/user_model/user_counselor_file.dart';
import 'package:counselor/model/user_model/user_has_active_counselor.dart';
import 'package:counselor/model/user_model/user_subscription_list.dart';
import 'package:counselor/utilities/util.dart';

class User {
  int? status;
  String? message;
  UserData? data;

  User({status, message, data});

  User.fromJson(Map<String, dynamic> json) {
    status = (json['status'].runtimeType == String)
        ? int.tryParse(json['status'])
        : json['status'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
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

// class UserData {
//   int? id;
//   String? code;
//   String? cometchatUserid;
//   int? balance;
//   String? firstName;
//   String? middleName;
//   String? lastName;
//   String? email;
//   DateTime? dob;
//   dynamic gender;
//   String? address;
//   int? cityId;
//   int? stateId;
//   int? countryId;
//   String? phone;
//   String? photo;
//   String? photoBackground;
//   String? aboutMe;
//   String? idNumber;
//   String? npwpNumber;
//   dynamic maritalStatus;
//   dynamic religion;
//   dynamic amountOfChildren;
//   int? isPinCodeActive;
//   List<MatchupJson>? matchupJson;
//   String? scheduleMatchupAt;
//   int? isMatchupCounterNotified;
//   int? matchupCounter;
//   String? firebaseToken;
//   String? onesignalToken;
//   String? token;
//   int? status;
//   dynamic role;
//   dynamic deviceNumber;
//   int? deviceType;
//   int? activationCode;
//   String? uniqueCode;
//   String? lastLoginAt;
//   String? createdAt;
//   String? updatedAt;
//   dynamic createdBy;
//   UserSetting? userSetting;
//   City? city;
//   State? state;
//   Country? country;
//   // Map<String, dynamic>? city;
//   // Map<String, dynamic>? state;
//   // Map<String, dynamic>? country;
//   UserHasActiveCounselor? userHasActiveCounselor;
//   UserSubscription? userSubscription;
//   List<CounselorMandatoryFiles>? counselorMandatoryFiles;
//   List<UserSubscriptionList>? userSubscriptionList;
//   // CounselorExperience counselorExperience;
//   GraduateRegModel? counselorExperience;
//   // List<UserPaymentHistory> userPaymentHistory;
//   // List<CounselorHasActiveUser> counselorHasActiveUser;
//   List<CounselorPayout>? counselorPayout;
//   UserVoucher? userVoucher;
//   UserBankModel? paymentInformation;
//   String? tempUserCode;

//   UserData({
//     this.id,
//     this.code,
//     this.cometchatUserid,
//     this.balance,
//     this.firstName,
//     this.middleName,
//     this.lastName,
//     this.email,
//     this.dob,
//     this.gender,
//     this.address,
//     this.cityId,
//     this.stateId,
//     this.countryId,
//     this.phone,
//     this.photo,
//     this.photoBackground,
//     this.aboutMe,
//     this.idNumber,
//     this.npwpNumber,
//     this.maritalStatus,
//     this.religion,
//     this.amountOfChildren,
//     this.isPinCodeActive,
//     this.matchupJson,
//     this.scheduleMatchupAt,
//     this.isMatchupCounterNotified,
//     this.matchupCounter,
//     this.firebaseToken,
//     this.onesignalToken,
//     this.token,
//     this.status,
//     this.role,
//     this.deviceNumber,
//     this.deviceType,
//     this.activationCode,
//     this.uniqueCode,
//     this.lastLoginAt,
//     this.createdAt,
//     this.updatedAt,
//     this.createdBy,
//     this.userSetting,
//     this.city,
//     this.state,
//     this.country,
//     this.userHasActiveCounselor,
//     this.userSubscription,
//     this.userSubscriptionList,
//     // this.userPaymentHistory,
//     this.counselorExperience,
//     // this.counselorHasActiveUser,
//     this.counselorPayout,
//     this.userVoucher,
//     this.paymentInformation,
//     this.tempUserCode,
//   });

//   UserData.fromJson(Map<String, dynamic> json) {
//     try {
//       id = json['id'];
//       code = json['code'];
//       cometchatUserid = json['cometchat_userid'];
//       balance = json['balance'];
//       firstName = json['first_name'];
//       middleName = json['middle_name'];
//       lastName = json['last_name'];
//       email = json['email'];
//       dob = json['dob'] == null ? null : DateTime.parse(json['dob']);
//       gender = json['gender'];
//       address = json['address'];
//       cityId = json['city_id'];
//       stateId = json['state_id'];
//       countryId = json['country_id'];
//       phone = json['phone'];
//       photo = json['photo'];
//       photoBackground = json['photo_background'];
//       aboutMe = json['about_me'];
//       idNumber = json['id_number'];
//       npwpNumber = json['npwp_number'];
//       maritalStatus = json['marital_status'] == 0 ? 1 : json['marital_status'];
//       if (json['religion'].runtimeType == String &&
//           json['religion'].length == 1) {
//         religion = int.parse(json['religion']);
//       } else if ((json['religion'].runtimeType == String) &&
//           json['religion'].length > 1) {
//         religion =
//             RELIGION_LIST.indexWhere((element) => element == json['religion']);
//       } else {
//         religion = json['religion'];
//       }
//       amountOfChildren =
//           json['amount_of_children'] == 0 ? 1 : json['amount_of_children'];
//       isPinCodeActive = json['is_pin_code_active'];
//       List<MatchupJson> matchupJson = <MatchupJson>[];
//       if (json['matchup_json'] != null) {
//         if (json['matchup_json'].runtimeType == String) {
//           jsonDecode(json['matchup_json']).forEach((v) {
//             matchupJson.add(MatchupJson.fromJson(v));
//           });
//         } else {
//           json['matchup_json'].forEach((v) {
//             matchupJson.add(MatchupJson.fromJson(v));
//           });
//         }
//       }
//       List<CounselorMandatoryFiles> counselorMandatoryFiles =
//           <CounselorMandatoryFiles>[];
//       if (json['counselor_files'] != null) {
//         json['counselor_files'].forEach((v) {
//           counselorMandatoryFiles.add(CounselorMandatoryFiles.fromJson(v));
//         });
//       }
//       scheduleMatchupAt = json['schedule_matchup_at'];
//       isMatchupCounterNotified = json['is_matchup_counter_notified'];
//       matchupCounter = json['matchup_counter'];
//       firebaseToken = json['firebase_token'];
//       onesignalToken = json['onesignal_token'];
//       token = json['token'];
//       status = json['status'];
//       role = json['role'];
//       deviceNumber = json['device_number'];
//       deviceType = json['device_type'];
//       activationCode = json['activation_code'].runtimeType == String
//           ? int.parse(json['activation_code'])
//           : json['activation_code'];
//       uniqueCode = json['unique_code'];
//       lastLoginAt = json['last_login_at'];
//       createdAt = json['created_at'];
//       updatedAt = json['updated_at'];
//       createdBy = json['created_by'];
//       userSetting = json['user_setting'] != null
//           ? UserSetting.fromJson(json['user_setting'])
//           : null;
//       city = json['city'] != null ? City.fromJson(json['city']) : null;
//       state = json['state'] != null ? State.fromJson(json['state']) : null;
//       country =
//           json['country'] != null ? Country.fromJson(json['country']) : null;
//       counselorExperience = json['counselor_experience'] != null
//           ? GraduateRegModel.fromJson(json['counselor_experience'])
//           : null;
//       userHasActiveCounselor = json['user_has_active_counselor'] != null
//           ? UserHasActiveCounselor.fromJson(json['user_has_active_counselor'])
//           : null;
//       userSubscription = json['user_subscription'] != null
//           ? UserSubscription.fromJson(json['user_subscription'])
//           : null;
//       List<UserSubscriptionList> userSubscriptionList =
//           <UserSubscriptionList>[];
//       if (json['user_subscription_list'] != null) {
//         json['user_subscription_list'].forEach((v) {
//           userSubscriptionList.add(UserSubscriptionList.fromJson(v));
//         });
//       }
//       // if (json['user_payment_history'] != null) {
//       //   userPaymentHistory = <UserPaymentHistory>[];
//       //   json['user_payment_history'].forEach((v) {
//       //     userPaymentHistory.add(UserPaymentHistory.fromJson(v));
//       //   });
//       // }
//       // if (json['user_payment_history'] != null) {
//       //   userPaymentHistory = <UserPaymentHistory>[];
//       //   json['user_payment_history'].forEach((v) {
//       //     userPaymentHistory.add(UserPaymentHistory.fromJson(v));
//       //   });
//       // }

//       // if (json['counselor_has_active_users'] != null) {
//       //   counselorHasActiveUser = <CounselorHasActiveUser>[];
//       //   json['counselor_has_active_users'].forEach((v) {
//       //     counselorHasActiveUser.add(CounselorHasActiveUser.fromJson(v));
//       //   });
//       // }
//       counselorPayout = <CounselorPayout>[];
//       if (json['counselor_payout'] != null) {
//         json['counselor_payout'].forEach((v) {
//           counselorPayout?.add(CounselorPayout.fromJson(v));
//         });
//       }
//       paymentInformation = json['user_payment_information'] != null
//           ? UserBankModel.fromJson(json['user_payment_information'])
//           : null;
//       userVoucher = json['user_voucher'] != null
//           ? UserVoucher.fromJson(json['user_voucher'])
//           : null;
//       tempUserCode = json['temp_user_code'];
//     } catch (e) {
//       print("SOMETHING WRONG" + e.toString());
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['code'] = code;
//     data['cometchat_userid'] = cometchatUserid;
//     data['balance'] = balance;
//     data['first_name'] = firstName;
//     data['middle_name'] = middleName;
//     data['last_name'] = lastName;
//     data['email'] = email;
//     data['dob'] = dob;
//     data['gender'] = gender;
//     data['address'] = address;
//     data['city_id'] = cityId;
//     data['state_id'] = stateId;
//     data['country_id'] = countryId;
//     data['phone'] = phone;
//     data['photo'] = photo;
//     data['photo_background'] = photoBackground;
//     data['about_me'] = aboutMe;
//     data['id_number'] = idNumber;
//     data['npwp_number'] = npwpNumber;
//     data['marital_status'] = maritalStatus;
//     data['religion'] = religion;
//     data['amount_of_children'] = amountOfChildren;
//     data['is_pin_code_active'] = isPinCodeActive;
//     data['matchup_json'] = matchupJson;
//     data['schedule_matchup_at'] = scheduleMatchupAt;
//     data['is_matchup_counter_notified'] = isMatchupCounterNotified;
//     data['matchup_counter'] = matchupCounter;
//     data['firebase_token'] = firebaseToken;
//     data['onesignal_token'] = onesignalToken;
//     data['token'] = token;
//     data['status'] = status;
//     data['role'] = role;
//     data['device_number'] = deviceNumber;
//     data['device_type'] = deviceType;
//     data['activation_code'] = activationCode;
//     data['unique_code'] = uniqueCode;
//     data['last_login_at'] = lastLoginAt;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['created_by'] = createdBy;
//     if (userSetting != null) {
//       data['user_setting'] = userSetting?.toJson();
//     }
//     if (city != null) {
//       data['city'] = city?.toJson();
//     }
//     if (state != null) {
//       data['state'] = state?.toJson();
//     }
//     if (country != null) {
//       data['country'] = country?.toJson();
//     }
//     if (paymentInformation != null) {
//       data['user_payment_information'] = paymentInformation?.toJson();
//     }
//     if (userHasActiveCounselor != null) {
//       data['user_has_active_counselor'] = userHasActiveCounselor?.toJson();
//     }
//     if (userSubscription != null) {
//       data['user_subscription'] = userSubscription?.toJson();
//     }
//     if (counselorExperience != null) {
//       data['counselor_experience'] = counselorExperience?.toJson();
//     }
//     if (userSubscriptionList != null) {
//       data['user_subscription_list'] =
//           userSubscriptionList?.map((v) => v.toJson()).toList();
//     }
//     // if (userPaymentHistory != null) {
//     //   data['user_payment_history'] =
//     //       userPaymentHistory.map((v) => v.toJson()).toList();
//     // }
//     // if (counselorHasActiveUser != null) {
//     //   data['counselor_has_active_users'] =
//     //       counselorHasActiveUser.map((v) => v.toJson()).toList();
//     // }
//     if (counselorPayout != null) {
//       data['counselor_payout'] =
//           counselorPayout?.map((v) => v.toJson()).toList();
//     }
//     if (userVoucher != null) {
//       data['user_voucher'] = userVoucher?.toJson();
//     }
//     if (counselorMandatoryFiles != null) {
//       data['counselor_files'] =
//           counselorMandatoryFiles?.map((v) => v.toJson()).toList();
//     }
//     data['temp_user_code'] = tempUserCode;
//     return data;
//   }
// }

class UserData {
  int? id;
  String? code;
  int? balance;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  DateTime? dob;
  int? gender;
  String? address;
  int? cityId;
  int? stateId;
  int? countryId;
  String? postalCode;
  String? timezoneId;
  String? phone;
  String? photo;
  String? photoBackground;
  String? aboutMe;
  String? idNumber;
  String? npwpNumber;
  int? maritalStatus;
  int? religion;
  int? amountOfChildren;
  int? isPinCodeActive;
  int? isMatchupCounterNotified;
  String? firebaseToken;
  String? onesignalToken;
  String? token;
  int? status;
  String? role;
  String? deviceNumber;
  int? deviceType;
  String? createdAt;
  String? updatedAt;
  Map<String, dynamic>? city;
  Map<String, dynamic>? state;
  Map<String, dynamic>? country;
  dynamic activationCode;
  List<MatchupJson?>? matchupJson;
  UserSubscription? userSubscription;
  List<UserSubscriptionList?>? userSubscriptionList;
  UserSetting? userSetting;
  UserHasActiveCounselor? userHasActiveCounselor;
  UserCounselorFile? userCounselorFile;
  GraduateRegModel? counselorExperience;
  UserBankModel? userBankModel;
  List<CounselorMandatoryFiles?>? counselorMandatoryFiles;
  UserVoucher? userVoucher;
  String? kalmselorCode;
  List<CounselorPayout>? counselorPayout;
  String? tempUserCode;

  UserData({
    this.id,
    this.code,
    this.balance,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.dob,
    this.gender,
    this.address,
    this.cityId,
    this.stateId,
    this.countryId,
    this.postalCode,
    this.timezoneId,
    this.phone,
    this.photo,
    this.photoBackground,
    this.aboutMe,
    this.idNumber,
    this.npwpNumber,
    this.maritalStatus,
    this.religion,
    this.amountOfChildren,
    this.isPinCodeActive,
    this.isMatchupCounterNotified,
    this.firebaseToken,
    this.onesignalToken,
    this.token,
    this.status,
    this.role,
    this.deviceNumber,
    this.deviceType,
    this.createdAt,
    this.updatedAt,
    this.city,
    this.state,
    this.country,
    this.activationCode,
    this.matchupJson,
    this.userSubscription,
    this.userSubscriptionList,
    this.userSetting,
    this.userHasActiveCounselor,
    this.userCounselorFile,
    this.counselorExperience,
    this.userBankModel,
    this.counselorMandatoryFiles,
    this.kalmselorCode,
    this.counselorPayout,
    this.userVoucher,
    this.tempUserCode,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    // print(json['token'] as String?);
    try {
      countryId = json['country_id'] as int?;
      id = json['id'] as int?;
      code = json['code'] as String;
      dob = json['dob'] == null ? null : DateTime.parse(json['dob']);
      firstName = json['first_name'] as String?;
      middleName = json['middle_name'] as String?;
      lastName = json['last_name'] as String?;
      gender = json['gender'].runtimeType == int
          ? json['gender']
          : int.parse(json['gender']);
      address = json['address'] as String?;
      cityId = json['city_id'] as int?;
      stateId = json['state_id'] as int?;
      idNumber = json['id_number'] as String?;
      npwpNumber = json['npwp_number'] as String?;
      counselorMandatoryFiles = json['counselor_mandatory_files'] != null
          ? List.generate(
              (json['counselor_mandatory_files'] as List<dynamic>).length, (i) {
              return CounselorMandatoryFiles.fromJson(
                  (json['counselor_mandatory_files'] as List<dynamic>)[i]);
            })
          : json['counselor_files'] != null
              ? List.generate((json['counselor_files'] as List<dynamic>).length,
                  (i) {
                  return CounselorMandatoryFiles.fromJson(
                      (json['counselor_files'] as List<dynamic>)[i]);
                })
              : null;
      if (json['religion'].runtimeType == String &&
          json['religion'].length == 1) {
        religion = int.parse(json['religion']);
      } else if ((json['religion'].runtimeType == String) &&
          json['religion'].length > 1) {
        religion =
            RELIGION_LIST.indexWhere((element) => element == json['religion']);
      } else {
        religion = json['religion'];
      }
      balance = json['balance'] as int?;
      counselorPayout = json['counselor_payout'] == null
          ? []
          : List<CounselorPayout>.generate(
              (json['counselor_payout'] as List<dynamic>).length,
              ((i) => CounselorPayout.fromJson(json['counselor_payout'][i])),
            );
      userBankModel = json['user_payment_information'] != null
          ? UserBankModel.fromJson(json['user_payment_information'])
          : null;
      email = json['email'] as String?;

      postalCode = json['postal_code'] as String?;
      timezoneId = json['timezone_id'] as String?;
      phone = json['phone'] as String?;
      photo = json['photo'] as String?;
      photoBackground = json['photo_background'] as String?;
      aboutMe = json['about_me'] as String?;

      isPinCodeActive = json['is_pin_code_active'] as int?;
      isMatchupCounterNotified = json['is_matchup_counter_notified'] as int?;
      firebaseToken = json['firebase_token'] as String?;
      onesignalToken = json['onesignal_token'] as String?;
      token = json['token'] as String?;
      status = json['status'] as int?;
      role = json['role']?.toString();
      deviceNumber = json['device_number']?.toString();
      deviceType = json['device_type'] as int?;
      createdAt = json['created_at'] as String?;
      updatedAt = json['updated_at'] as String?;
      city = json['city'];
      state = json['state'];
      country = json['country'];
      activationCode = json['activation_code']?.toString();
      kalmselorCode = json['unique_code'];
      maritalStatus = json['marital_status'] == null
          ? null
          : json['marital_status'].runtimeType == int
              ? json['marital_status']
              : int.parse(json['marital_status']);

      amountOfChildren = json['amount_of_children'].runtimeType == int
          ? json['amount_of_children']
          : int.parse(json['amount_of_children']);
      matchupJson = json['matchup_json'] == null
          ? null
          : List.generate(jsonDecode(json['matchup_json']).length, (i) {
              return MatchupJson.fromJson(jsonDecode(json['matchup_json'])[i]);
            });
      userSubscription = json['user_subscription'] == null
          ? null
          : UserSubscription.fromJson(json['user_subscription']);
      userSubscriptionList = json['user_subscription_list'] == null
          ? null
          : List.generate(json['user_subscription_list'].length, (i) {
              return UserSubscriptionList.fromJson(
                  json['user_subscription_list'][i]);
            });
      userSetting = json['user_setting'] != null
          ? UserSetting.fromJson(json['user_setting'])
          : null;
      userHasActiveCounselor = json['user_has_active_counselor'] != null
          ? UserHasActiveCounselor.fromJson(json['user_has_active_counselor'])
          : null;
      userCounselorFile = json['user_counselor_optional_files'] == null
          ? null
          : UserCounselorFile.fromJson(json['user_counselor_optional_files']);
      counselorExperience = json['counselor_experience'] != null
          ? GraduateRegModel.fromJson(json['counselor_experience'])
          : null;

      userVoucher = json['user_voucher'] != null
          ? UserVoucher.fromJson(json['user_voucher'])
          : null;
      tempUserCode = json['temp_user_code'];
    } catch (e) {
      print("SOMETHING WRONG USER");
      print(e);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'balance': balance,
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'email': email,
        'dob': dob?.toIso8601String(),
        'gender': gender,
        'address': address,
        'city_id': cityId,
        'state_id': stateId,
        'country_id': countryId,
        'postal_code': postalCode,
        'timezone_id': timezoneId,
        'phone': phone,
        'photo': photo,
        'photo_background': photoBackground,
        'about_me': aboutMe,
        'id_number': idNumber,
        'npwp_number': npwpNumber,
        'marital_status': maritalStatus,
        'religion': religion,
        'amount_of_children': amountOfChildren,
        'is_pin_code_active': isPinCodeActive,
        'is_matchup_counter_notified': isMatchupCounterNotified,
        'firebase_token': firebaseToken,
        'onesignal_token': onesignalToken,
        'token': token,
        'status': status,
        'role': role,
        'device_number': deviceNumber,
        'device_type': deviceType,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'city': city,
        'state': state,
        'country': country,
        'activation_code': activationCode,
        'matchup_json': matchupJson?.map((e) => e?.toJson()).toList(),
        'user_subscription': userSubscription?.toJson(),
        'user_subscription_list':
            userSubscriptionList?.map((e) => e?.toJson()).toList(),
        'user_has_active_counselor': userHasActiveCounselor?.toJson(),
        'user_counselor_optional_files': userCounselorFile?.toJson(),
        'counselor_experience': counselorExperience?.toJson(),
        'counselor_mandatory_files':
            counselorMandatoryFiles?.map((e) => e?.toJson()).toList(),
        'unique_code': kalmselorCode,
        'counselor_payout':
            counselorPayout?.map((e) => e.toJson()).toList() ?? [],
        'user_setting': userSetting?.toJson(),
        'user_voucher': userVoucher?.toJson(),
      };

  @override
  String toString() {
    return "id : $id \n"
        "code : $code \n"
        "balance : $balance \n"
        "firstName : $firstName \n"
        "middleName : $middleName \n"
        "lastName : $lastName \n"
        "email : $email \n"
        "dob : $dob \n"
        "tempUserCode : $tempUserCode \n";
  }
}

class UserSetting {
  int? counselorStopRequest;
  String? counselorStopRequestAt;
  int? counselorFeatured;
  int? counselorFeaturedOrder;
  String? lastChatAt;
  String? subscriptionStartAt;
  String? subscriptionExpiredAt;
  String? latestBillingId;
  String? language;
  int? emailClientSendMessage;
  int? emailRemindMyScheduled;
  int? emailClientWriteReview;
  int? notificationClientSendMessage;
  int? notificationRemindMyScheduled;
  int? notificationClientWriteReview;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? subscriptionLabel;
  dynamic subscriptionPercentage;

  UserSetting(
      {this.counselorStopRequestAt,
      this.counselorFeatured,
      this.counselorFeaturedOrder,
      this.lastChatAt,
      this.subscriptionStartAt,
      this.subscriptionExpiredAt,
      this.latestBillingId,
      this.language,
      this.emailClientSendMessage,
      this.emailRemindMyScheduled,
      this.emailClientWriteReview,
      this.notificationClientSendMessage,
      this.notificationRemindMyScheduled,
      this.notificationClientWriteReview,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.counselorStopRequest,
      this.subscriptionLabel,
      this.subscriptionPercentage});

  UserSetting.fromJson(Map<String, dynamic> json) {
    counselorStopRequestAt = json['counselor_stop_request_at'];
    counselorFeatured = json['counselor_featured'];
    counselorFeaturedOrder = json['counselor_featured_order'];
    lastChatAt = json['last_chat_at'];
    subscriptionStartAt = json['subscription_start_at'];
    subscriptionExpiredAt = json['subscription_expired_at'];
    latestBillingId = json['latest_billing_id'];
    language = json['language'];
    emailClientSendMessage = json['email_client_send_message'];
    emailRemindMyScheduled = json['email_remind_my_scheduled'];
    emailClientWriteReview = json['email_client_write_review'];
    notificationClientSendMessage = json['notification_client_send_message'];
    notificationRemindMyScheduled = json['notification_remind_my_scheduled'];
    notificationClientWriteReview = json['notification_client_write_review'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    subscriptionLabel = json['subscription_label'];
    subscriptionPercentage = json['subscription_percentage'];
    counselorStopRequest = json['counselor_stop_request'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['counselor_stop_request_at'] = counselorStopRequestAt;
    data['counselor_featured'] = counselorFeatured;
    data['counselor_featured_order'] = counselorFeaturedOrder;
    data['last_chat_at'] = lastChatAt;
    data['subscription_start_at'] = subscriptionStartAt;
    data['subscription_expired_at'] = subscriptionExpiredAt;
    data['latest_billing_id'] = latestBillingId;
    data['language'] = language;
    data['email_client_send_message'] = emailClientSendMessage;
    data['email_remind_my_scheduled'] = emailRemindMyScheduled;
    data['email_client_write_review'] = emailClientWriteReview;
    data['notification_client_send_message'] = notificationClientSendMessage;
    data['notification_remind_my_scheduled'] = notificationRemindMyScheduled;
    data['notification_client_write_review'] = notificationClientWriteReview;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['subscription_label'] = subscriptionLabel;
    data['counselor_stop_request'] = counselorStopRequest;
    data['subscription_percentage'] = subscriptionPercentage;
    return data;
  }
}

class ProfileRegModel {
  String? email;
  String? firstName;
  String? lastName;
  String? idNumber;
  String? npwpNumber;
  String? phone;
  int? gender;
  int? religion;
  String? dob;
  int? maritalStatus;
  String? aboutMe;
  int? amountOfChildren;
  String? address;
  int? countryId;
  int? stateId;
  int? cityId;

  ProfileRegModel({
    this.email,
    this.firstName,
    this.lastName,
    this.idNumber,
    this.npwpNumber,
    this.phone,
    this.gender,
    this.religion,
    this.dob,
    this.maritalStatus,
    this.aboutMe,
    this.amountOfChildren,
    this.address,
    this.countryId,
    this.stateId,
    this.cityId,
  });

  ProfileRegModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    idNumber = json['id_number'];
    npwpNumber = json['npwp_number'];
    phone = json['phone'];
    dob = json['dob'];
    gender = json['gender'];
    religion = json['religion'];
    maritalStatus = json['marital_status'].runtimeType == String
        ? int.parse(json['marital_status'])
        : json['marital_status'];
    aboutMe = json['about_me'];
    amountOfChildren = json['amount_of_children'].runtimeType == String
        ? int.parse(json['amount_of_children'])
        : json['amount_of_children'];
    address = json['address'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['id_number'] = idNumber;
    data['npwp_number'] = npwpNumber;
    data['phone'] = phone;
    data['dob'] = dob;
    data['gender'] = gender;
    data['religion'] = religion;
    data['marital_status'] = maritalStatus;
    data['amount_of_children'] = amountOfChildren;
    data['address'] = address;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['about_me'] = aboutMe;
    return data;
  }
}

class UserSubscription {
  int? id;
  int? subscriptionId;
  int? userId;
  int? isTrial;
  String? name;
  int? status;
  String? startAt;
  String? endAt;
  String? lastExtendAt;
  int? voucherId;
  String? promoId;
  int? methodPayment;
  String? otherResponse;
  int? flagUserReadTnc;
  String? createdAt;
  String? updatedAt;

  UserSubscription(
      {this.id,
      this.subscriptionId,
      this.userId,
      this.isTrial,
      this.name,
      this.status,
      this.startAt,
      this.endAt,
      this.lastExtendAt,
      this.voucherId,
      this.promoId,
      this.methodPayment,
      this.otherResponse,
      this.flagUserReadTnc,
      this.createdAt,
      this.updatedAt});

  UserSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionId = json['subscription_id'];
    userId = json['user_id'];
    isTrial = json['is_trial'];
    name = json['name'];
    status = json['status'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    lastExtendAt = json['last_extend_at'];
    voucherId = json['voucher_id'];
    promoId = json['promo_id'] == String
        ? json['promo_id']
        : (json['promo_id']).toString();
    methodPayment = json['method_payment'];
    otherResponse = json['other_response'];
    flagUserReadTnc = json['flag_user_read_tnc'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['subscription_id'] = subscriptionId;
    data['user_id'] = userId;
    data['is_trial'] = isTrial;
    data['name'] = name;
    data['status'] = status;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['last_extend_at'] = lastExtendAt;
    data['voucher_id'] = voucherId;
    data['promo_id'] = promoId;
    data['method_payment'] = methodPayment;
    data['other_response'] = otherResponse;
    data['flag_user_read_tnc'] = flagUserReadTnc;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GraduateRegModel {
  String? degree1;
  String? name1;
  String? major1;
  String? degree2;
  String? name2;
  String? major2;
  String? degree3;
  String? name3;
  String? major3;
  String? skck;
  String? skckdate;
  String? sip;
  String? sipdate;
  int? experience;
  String? job;
  String? organization;

  GraduateRegModel({
    this.degree1,
    this.name1,
    this.major1,
    this.degree2,
    this.name2,
    this.major2,
    this.degree3,
    this.name3,
    this.major3,
    this.skck,
    this.skckdate,
    this.sip,
    this.sipdate,
    this.experience,
    this.job,
    this.organization = "organize",
  });

  GraduateRegModel.fromJson(Map<String, dynamic> json) {
    degree1 = json['degree1'];
    name1 = json['name1'];
    major1 = json['major1'];
    degree2 = json['degree2'];
    name2 = json['name2'];
    major2 = json['major2'];
    degree3 = json['degree3'];
    name3 = json['name3'];
    major3 = json['major3'];
    skck = json['skck'];
    skckdate = json['skckdate'];
    sip = json['sip'];
    sipdate = json['sipdate'];
    experience = json['experience'];
    job = json['job'];
    organization = json['organization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['degree1'] = degree1;
    data['major1'] = major1;
    data['name1'] = name1;
    data['degree2'] = degree2;
    data['major2'] = major2;
    data['name2'] = name2;
    data['degree3'] = degree3;
    data['major3'] = major3;
    data['name3'] = name3;
    data['job'] = job;
    data['experience'] = experience;
    data['skck'] = skck;
    data['skckdate'] = skckdate;
    data['sip'] = sip;
    data['sipdate'] = sipdate;
    data['organization'] = organization;
    return data;
  }
}

class UserBankModel {
  String? bankName;
  String? bankBranchAddress;
  String? accountNumber;
  String? accountHolder;

  UserBankModel({
    this.bankName,
    this.bankBranchAddress,
    this.accountNumber,
    this.accountHolder,
  });
  factory UserBankModel.initial() => UserBankModel(
        bankName: "",
        bankBranchAddress: "",
        accountNumber: "",
        accountHolder: "",
      );

  UserBankModel.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    bankBranchAddress = json['bank_branch_address'];
    accountNumber = json['account_number'];
    accountHolder = json['account_holder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_name'] = bankName;
    data['bank_branch_address'] = bankBranchAddress;
    data['account_number'] = accountNumber;
    data['account_holder'] = accountHolder;
    return data;
  }
}

class UserVoucher {
  int? id;
  int? userVoucherGroupId;
  int? userId;
  int? subscriptionId;
  String? code;
  String? name;
  String? note;
  int? isCorporate;
  int? type;
  String? nameCorporate;
  String? startAt;
  String? endAt;
  int? status;
  String? createdAt;
  String? updatedAt;

  UserVoucher(
      {this.id,
      this.userVoucherGroupId,
      this.userId,
      this.subscriptionId,
      this.code,
      this.name,
      this.note,
      this.isCorporate,
      this.type,
      this.nameCorporate,
      this.startAt,
      this.endAt,
      this.status,
      this.createdAt,
      this.updatedAt});

  UserVoucher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userVoucherGroupId = json['user_voucher_group_id'];
    userId = json['user_id'];
    subscriptionId = json['subscription_id'];
    code = json['code'];
    name = json['name'];
    note = json['note'];
    isCorporate = json['is_corporate'];
    type = json['type'];
    nameCorporate = json['name_corporate'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_voucher_group_id'] = userVoucherGroupId;
    data['user_id'] = userId;
    data['subscription_id'] = subscriptionId;
    data['code'] = code;
    data['name'] = name;
    data['note'] = note;
    data['is_corporate'] = isCorporate;
    data['type'] = type;
    data['name_corporate'] = nameCorporate;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CounselorMandatoryFiles {
  int? id;
  String? name;
  String? file;
  int? status;
  int? isMandatory;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? imgSize;

  CounselorMandatoryFiles({
    this.id,
    this.name,
    this.file,
    this.status,
    this.isMandatory,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.imgSize,
  });

  CounselorMandatoryFiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    file = json['file'];
    status = json['status'];
    isMandatory = json['is_mandatory'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    imgSize = json['img_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['file'] = file;
    data['status'] = status;
    data['is_mandatory'] = isMandatory;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['img_size'] = imgSize;
    return data;
  }

  @override
  String toString() {
    return "CounselorMandatoryFiles{id: $id, name: $name, file: $file, status: $status, isMandatory: $isMandatory, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy, imgSize: $imgSize}";
  }
}

class CredentialPayload {
  List<int?>? id;
  List<int?>? isMandatory;
  List<String?>? names;
  List<String?>? documents;

  CredentialPayload({this.id, this.isMandatory, this.names, this.documents});

  CredentialPayload.fromJson(Map<String, dynamic> json) {
    id = json['id'].cast<int>();
    isMandatory = json['is_mandatory'].cast<int>();
    names = json['names'].cast<String>();
    documents = json['documents'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_mandatory'] = isMandatory;
    data['names'] = names;
    data['documents'] = documents;
    return data;
  }
}

class CounselorPayout {
  int? id;
  int? userId;
  int? amountUnpaid;
  int? amount;
  int? tax;
  int? additionalFee;
  int? status;
  String? note;
  String? amountPaidToDate;
  String? paymentInfo;
  String? createdAt;
  String? updatedAt;

  CounselorPayout({
    this.id,
    this.userId,
    this.amountUnpaid,
    this.amount,
    this.tax,
    this.additionalFee,
    this.status,
    this.note,
    this.amountPaidToDate,
    this.paymentInfo,
    this.createdAt,
    this.updatedAt,
  });

  factory CounselorPayout.fromJson(Map<String, dynamic> json) {
    return CounselorPayout(
      id: json['id'],
      userId: json['user_id'],
      amountUnpaid: json['amount_unpaid'],
      amount: json['amount'],
      tax: json['tax'],
      additionalFee: json['additional_fee'],
      status: json['status'],
      note: json['note'],
      amountPaidToDate: json['amount_paid_to_date'],
      paymentInfo: json['payment_info'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['amount_unpaid'] = amountUnpaid;
    data['amount'] = amount;
    data['tax'] = tax;
    data['additional_fee'] = additionalFee;
    data['status'] = status;
    data['note'] = note;
    data['amount_paid_to_date'] = amountPaidToDate;
    data['payment_info'] = paymentInfo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class City {
  int? id;
  int? stateId;
  int? countryId;
  String? name;
  String? latitude;
  String? longitude;
  int? status;
  int? order;

  City(
      {this.id,
      this.stateId,
      this.countryId,
      this.name,
      this.latitude,
      this.longitude,
      this.status,
      this.order});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateId = json['state_id'];
    countryId = json['country_id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    order = json['order'];
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
}

class State {
  int? id;
  int? countryId;
  String? name;
  String? code;
  int? status;
  int? order;

  State(
      {this.id, this.countryId, this.name, this.code, this.status, this.order});

  State.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    name = json['name'];
    code = json['code'];
    status = json['status'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['country_id'] = countryId;
    data['name'] = name;
    data['code'] = code;
    data['status'] = status;
    data['order'] = order;
    return data;
  }
}

class Country {
  int? id;
  String? name;
  String? code;
  int? status;
  int? order;

  Country({this.id, this.name, this.code, this.status, this.order});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    status = json['status'];
    order = json['order'];
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
