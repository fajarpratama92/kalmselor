import 'dart:async';

import 'package:counselor/api/api.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/counselor-client-model.dart';
import 'package:counselor/model/user_model/user_data.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../color/colors.dart';
import '../tab_pages/chat_room.dart';
import '../widget/persistent_tab/persistent_tab_util.dart';
import '../widget/space.dart';

class CounselorChatController extends GetxController {
  CounselorClientResModel? counselorClient(BuildContext context) =>
      STATE(context).counselorClientResModel;
  List<UnreadMessageClient> unreadMessageList = [];
  bool _loading = false;

  // set loading false
  void setLoading(bool loading) {
    _loading = !loading;
    update();
  }

  Stream<DatabaseEvent> unreadMessage({required ClientStatusModel? client}) {
    return FirebaseDatabase.instance
        .ref()
        .child("chats/${client?.matchupId.toString()}")
        .orderByChild("code")
        .equalTo("${client?.code}")
        .onValue;
  }

  Query clientLastMessage({required ClientStatusModel? client}) {
    return FirebaseDatabase.instance
        .ref()
        .child("chats/${client?.matchupId.toString()}")
        .limitToLast(1);
  }

  UserData? get userData => PRO.userData;
  bool get isStopRequest =>
      PRO.userData?.userSetting?.counselorStopRequest == 1;

  List<Map<String, dynamic>>? _clientData(BuildContext context) {
    try {
      return counselorClient(context)
          ?.data!
          .map((w) => {
                "id": w.userId,
                "matchup_availble_at": w.matchupAvailableAt,
                "total_subs_list":
                    w.clientResData?.userSubscriptionList?.length,
                "update_tnc_at": w.updatedAt,
                "matchup_id": w.id,
                "agreement_token": w.agreementToken,
                "onesignal_token": w.clientResData?.onesignalToken,
                "isUniqCode": (w.isUniqueCode == 1),
                "is_coorporate":
                    (w.clientResData?.userVoucher?.isCorporate == 1),
                "status": w.status,
                "is_read_tnc": (w.isReadTnc == 1),
                "email": w.clientResData?.email,
                "name":
                    "${w.clientResData?.firstName?.capitalizeFirst} ${w.clientResData?.lastName?.capitalizeFirst ?? ""}",
                "photo": w.clientResData?.photo,
                "device_type": w.clientResData?.deviceType,
                "code": w.clientResData?.code,
                "package_start_at": w.clientResData?.userSubscription?.startAt,
                "package_end_at": w.clientResData?.userSubscription?.endAt,
                "canChat": ((w.clientResData?.userSubscription != null))
              })
          .toList();
    } catch (e) {
      return [];
    }
  }

  List<ClientStatusModel> clientList(BuildContext context) => List.generate(
      _clientData(context)!.length,
      (i) => ClientStatusModel.fromJson(_clientData(context)![i]));

  Future<void> getStopRequest() async {
    try {
      var _res = await Api().POST(
        STOP_CLIENT_REQUEST,
        {
          "counselor_stop_request": isStopRequest ? 0 : 1,
        },
        useToken: true,
      );

      if (_res?.statusCode == 200) {
        await PRO.setUserSession(data: UserModel.fromJson(_res?.data));
        await PRO.getCounselorClientList(
            _res?.data?["data"]["code"].toString() ?? PRO.userData!.code!);
      }
    } catch (e) {
      print(e);
      // print("SOMETHING WRONG");
    }
    Loading.hide();
  }

  void toChatRoom(BuildContext context,
      {required ClientStatusModel clientListData}) {
    // var _chatRef = FirebaseDatabase.instance
    //     .ref()
    //     .child("chats/${clientListData.matchupId}");
    // _chatRef
    //     .orderByChild("code")
    //     .equalTo(clientListData.code)
    //     .once()
    //     .then((event) {
    //   if (event.snapshot.value == null) {
    //     return;
    //   }
    //   (event.snapshot.value as dynamic).forEach((k, v) {
    //     _chatRef.child(k).child("status").set("read");
    //   });
    // });
    // _chatRef.keepSynced(true);
    // PRO.setBadgesReference(false, clientListData.code);
    pushNewScreen(context, screen: ChatRoomPage(client: clientListData));
    // Get.to(() => ChatRoomPage(client: clientListData));
  }

  void acceptOrRejectClient(bool isAccept,
      {String? token, required BuildContext context}) async {
    if (token == null) {
      snackBars(message: "agreement token not found");
      await PRO.getCounselorClientList('null');
      Get.back();
      return;
    }
    // print("${(isAccept) ? "ACC" : "REJECT"}");
    var _payload =
        AgreementModel(agreement: (isAccept) ? 1 : 0, agreementToken: token);
    AgreementModel(agreement: (isAccept) ? 1 : 0, agreementToken: token);
    dialogAcceptTnc(
        isAccept: isAccept,
        barrierDismissible: false,
        payload: _payload.toJson(),
        context: context);
  }

  dialogAcceptTnc(
      {bool barrierDismissible = true,
      required bool isAccept,
      required Map<String, dynamic>? payload,
      required BuildContext context}) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Builder(builder: (context) {
                if (_loading) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Mohon menunggu..",
                        style: TextStyle(
                            fontSize: 20,
                            color: BLUEKALM,
                            fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                      SPACE(),
                      const CupertinoActivityIndicator(radius: 20)
                    ],
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Konfirmasi",
                          style: TextStyle(
                              fontSize: 25,
                              color: BLUEKALM,
                              fontWeight: FontWeight.w900)),
                      Text(
                        !isAccept
                            ? "Yakin Anda menolak\nKlien tersebut"
                            : "Yakin Anda menerima\nKlien tersebut",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Image.asset(
                              'assets/others/accept.png',
                            ),
                            onPressed: () async {
                              popScreen(context);
                              // Loading.show(context: context);
                              PRO.removeCounselorClientList();
                              WrapResponse? _res = await Api().POST(
                                  COUNSELOR_DECIDE, payload,
                                  useToken: true, useLoading: false);
                              if (_res?.statusCode == 200) {
                                await PRO.getCounselorClientList(
                                  PRO.userData!.code!,
                                  useLoading: false,
                                );
                                // snackBars(message: "${_res?.message}");
                                // pushRemoveUntilScreen(context,
                                //     screen: CounselorChatPage());
                                // pushReplacementNewScreen(context,
                                //     screen: CounselorChatPage());
                                // Get.off(() => CounselorChatPage());
                              } else {
                                await PRO.getCounselorClientList(
                                    PRO.userData!.code!,
                                    useLoading: false);
                                // snackBars(message: "${_res?.message}");
                                // pushReplacementNewScreen(context,
                                //     screen: CounselorChatPage());
                                // Get.off(() => CounselorChatPage());
                              }
                              // Loading.hide();
                            },
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/others/decline.png',
                            ),
                            onPressed: () => Get.back(),
                          ),
                        ],
                      )
                    ],
                  );
                }
              }),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            );
          },
        );
      },
    );
  }

  Timer? timer;
  static bool? checkClientTimer = true;

  @override
  void onInit() {
    Timer.periodic(
      const Duration(seconds: 30),
          (Timer t) async {
        print("check client timer $checkClientTimer");
        if (PRO.userData?.code != null) {
          await PRO.getCounselorClientList(PRO.userData!.code!, useLoading: false);
        }
        if (checkClientTimer == false) {
          cancelTimer();
          t.cancel();
        }
      },
    );
    checkClientTimer = true;
    super.onInit();
  }

  cancelTimer() {
    checkClientTimer = false;
    timer?.cancel();
  }
}

class ClientStatusModel {
  int? id;
  int? matchupId;
  bool? isUniqCode;
  bool? isReadTnc;
  String? email;
  String? name;
  String? photo;
  String? packageStartAt;
  String? packageEndAt;
  String? onesignalToken;
  int? deviceType;
  String? code;
  String? agreementToken;
  int? totalSubsList;
  String? updateTncAt;
  bool? canChat;
  String? matchupAvailableAt;
  int? status;
  bool? isCoorporate;
  // "city_id": 90,
  //       "state_id": 5,
  //       "country_id": 1,
  // int? cityId;
  // int? stateId;
  // int? countryId;
  // String? dob;

  ClientStatusModel({
    id,
    matchupId,
    isUniqCode,
    isReadTnc,
    email,
    name,
    photo,
    packageStartAt,
    packageEndAt,
    onesignalToken,
    canChat,
    deviceType,
    isCoorporate,
    code,
    agreementToken,
    matchupAvailableAt,
    updateTncAt,
    totalSubsList,
    status,
    cityId,
    // stateId,
    // countryId,
    // dob,
  });

  ClientStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    matchupId = json['matchup_id'];
    isUniqCode = json['isUniqCode'];
    isReadTnc = json['is_read_tnc'];
    email = json['email'];
    name = json['name'];
    photo = json['photo'];
    packageStartAt = json['package_start_at'];
    packageEndAt = json['package_end_at'];
    canChat = json['canChat'];
    onesignalToken = json['onesignal_token'];
    deviceType = json['device_type'];
    code = json['code'];
    agreementToken = json['agreement_token'];
    isCoorporate = json['is_coorporate'];
    updateTncAt = json['update_tnc_at'];
    totalSubsList = json['total_subs_list'];
    matchupAvailableAt = json['matchup_availble_at'];
    status = json['status'];
    // cityId = json['city_id'];
    // stateId = json['state_id'];
    // countryId = json['country_id'];
    // dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['matchup_id'] = matchupId;
    data['isUniqCode'] = isUniqCode;
    data['is_read_tnc'] = isReadTnc;
    data['email'] = email;
    data['name'] = name;
    data['photo'] = photo;
    data['package_start_at'] = packageStartAt;
    data['package_end_at'] = packageEndAt;
    data['canChat'] = canChat;
    data['onesignal_token'] = onesignalToken;
    data['device_type'] = deviceType;
    data['code'] = code;
    data['agreement_token'] = agreementToken;
    data['is_coorporate'] = isCoorporate;
    data['update_tnc_at'] = updateTncAt;
    data['total_subs_list'] = totalSubsList;
    data['matchup_availble_at'] = matchupAvailableAt;
    data['status'] = status;
    // data['city_id'] = cityId;
    // data['state_id'] = stateId;
    // data['country_id'] = countryId;
    // data['dob'] = dob;
    return data;
  }

  @override
  String toString() {
    return "matchupid : $matchupId \n"
        "isUniqCode : $isUniqCode \n"
        "isReadTnc : $isReadTnc \n"
        "email : $email \n"
        "name : $name \n"
        "photo : $photo \n"
        "packageStartAt : $packageStartAt \n"
        "packageEndAt : $packageEndAt \n"
        "onesignalToken : $onesignalToken \n"
        "deviceType : $deviceType \n"
        "code : $code \n"
        "agreementToken : $agreementToken \n"
        "isCoorporate : $isCoorporate \n"
        "updateTncAt : $updateTncAt \n"
        "totalSubsList : $totalSubsList \n"
        "matchupAvailableAt : $matchupAvailableAt \n"
        "status : $status \n";
    // "cityId : $cityId \n"
    // "stateId : $stateId \n" +
    // "countryId : $countryId \n" +
    // "dob : $dob \n";
  }
}

class AgreementModel {
  String? agreementToken;
  int? agreement;

  AgreementModel({required this.agreementToken, required this.agreement});

  AgreementModel.fromJson(Map<String, dynamic> json) {
    agreementToken = json['agreement_token'];
    agreement = json['agreement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agreement_token'] = agreementToken;
    data['agreement'] = agreement;
    return data;
  }
}

class ClientMatchStatus {
  String? matchBy;
  List<ClientStatusModel>? data;

  ClientMatchStatus({required this.matchBy, required this.data});

  ClientMatchStatus.fromJson(Map<String, dynamic> json) {
    matchBy = json['match_by'];
    if (json['data'] != null) {
      data = <ClientStatusModel>[];
      json['data'].forEach((v) {
        data?.add(ClientStatusModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['match_by'] = matchBy;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UnreadMessageClient {
  String? code;
  dynamic? unread;
  String? lastChat;

  UnreadMessageClient({this.code, this.unread});

  UnreadMessageClient.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    unread = json['unread'];
    lastChat = json['last_chat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['unread'] = unread;
    data['last_chat'] = lastChat;
    return data;
  }
}
