import 'dart:async';
import 'dart:convert';

import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/push-notif-payload.dart';
import 'package:counselor/sdk/firebase.dart';
import 'package:counselor/utilities/clipboard.dart' as clipboard;
import 'package:counselor/widget/button.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/swipe_to.dart';
import 'package:counselor/widget/waiting.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api.dart';
import '../color/colors.dart';
import '../controller/counselor-chat-controller.dart';
import '../model/item_chat_model.dart';
import '../model/user_model/user_data.dart';
import '../pages/client/client-profile.dart';
import '../widget/avatar-image.dart';
import '../widget/persistent_tab/persistent_tab_util.dart';
import '../widget/space.dart';
import '../widget/text.dart';

class ChatRoomPage extends StatelessWidget {
  final ClientStatusModel client;
  final controllerChat = Get.put(ChatRoomControllerCustom());
  ChatRoomPage({Key? key, required this.client}) : super(key: key);
  //bool isNotch = false;
  Widget _appBar(BuildContext context) {
    //isNotch = MediaQuery.of(context).viewPadding.bottom > 0;
    bool isNeedSafeArea = MediaQuery.of(context).viewPadding.bottom > 0;
    //print("isNeedSafeArea $isNeedSafeArea");
    return GestureDetector(
      onTap: () {
        pushNewScreen(context,
            screen: ClientProfilePage(email: client.email!, client: client));
      },
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Builder(
              builder: (context) {
                if (client.photo == null) {
                  return Avatar(null, radius: 25, nullImgUrlScale: 10);
                } else {
                  return Avatar("${IMAGE_URL + "users/"}${client.photo}",
                      radius: 25);
                }
              },
            ),
          ),
          Flexible(
            child: Text(
              client.name.toString(),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: BLUEKALM,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          SPACE(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SAFE_AREA(
      context: context,
      useAppBar: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: BLUEKALM,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          flexibleSpace: Padding(
            padding: EdgeInsetsDirectional.only(
                top: MediaQuery.of(context).padding.top, start: 30, end: 30),
            child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: _appBar(context)),
          ),
        ),
        body: GetBuilder<ChatRoomControllerCustom>(
          initState: (state) {
            controllerChat.backLimit();
          },
          // dispose: (state) {
          // },
          builder: (_) {
            return Column(
              children: [
                Expanded(
                  child: _chatView(_),
                ),
                // Container(
                //   height: 50,
                //   child: FirebaseAnimatedList(
                //       // key: ValueKey<bool>(_.loadMore),
                //       // physics:
                //       //     const ScrollPhysics(parent: BouncingScrollPhysics()),
                //       // controller: _.scrollController,
                //       duration: const Duration(seconds: 1),
                //       padding: const EdgeInsets.symmetric(horizontal: 10),
                //       query: controllerChat.ref.child("chats/100377"),
                //       itemBuilder: (context, snap, anim, i) {
                //         // try {
                //         log(snap.value.toString());
                //         return Container();
                //         //   ItemChatModel? _chat = _chatModel(snap);
                //         //   _chats.add(_chat);
                //         //   bool _isUser = PRO.userData?.code == _chat?.code;
                //         //   _.date?.add((DateTime.fromMillisecondsSinceEpoch(_chat!.created!)));
                //         //   int? _showDate = _filterDate(_, _chat);
                //         //   if (_chat != null && i == 0) {
                //         //     return _chatView(_showDate, i, _, _isUser, _chat);
                //         //   } else if (i != 0 && _chat != null) {
                //         //     return _chatView2(_showDate, i, _, _isUser, _chat, _chats[i - 1]);
                //         //   }
                //         //   return Container();
                //         // } catch (e) {
                //         //   return Container();
                //         // }
                //       }),
                // ),

                _messageField(_, context),
              ],
            );
          },
        ),
      ),
    );
  }

  StreamBuilder<DatabaseEvent> _chatView(ChatRoomControllerCustom _) {
    return StreamBuilder<DatabaseEvent>(
      stream: controllerChat.chatRef(matchupId: client.matchupId.toString()),
      // stream: controllerChat.chatRefNow(client.matchupId.toString()).onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ChatResDataModel> _chatDatas = [];
          Map? data = (snapshot.data?.snapshot.value as Map?);

          data?.forEach(
            (key, value) {
              try {
                _chatDatas.add(ChatResDataModel(
                  code: value["code"],
                  message: value["message"],
                  created: value["created"],
                  name: value["name"],
                  readed: value["readed"],
                  toCode: value["toCode"] ?? "",
                  status: value["status"],
                ));
              } catch (e) {}
            },
          );
          if (data == null || data.isEmpty) {
            return Container(
              color: Colors.white,
              child: const Center(),
            );
          } else {
            _.scroolToBottom(client);
            List<String> _timeFilter = _timeDateSort(_chatDatas);
            return CupertinoScrollbar(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                controller: _.scrollController,
                shrinkWrap: true,
                itemCount: _chatDatas.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      if (_chatDatas.length >= controllerChat.limit && i == 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child:
                              OUTLINE_BUTTON("Load more", onPressed: () async {
                            controllerChat.addLimit();
                          }, useExpanded: false),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _messageBox(_chatDatas, i, PRO.userData!,
                            timeFilter: _timeFilter),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        } else {
          return CustomWaiting().defaut();
        }
      },
    );
  }

  Column _messageField(ChatRoomControllerCustom _, context) {
    return Column(
      children: [
        if (_.buildReply != null) _.buildReply!,
        Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CupertinoTextField(
                placeholder: "Tulis pesan anda disini...",
                focusNode: _.messageFocus,
                controller: _.chatEditing,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 1,
                decoration: const BoxDecoration(
                    border: Border(
                      //top: BorderSide(color: Colors.red,width: 10),
                      //bottom: BorderSide(color:  Colors.red,width: 10),
                      //left: BorderSide(color: Colors.red),
                      top: BorderSide(color: Color(0xFFf0f0f0),width: 1),
                      bottom: BorderSide(color: Color(0xFFf0f0f0),width: 1),
                      //right: BorderSide(color: Colors.yellow),
                      //bottom: BorderSide(color: Colors.green),
                    )
                ),
                style: const TextStyle(
                  //fontSize: 17,
                  fontFamily: "MavenPro",
                ),
                onChanged: (val) async {
                  // if (val.isNotEmpty) {
                  //   await controllerChat.scrollController.animateTo(
                  //     controllerChat
                  //         .scrollController.position.maxScrollExtent,
                  //     duration: const Duration(milliseconds: 300),
                  //     curve: Curves.decelerate,
                  //   );
                  // }
                },
                maxLines: 4,
                padding: const EdgeInsetsDirectional.only(
                    end: 100, start: 15, bottom: 20, top: 20),
                textAlignVertical: TextAlignVertical.center,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: ORANGEKALM,
                  ),
                  onPressed: () async {
                    if (!_.messageValidation()) {
                      return;
                    }
                    await _.sendMessage(client);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  RoundedRectangleBorder _roundedRectangleBorder(bool primary,
      {double? radius}) {
    if (primary) {
      return RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(radius ?? 30),
              topLeft: Radius.circular(radius ?? 30),
              bottomLeft: Radius.circular(radius ?? 30)));
    } else {
      return RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius ?? 30),
        topRight: Radius.circular(radius ?? 30),
        bottomRight: Radius.circular(radius ?? 30),
      ));
    }
  }

  Padding _buildReplyMessage(List<ChatResDataModel> _chatDatas, int i,
      CrossAxisAlignment crossAxisAlignment) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 3),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10))),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  right: BorderSide(color: Colors.greenAccent, width: 4))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              crossAxisAlignment: _messageAligment(
                  (_chatDatas[i].reply != null), crossAxisAlignment),
              children: [
                Text(
                  _replyName(_chatDatas[i].code,
                      originalName: _chatDatas[i].replyName ?? ""),
                  // style: TEXTSTYLE(fontSize: 16, colors: Colors.pink),
                ),
                Text(
                  _chatDatas[i].reply ?? "",
                  // style: TEXTSTYLE(fontSize: 16, colors: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Builder _buildMessageWidget(
      Color backgroundColor,
      RoundedRectangleBorder roundedRectangleBorder,
      List<ChatResDataModel> _chatDatas,
      int i,
      CrossAxisAlignment crossAxisAlignment,
      {required bool primary}) {
    bool _isHTML =  _chatDatas[i].message.contains("<p>");
    return Builder(builder: (context) {
      if (_chatDatas[i].reply != null) {
        return Card(
          color: backgroundColor,
          shape: _roundedRectangleBorder(primary, radius: 10),
          child: Column(
            crossAxisAlignment: _messageAligment(
                (_chatDatas[i].reply != null), crossAxisAlignment),
            children: [
              _buildReplyMessage(_chatDatas, i, crossAxisAlignment),
              Padding(
                padding: _messagePadding(true),
                child:
                // Text(
                //   _chatDatas[i].message,
                //   // style: TEXTSTYLE(fontSize: 16, colors: Colors.white),
                // ),
                _isHTML
                    ? Html(
                  data: _chatDatas[i].message,
                  style: {
                    "p": Style(
                        whiteSpace: WhiteSpace.pre,
                        fontSize: FontSize(16),
                        color: Colors.white,
                        fontWeight: FontWeight.normal)
                  },
                )
                    : SelectableAutoLinkText(
                  _chatDatas[i].message,
                  style: COSTUM_TEXT_STYLE(color: Colors.white),
                  linkStyle: COSTUM_TEXT_STYLE(
                      color: Colors.blue[100],
                      decoration: TextDecoration.underline,
                      fontStyle: FontStyle.italic),
                  onTap: (url) => launch(url, forceSafariVC: false),
                  // onLongPress: (url) => Share.share(url),
                )
              )
            ],
          ),
        );
      } else {
        return Column(
          children: [
            Card(
              color: backgroundColor,
              shape: roundedRectangleBorder,
              child: Padding(
                padding: _messagePadding((_chatDatas[i].reply != null)),
                child:
                Column(
                  crossAxisAlignment: _messageAligment(
                      (_chatDatas[i].reply != null), crossAxisAlignment),
                  children: [
                    // Text(
                    //   _chatDatas[i].message,
                    //   style: const TextStyle(fontSize: 16, color: Colors.white),
                    // )
                    _isHTML
                        ? Html(
                      data: _chatDatas[i].message,
                      style: {
                        "p": Style(
                            whiteSpace: WhiteSpace.pre,
                            fontSize: FontSize(16),
                            color: Colors.white,
                            fontWeight: FontWeight.normal)
                      },
                    )
                        : SelectableAutoLinkText(
                      _chatDatas[i].message,
                      style: COSTUM_TEXT_STYLE(color: Colors.white),
                      linkStyle: COSTUM_TEXT_STYLE(
                          color: Colors.blue[100],
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic),
                      onTap: (url) => launch(url, forceSafariVC: false),
                      // onLongPress: (url) => Share.share(url),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  Builder _messageBox(List<ChatResDataModel> _chatDatas, int i, UserData _user,
      {required List<String> timeFilter}) {
    return Builder(
      builder: (context) {
        var _time = DateFormat("jm")
            .format(DateTime.fromMillisecondsSinceEpoch(_chatDatas[i].created));

        int _timeFilterIndex = timeFilter.indexWhere((element) =>
            element.contains(DateFormat("dd MMMM y").format(
                DateTime.fromMillisecondsSinceEpoch(_chatDatas[i].created))));
        if (_chatDatas[i].code == "") {
          return Container();
        }

        switch (_user.code == _chatDatas[i].code) {
          case true:
            return Column(
              children: [
                if (i == _timeFilterIndex) _timefilter(timeFilter, i),
                SwipeTo(
                  // onLeftSwipe: () => _chatRoomController.swipeMessage(data: _chatDatas[i]),
                  child: _messageAlignment(
                    _chatDatas,
                    i,
                    _time,
                    cardPadding: const EdgeInsetsDirectional.only(start: 50),
                    crossAxisAlignment: CrossAxisAlignment.end,
                    alignmentText: Alignment.centerRight,
                    backgroundColor: BLUEKALM,
                    timePadding: const EdgeInsetsDirectional.only(end: 10),
                    roundedRectangleBorder: _roundedRectangleBorder(true),
                    primary: true,
                  ),
                ),
              ],
            );

          case false:
            return Column(
              children: [
                if (i == _timeFilterIndex) _timefilter(timeFilter, i),
                SwipeTo(
                  // onRightSwipe: () => _chatRoomController.swipeMessage(data: _chatDatas[i]),
                  child: _messageAlignment(
                    _chatDatas,
                    i,
                    _time,
                    cardPadding: const EdgeInsetsDirectional.only(end: 50),
                    alignmentText: Alignment.centerLeft,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    roundedRectangleBorder: _roundedRectangleBorder(false),
                    backgroundColor: ORANGEKALM,
                    timePadding: const EdgeInsetsDirectional.only(start: 10),
                    primary: false,
                  ),
                ),
              ],
            );
          default:
            return Container(
              color: Colors.white,
            );
        }
      },
    );
  }

  Align _messageAlignment(
      List<ChatResDataModel> _chatDatas, int i, String _time,
      {required RoundedRectangleBorder roundedRectangleBorder,
      required Color backgroundColor,
      required EdgeInsetsGeometry timePadding,
      required Alignment alignmentText,
      required cardPadding,
      required CrossAxisAlignment crossAxisAlignment,
      required bool primary}) {
    return Align(
      alignment: alignmentText,
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            GestureDetector(
              onLongPress: () =>
                  controllerChat.openTooltip(message: _chatDatas[i].message),
              child: _buildMessageWidget(
                backgroundColor,
                roundedRectangleBorder,
                _chatDatas,
                i,
                crossAxisAlignment,
                primary: primary,
              ),
            ),
            Row(
              mainAxisAlignment: (crossAxisAlignment == CrossAxisAlignment.end)
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (_isSending(crossAxisAlignment, _chatDatas, i))
                  const ImageIcon(ExactAssetImage('assets/others/tick.png'),
                      size: 12, color: Colors.grey),
                if (_isSending(crossAxisAlignment, _chatDatas, i))
                  SPACE(width: 8),
                if (_isReaded(crossAxisAlignment, _chatDatas, i))
                  const ImageIcon(
                      ExactAssetImage('assets/others/double-tick.png'),
                      size: 12,
                      color: Colors.grey),
                if (_isReaded(crossAxisAlignment, _chatDatas, i))
                  SPACE(width: 8),
                if (_isPending(crossAxisAlignment, _chatDatas, i))
                  const ImageIcon(
                      ExactAssetImage('assets/others/tick-clock.png'),
                      size: 12),
                if (_isPending(crossAxisAlignment, _chatDatas, i))
                  SPACE(width: 8),
                Padding(
                  padding: timePadding,
                  child: Text(
                    _time,
                    style: const TextStyle(fontSize: 10, color: BLUEKALM),
                  ),
                ),
              ],
            ),
            SPACE(width: 4),
          ],
        ),
      ),
    );
  }

  EdgeInsetsGeometry _messagePadding(bool isReply) {
    switch (isReply) {
      case true:
        return const EdgeInsetsDirectional.only(
            start: 10, top: 5, bottom: 5, end: 10);
      case false:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      default:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    }
  }

  Padding _timefilter(List<String> timeFilter, int i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              timeFilter[i],
              style:
                  const TextStyle(color: BLUEKALM, fontWeight: FontWeight.w700),
            ),
          ),
          const Divider(thickness: 2),
        ],
      ),
    );
  }

  CrossAxisAlignment _messageAligment(
      bool isReply, CrossAxisAlignment defaultAlign) {
    switch (isReply) {
      case true:
        return CrossAxisAlignment.start;
      case false:
        return defaultAlign;
      default:
        return defaultAlign;
    }
  }

  List<String> _timeDateSort(List<ChatResDataModel> _chatDatas) {
    var _timeFilter = <String>[];

    _dateSort(_chatDatas);

    _timeFilter = List.generate(
        _chatDatas.length,
        (t) => DateFormat("dd MMMM y").format(
            DateTime.fromMillisecondsSinceEpoch(_chatDatas[t].created)));

    return _timeFilter;
  }

  void _dateSort(List<ChatResDataModel> _chatDatas) {
    _chatDatas.sort(
      (a, b) {
        return DateTime.fromMillisecondsSinceEpoch(a.created)
            .compareTo(DateTime.fromMillisecondsSinceEpoch(b.created));
      },
    );
  }

  bool _isPending(CrossAxisAlignment crossAxisAlignment,
      List<ChatResDataModel> _chatDatas, int i) {
    return (crossAxisAlignment == CrossAxisAlignment.end) &&
        (_chatDatas[i].readed == "false");
  }

  bool _isSending(CrossAxisAlignment crossAxisAlignment,
      List<ChatResDataModel> _chatDatas, int i) {
    return (crossAxisAlignment == CrossAxisAlignment.end) &&
        (_chatDatas[i].readed == "sending");
  }

  bool _isReaded(CrossAxisAlignment crossAxisAlignment,
      List<ChatResDataModel> _chatDatas, int i) {
    return (crossAxisAlignment == CrossAxisAlignment.end) &&
        (_chatDatas[i].readed == "no" || _chatDatas[i].readed == "yes");
  }

  String _replyName(String code, {required String originalName}) {
    return originalName;
  }
}

const String _offlineConnection =
    """{"message":"Please check your internet connection"}""";

// CONTROLLER
class ChatRoomControllerCustom extends GetxController {
  Widget? buildReply;

  DatabaseReference ref = FirebaseDatabase.instance.ref();
  TextEditingController chatEditing = TextEditingController();
  ScrollController scrollController = ScrollController();
  final StreamCustom _streamController = StreamCustom();
  int limit = 10;

  addLimit() {
    limit = limit + 10;
    update();
  }

  backLimit() {
    limit = 10;
    update();
  }

  Stream<DatabaseEvent> chatRef({required String matchupId}) {
    return ref.child("chats/$matchupId").limitToLast(limit).onValue;
  }

  addStream({required String matchupId}) {
    _streamController.addResponse(chatRef(matchupId: matchupId));
  }

  DatabaseReference chatRefNow(String matchupId) =>
      ref.child("chats/$matchupId");

  UserData get _userData => PRO.userData!;
  // setBadgesReference(bool? isBadges, String? code) {
  //   if (code == null) return;
  //   DatabaseReference _badgesRef = ref.child('user_statuses/$code');
  //   _badgesRef.update({"badges": isBadges});
  // }

  Future<void> sendMessage(ClientStatusModel client) async {
    var _net = await IS_ACTIVE_NETWORK();
    if (!_net) {
      snackBars(message: '${jsonDecode(_offlineConnection)['message']}');
    }
    String _message = chatEditing.text;
    chatEditing.clear();
    await ref
        .child("chats/${client.matchupId}")
        .push()
        .set(_messageData(_message, isConnect: _net, client: client))
        .whenComplete(() {
      _reply = null;
      _replyName = null;
      buildReply = null;
      // PRO.setBadgesReference(true, client.code);
      // if (Platform.isIOS) {
      //   update();
      // }
      if (scrollController.hasClients) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.decelerate);
        if (buildReply != null) {
          buildReply = null;
          update();
        } else {
          return;
        }
      } else {
        return;
      }
    });
    var _payload = WonderPushPayload(
        content: _message,
        userId: client.id ?? 0,
        title: "${PRO.userData?.firstName} ${PRO.userData?.lastName}");
    try {
      if (client.onesignalToken == null) {
        return;
      }
      await Api().WonderPushNotif(_payload);
      updateReaded(
        readed: true,
        isConnect: true,
        matchupId: client.matchupId.toString(),
        clientCode: client.code!,
      );
    } catch (e) {
      snackBars(message: e.toString());
    }
    Loading.hide();
  }

  updateReaded({
    bool readed = false,
    bool isConnect = false,
    bool isSending = false,
    required String matchupId,
    required String clientCode,
  }) {
    switch (readed) {
      case true:
        chatRefNow(matchupId)
            .orderByChild("code")
            .equalTo(clientCode)
            .once()
            .then((event) {
          // Map? data = (snapshot.data?.snapshot.value as Map?);
          Map? _data = event.snapshot.value as Map?;
          _data?.forEach((k, v) {
            chatRefNow(matchupId).child(k).child("status").set("read");
          });
        });
        chatRefNow(matchupId)
            .orderByChild("code")
            .equalTo(_userData.code)
            .once()
            .then((event) {
          // Map _data = event.snapshot.value as Map;
          Map? _data = event.snapshot.value as Map?;

          _data?.forEach((k, v) {
            chatRefNow(matchupId).child(k).child("readed").set("yes");
          });
        });
        break;
      case false:
        return;
      default:
    }
  }

  Future<bool> sendPushNotif(
      {required String content, required ClientStatusModel client}) async {
    if (client.onesignalToken == null) {
      return false;
    }
    PushNotifPayload _payload = PushNotifPayload(
        appId: client.deviceType == 1
            ? iosFirebaseOption.appId
            : androidFirebaseOption.appId,
        includePlayerIds: [client.onesignalToken],
        iosBadgeType: "Increase",
        iosBadgeCount: 1,
        contents: Contents(en: "${_userData.firstName}: $content"),
        data: PushData(
            type: "chat",
            user: UserPushData(
                code: _userData.code,
                firstName: _userData.firstName,
                lastName: _userData.lastName,
                photo: _userData.photo,
                userSetting: _userData.userSetting?.toJson()),
            room: client.matchupId.toString()),
        largeIcon: _userData.photo != null
            ? IMAGE_URL + "/users/" + '${PRO.userData?.photo}'
            : null,
        androidGroup: _userData.code);
    var _res = await Api().pushNotification(_payload.toJson(),
        counApi: client.deviceType == 1
            ? iosFirebaseOption.apiKey
            : androidFirebaseOption.apiKey);
    if (_res != null) {
      return true;
    }
    return false;
  }

  String? _reply;
  String? _replyName;
  Map<dynamic, dynamic> _messageData(String message,
      {bool isConnect = false, required ClientStatusModel client}) {
    return ChatResDataModel(
      code: PRO.userData!.code!,
      created: DateTime.now().millisecondsSinceEpoch,
      message: message.trim(),
      name: PRO.userData?.firstName ?? "",
      readed: isConnect ? "sending" : "false",
      toCode: client.code ?? "",
      status: "unread",
      reply: _reply,
      replyName: _replyName,
    ).toJson();
  }

  void scroolToBottom(ClientStatusModel client) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void openTooltip({required String message}) async {
    await clipboard.Clipboard.setData(clipboard.ClipboardData(text: message));
    snackBars(message: message);
  }

  int limitMessage = 60;
  double matricPixel = 0;
  bool isIncreaseLimit = false;
  FocusNode messageFocus = FocusNode();

  Future<void> increaseLimitMessage(double matricPix) async {
    limitMessage += 10;
    matricPixel = matricPix;
    isIncreaseLimit = true;
    update();
  }

  void enableAutoScroll({bool isUpdate = false}) {
    if (isUpdate) {
      isIncreaseLimit = false;
      update();
    } else {
      isIncreaseLimit = false;
    }
  }

  bool messageValidation() {
    return chatEditing.text != "" && chatEditing.text.isNotEmpty;
  }
}

class ChatResDataModel {
  String code;
  int created;
  String message;
  String name;
  String readed;
  String toCode;
  String status;
  String? reply;
  String? replyName;
  ChatResDataModel(
      {required this.code,
      required this.created,
      required this.message,
      required this.name,
      required this.readed,
      required this.toCode,
      required this.status,
      this.reply,
      this.replyName});

  // create factory from Json
  factory ChatResDataModel.fromJson(Map<String, dynamic> json) =>
      ChatResDataModel(
        code: json["code"] ?? "",
        created: json["created"] ?? DateTime.now().millisecondsSinceEpoch,
        message: json["message"] ?? "",
        name: json["name"] ?? "",
        readed: json["readed"] ?? "",
        toCode: json["toCode"] ?? "",
        status: json["status"] ?? "",
      );

  Map<dynamic, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['created'] = created;
    data['message'] = message;
    data['name'] = name;
    data['readed'] = readed;
    data['to_code'] = toCode;
    data['status'] = status;
    data['reply'] = reply;
    data['replyName'] = replyName;
    return data;
  }

  @override
  String toString() {
    return "code $code, created $created, message $message, name $name, readed $readed, toCode $toCode, status $status, reply $reply, replyName $replyName";
  }
}

class WonderPushPayload {
  int userId;
  String title;
  String content;

  WonderPushPayload(
      {required this.userId, required this.title, required this.content});

  factory WonderPushPayload.fromJson(Map<String, dynamic> json) {
    return WonderPushPayload(
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['title'] = title;
    data['content'] = content;
    return data;
  }
}

class WonderPushResponse {
  int? status;
  String? message;

  WonderPushResponse({status, message});

  WonderPushResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class StreamCustom {
  final _streamResponse = BehaviorSubject();
  void Function(dynamic) get addResponse => _streamResponse.sink.add;
  Stream<dynamic> get getResponse => _streamResponse.stream;

  void dispose() {
    _streamResponse.close();
  }
}
