import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/counselor-chat-controller.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/widget/box_border.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/counselor_data.dart';
import '../widget/avatar-image.dart';
import '../widget/button.dart';

class CounselorChatPage extends StatelessWidget {
  CounselorChatPage({Key? key}) : super(key: key);

  final _chatController = Get.put(CounselorChatController());
  @override
  Widget build(BuildContext context) {
    return SAFE_AREA(
      context: context,
      // bottomPadding: 0,
      useAppBar: false,
      child: GetBuilder<CounselorChatController>(
        initState: (state) => log(PRO.counselorClientResModel.toString()),
        builder: (_) {
          return Builder(
            builder: (context) {
              switch (STATE(context).counselorClientResModel == null) {
                case true:
                  return CustomWaiting().defaut();
                case false:
                  bool _stopReq =
                      PRO.userData?.userSetting?.counselorStopRequest == 1;
                  return SizedBox(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        print("refresh");
                        await PRO.removeCounselorClientResModel();
                        await PRO.getCounselorClientList(PRO.userData!.code!);
                        await PRO.updateSession(
                            context: context, useLoading: false);
                      },
                      child: _categoryList(_stopReq, _, context),
                    ),
                  );
                default:
                  return Container();
              }
            },
          );
        },
      ),
    );
  }

  ListView _categoryList(
      bool _stopReq, CounselorChatController _, BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              _stopRequest("Terima Klien Baru",
                  controller: _stopReq,
                  onTap: () async => await _.getStopRequest()),
              _listClientChat(
                  _
                      .clientList(context)
                      .where((w) =>
                          w.canChat! &&
                          w.agreementToken == null &&
                          w.isReadTnc!)
                      .toList(),
                  title: "Daftar Klien"),
              _listClientChat(
                  _
                      .clientList(context)
                      .where((w) =>
                          w.agreementToken == null &&
                          w.canChat! &&
                          !w.isReadTnc!)
                      .toList(),
                  title: "Menunggu Persetujuan Klien"),
              _listClientChat(
                  _
                      .clientList(context)
                      .where((w) => w.agreementToken != null)
                      .toList(),
                  title: "Klien Yang Menunggu"),
              _listClientChat(
                  _
                      .clientList(context)
                      .where((w) => w.totalSubsList == 0)
                      .toList(),
                  title: "Klien Tidak Aktif"),
            ],
          ),
        )
      ],
    );
  }

  Widget _listClientChat(
    List<ClientStatusModel> _data, {
    String? title,
  }) {
    if (_data.isEmpty) {
      return Column(
        children: [
          SPACE(),
          // TEXT("Tidak ada klien yang ditunggu"),
          SPACE(),
        ],
      );
    }
    // ignore: missing_return
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(thickness: 2),
          SPACE(),
          TEXT(title, style: titleApp20),
          SPACE(),
          const Divider(thickness: 2),
          SPACE(),
          _clientList(_data, context),
          SPACE(),
        ],
      );
    });
  }

  String? _matchupAvailbleAt(String? date) {
    if (date == null) {
      return null;
    } else {
      return DateFormat("dd-MM-y")
          .addPattern('jm')
          .format(DateTime.parse(date));
    }
  }

  Column _clientList(List<ClientStatusModel> _data, BuildContext context) {
    if (_data.isEmpty) {
      return Column(
        children: [
          SPACE(),
          // TEXT("Tidak ada klien yang ditunggu"),
          SPACE(),
        ],
      );
    }
    return Column(

      children: List.generate(_data.length, (i) {
        bool _isPrivate = _data[i].code?.contains("PRIV") == true;
        bool _clientNoPackage = (_data[i].totalSubsList == 0 && !_isPrivate);
        bool _matchUniqCode = (_data[i].isUniqCode! &&
            _data[i].agreementToken != null &&
            !_data[i].isCoorporate!);
        bool _matchCoorporate = (_data[i].isCoorporate! &&
            _data[i].agreementToken != null &&
            _data[i].isUniqCode!);
        return TextButton(
            onPressed: _toChatRoom(_data, i, context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Builder(builder: (context) {
                        if (_data[i].photo == null) {
                          return Avatar(
                            null,
                            radius: 20,
                            nullImgUrlScale: 10,
                          );
                        } else {
                          return Avatar(
                            "${IMAGE_URL + "users/"}${_data[i].photo}",
                            radius: 20,
                          );
                        }
                      }),
                      SPACE(),
                      _clientStatus(
                        data: _data,
                        i: i,
                        clientNoPackage: _clientNoPackage,
                        matchUniqCode: _matchUniqCode,
                        matchCoorporate: _matchCoorporate,
                      )
                    ],
                  ),
                ),
                if (_data[i].totalSubsList! > 0)
                  SizedBox(
                    child: Row(
                      children: [
                        _unreadMessage(_data[i]),
                        _acceptTnc(_data, i),
                      ],
                    ),
                  ),
              ],
            ));
      }),
    );
  }

  Expanded _clientStatus({
    required List<ClientStatusModel> data,
    required int i,
    required bool clientNoPackage,
    required bool matchUniqCode,
    required bool matchCoorporate,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              data[i].name.toString(),
              softWrap: false,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: BLUEKALM,
              ),
            ),
          ),
          if (clientNoPackage)
            Row(
              children: [
                const Icon(Icons.do_disturb_alt_rounded,
                    color: ORANGEKALM, size: 13),
                SPACE(width: 5),
                const Text("Klien tidak memiliki paket berlangganan",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          if (matchUniqCode)
            const Text("Matched by : Kalmselor Code",
                style: TextStyle(color: Colors.grey)),
          if (matchCoorporate) const Text("Matched by : Kalmselor Code"),
          if (data[i].agreementToken != null &&
              !matchCoorporate &&
              !matchUniqCode)
            const Text("Matched by : System",
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          if (data[i].agreementToken != null &&
              _matchupAvailbleAt(data[i].matchupAvailableAt) != null)
            Text("${_matchupAvailbleAt(data[i].matchupAvailableAt)}"),
          if (data[i].totalSubsList! > 0 && data[i].status == 1)
            SizedBox(
              width: (Get.size.width / 1.8),
              child: FirebaseAnimatedList(
                shrinkWrap: true,
                query: _chatController.clientLastMessage(client: data[i]),
                itemBuilder: (context, snap, anim, i) {
                  Map<dynamic, dynamic>? data = snap.value as Map?;
                  return Text(
                    "${data!['message']}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  Function()? _toChatRoom(
      List<ClientStatusModel> _data, int i, BuildContext context) {
    if (_data[i].agreementToken != null) {
      return null;
    } else if (_data[i].totalSubsList == 0) {
      return () {
        Get.dialog(
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BOX_BORDER(
                  Center(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left:10.0,right:10,top:10,bottom:10),
                        child: Material(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Perhatian",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: BLUEKALM,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SPACE(height: 5),
                              TEXT(
                                "\nKlien ini tidak memiliki paket berlangganan, tunggu klien membeli paket berlangganan untuk melanjutkan sesi konseling",
                                // style: COSTUM_TEXT_STYLE(
                                //   color: Colors.red,
                                //   fontStyle: FontStyle.italic,
                                // ),
                                textAlign: TextAlign.center,
                              ),
                              SPACE(
                                height: 20
                              ),
                              SizedBox(
                                // width: Get.width / 2,
                                // height: Get.height /1,
                                child: BUTTON(
                                  "Kembali",
                                  onPressed: () async {
                                    Get.back();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // height: Get.height / 5,
                  width: Get.width / 1.5,
                  height: 220,
                  fillColor: Colors.white,
                ),
              ],
            ),
          ),
        );
        // Cms().dialog(
        //     desc:
        //     "\nKlien ini tidak memiliki paket berlangganan, tunggu klien membeli paket berlangganan untuk melanjutkan sesi konseling",
        //     title: "Perhatian",
        //     buttonTitle: "Kembali",
        //     onPress: () {
        //       Get.back();
        //     });
      };
    }
    return () => _chatController.toChatRoom(context, clientListData: _data[i]);
  }

  Builder _acceptTnc(List<ClientStatusModel> _data, int i) {
    // ignore: missing_return
    return Builder(builder: (context) {
      switch (_data[i].agreementToken == null) {
        case true:
          return Transform.rotate(
              angle: math.pi / 1.0,
              child:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.grey));
        case false:
          return Row(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/others/accept.png',
                  scale: 5,
                  color: GREENKALM,
                ),
                onPressed: () => _chatController.acceptOrRejectClient(true,
                    token: _data[i].agreementToken!, context: context),
              ),
              if (!_data[i].isCoorporate!)
                IconButton(
                  icon: Image.asset(
                    'assets/others/decline.png',
                    scale: 5,
                  ),
                  onPressed: () => _chatController.acceptOrRejectClient(false,
                      token: _data[i].agreementToken!, context: context),
                )
            ],
          );
        default:
      }
      return build(context);
    });
  }


  CounselorData? counselorData;

  StreamBuilder<dynamic> _unreadMessage(ClientStatusModel client) {
    // DatabaseReference _badgesRef = FirebaseDatabase.instance
    //     .ref()
    //     .child('user_statuses/${counselorData?.counselor!.code!}');
    return StreamBuilder<dynamic>(
      stream: _chatController.unreadMessage(client: client),
      builder: (context, stream) {
        if (stream.data?.snapshot?.value != null) {
          Map<dynamic, dynamic> _data = stream.data?.snapshot?.value;
          if (_data.values.where((e) => e['status'] == "unread").isEmpty) {
            STATE(context).newBadge == false;
            // // try {
            //   _badgesRef.update({"badges": false});
            // // } catch (e) {
            // //   print(e);
            // // }
            return Container();
          } else {
            STATE(context).newBadge == true;
            // // try {
            //   _badgesRef.update({"badges": true});
            // // } catch (e) {
            // //   print(e);
            // // }
            // // print("${counselorData?.counselor!.code!}");
            return CircleAvatar(
              backgroundColor: ORANGEKALM,
              radius: 10,
              child: Text(
                "${_data.values.where((e) => e['status'] == "unread").length}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Column _stopRequest(
    String title, {
    bool? controller,
    Function()? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SPACE(),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: titleApp20),
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                onPressed: onTap,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: controller!
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 1,
                                    color: controller ? BLUEKALM : ORANGEKALM)),
                          ),
                        )
                      ],
                    ),
                  ),
                  height: 25,
                  width: 50,
                  decoration: BoxDecoration(
                      color: controller ? Colors.white : ORANGEKALM,
                      border: Border.all(width: 1, color: ORANGEKALM),
                      borderRadius: BorderRadius.circular(20)),
                ),
              )
            ],
          ),
        ),
        SPACE(),
      ],
    );
  }
}
