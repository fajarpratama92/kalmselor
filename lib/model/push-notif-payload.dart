import 'package:flutter/material.dart';

class PushNotifPayload {
  String? appId;
  List<String>? includePlayerIds;
  String? iosBadgeType;
  int? iosBadgeCount;
  Contents? contents;
  PushData? data;
  String? largeIcon;
  String? androidGroup;

  PushNotifPayload({
    required this.appId,
    includePlayerIds,
    required this.iosBadgeType,
    required this.iosBadgeCount,
    required this.contents,
    required this.data,
    largeIcon,
    required this.androidGroup,
  });

  PushNotifPayload.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    includePlayerIds = json['include_player_ids'].cast<String>();
    iosBadgeType = json['ios_badgeType'];
    iosBadgeCount = json['ios_badgeCount'];
    contents = json['contents'] != null
        ? new Contents.fromJson(json['contents'])
        : null;
    data = json['data'] != null ? new PushData.fromJson(json['data']) : null;
    largeIcon = json['large_icon'];
    androidGroup = json['android_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['include_player_ids'] = this.includePlayerIds;
    data['ios_badgeType'] = this.iosBadgeType;
    data['ios_badgeCount'] = this.iosBadgeCount;
    if (this.contents != null) {
      data['contents'] = this.contents?.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['large_icon'] = largeIcon;
    data['android_group'] = androidGroup;
    return data;
  }
}

class Contents {
  String? en;

  Contents({required this.en});

  Contents.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    return data;
  }
}

class PushData {
  String? type;
  UserPushData? user;
  String? room;

  PushData({required this.type, required this.user, required this.room});

  PushData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    user =
        json['user'] != null ? new UserPushData.fromJson(json['user']) : null;
    room = json['room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    data['room'] = this.room;
    return data;
  }
}

class UserPushData {
  String? code;
  String? firstName;
  String? lastName;
  String? photo;
  Map<String, dynamic>? userSetting;

  UserPushData({
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.photo,
    required this.userSetting,
  });

  UserPushData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    photo = json['photo'];
    userSetting = json['user_setting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['photo'] = this.photo;
    data['user_setting'] = this.userSetting;
    return data;
  }
}
