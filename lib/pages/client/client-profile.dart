import 'dart:math' as math;

import 'package:counselor/api/api.dart';
import 'package:counselor/color/colors.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/model/client_quetioner_res_model/client_quetioner_res_model.dart';
import 'package:counselor/model/user_questioner_payload.dart';
import 'package:counselor/pages/client/client-matchup-data.dart';
import 'package:counselor/pages/client/client_questioner_introduction_page.dart';
import 'package:counselor/pages/client/transfer-client.dart';
import 'package:counselor/pages/counselor/counselor_user_tnc.dart';
import 'package:counselor/widget/avatar-image.dart';
import 'package:counselor/widget/button/button.dart';
import 'package:counselor/widget/expansion_tile.dart';
import 'package:counselor/widget/safe_area.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:counselor/widget/space.dart';
import 'package:counselor/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/counselor-chat-controller.dart';
import '../../model/user_model/user_data.dart';
import '../../model/user_model/user_subscription_list.dart';
import '../../utilities/clipboard.dart';
import '../../widget/loading.dart';
import '../../widget/persistent_tab/persistent_tab_util.dart';

class ClientProfilePage extends StatelessWidget {
  final String email;
  final ClientStatusModel client;

  ClientProfilePage({Key? key, required this.email, required this.client})
      : super(key: key);

  final _profileController = Get.put(ClientProfileController());

  final List<String> _assetIcon = [
    "assets/gender.png",
    "assets/profiledate.png",
    'assets/latitude.png'
  ];
  final List<String> _countryTitle = ["Indonesia", "Singapore", "Lainnya"];
  final List<String> _genderTitle = ["Perempuan", "Laki-Laki", "Belum Ada"];
  final List<String> _buttonTitle = [
    "Jawaban Kuesioner Pengenalan",
    "Jawaban Kuesioner Pencocokan",
    "Persetujuan Kalmselor - Klien",
    "Catatan KARS"
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClientProfileController>(
      builder: (_) {
        try {
          int _totalDays = _.totalPackagesDays(context, email: email);
          int _usedDays = _.clientUsedDays(context, email: email);
          UserData? _client = _.client(context, email: email);
          // _.clientDetail = _client;
          var clientSubscription =
              _.clientSubscriptionList(context, email: email)!;

          if (clientSubscription.length > 1) {
            clientSubscription.sort((a, b) {
              return b!.startAt!.compareTo(a!.startAt!);
            });
          }

          return SAFE_AREA(
            context: context,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SPACE(),
                    const Text(
                      "PROFIL",
                      style: TextStyle(
                          fontSize: 30,
                          color: BLUEKALM,
                          fontWeight: FontWeight.w900),
                    ),
                    SPACE(height: 10),
                    Builder(
                      builder: (context) {
                        if (client.photo == null) {
                          return Avatar(null);
                        } else {
                          return Avatar(
                              "${IMAGE_URL + "users/"}${client.photo}");
                        }
                      },
                    ),
                    Text("${_client?.firstName ?? ""} ${_client?.lastName}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                        )),
                    SPACE(height: 20),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      width: Get.width,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 0.2)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(email,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                overflow: TextOverflow.ellipsis,
                              )),
                          IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 17,
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: email))
                                    .then((_) {
                                  Get.rawSnackbar(
                                      showProgressIndicator: false,
                                      dismissDirection:
                                          DismissDirection.vertical,
                                      duration: const Duration(seconds: 2),
                                      message: "E-Mail copied to clipboard!",
                                      isDismissible: true,
                                      snackStyle: SnackStyle.FLOATING,
                                      maxWidth: 210,
                                      borderRadius: 15,
                                      shouldIconPulse: true,
                                      forwardAnimationCurve: Curves.easeIn,
                                      reverseAnimationCurve: Curves.easeOut,
                                      snackPosition: SnackPosition.TOP);
                                });
                              },
                              icon: const Icon(Icons.copy_rounded))
                        ],
                      ),
                    ),
                    SPACE(height: 20),
                    _userLiveData(context, _client),
                    const Divider(thickness: 2),
                    SPACE(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Masa Berlangganan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SPACE(),
                        ActivePackages(
                          totalDays: _totalDays.toDouble(),
                          remainingDays: _
                              .clientUsedDays(context, email: email)
                              .toDouble(),
                        ),
                        SPACE(height: 10),
                        _detailPackages(
                            _totalDays, _usedDays, clientSubscription),
                        SPACE(),
                      ],
                    ),
                    _buttonList(context, _client),
                    SPACE(height: 20),
                    CustomButton(
                      titleStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      title: "Berhenti Melayani Klien",
                      onPressed: client.isCoorporate!
                          ? () {}
                          : () {
                              pushNewScreen(
                                context,
                                screen: TransferClientPage(
                                  client: client,
                                ),
                              );
                            },
                      padHorizontal: 30,
                      heigth: 40,
                    ),
                    SPACE(height: 20),
                  ],
                ),
              ),
            ),
          );
        } catch (e) {
          return Scaffold(body: Center(child: Container()));
        }
      },
    );
  }

  CostumExpansionTile _detailPackages(int _totalDays, int _usedDays,
      List<UserSubscriptionList?> clientSubscription) {
    return CostumExpansionTile(
      onExpansionChanged: (isOpen) => _profileController.openDetail(isOpen),
      header: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "${(_totalDays == 0) ? 0 : (_totalDays - _usedDays)} Hari / $_totalDays Hari",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            SPACE(),
            Transform.rotate(
              angle: _profileController.openDetailPakages
                  ? (math.pi / 2)
                  : (math.pi / -2),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
              ),
            ),
          ],
        ),
      ),
      children: List.generate(
        clientSubscription.length,
        (i) {
          var _dayDuration = DateTime.parse(clientSubscription[i]!.endAt!)
              .difference(DateTime.parse(clientSubscription[i]!.startAt!));
          return CostumExpansionTile(
            header: Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_dayDuration.inDays} Hari",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TEXT(
                          DateFormat("dd/MM/y").format(
                            DateTime.parse(clientSubscription[i]!.startAt!),
                          ),
                        ),
                        TEXT(
                          DateFormat("dd/MM/y").format(
                            DateTime.parse(
                              clientSubscription[i]!.endAt!,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _userLiveData(context, UserData? client) {
    // print("country id${client?.countryId}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        3,
        (i) {
          switch (i) {
            case 0:
              return _clipOvalLiveData('assets/others/gender.png',
                  _genderTitle[client?.gender ?? 2]);
            case 1:
              return _clipOvalLiveData(
                  'assets/others/age.png', _age(context, client));
            case 2:
              return _clipOvalLiveData(
                  'assets/others/latitude.png',
                  client?.countryId == null
                      ? "not found"
                      : _countryTitle[client!.countryId == 3
                          ? 2
                          : client.countryId! == 1
                              ? 0
                              : 1]);
            default:
              return Container();
          }
        },
      ),
    );
  }

  String _age(context, UserData? client) {
    if (client == null || client.dob == null) {
      return "not found";
    }
    return _fixNullString("${(DateTime.now().year - client.dob!.year)} Tahun");
  }

  Column _clipOvalLiveData(String icon, String? title) {
    return Column(
      children: [
        ClipOval(
          child: Container(
            height: 60,
            width: 60,
            color: ORANGEKALM,
            child: ImageIcon(
              ExactAssetImage(icon, scale: 4),
              color: Colors.white,
            ),
          ),
        ),
        SPACE(height: 10),
        Text(_fixNullString(title ?? ""), style: const TextStyle())
      ],
    );
  }

  String _fixNullString(String text) {
    try {
      return text;
    } catch (e) {
      return "not found";
    }
  }

// SAMPAI SINI,.. MENYELIDIKI BUTTON DAN MENGGANTI TAMPILAN SEPERTI UI LANJUT
// LANJUTKAN DISINI
  void _onPress(int i, BuildContext context, UserData? userClient) async {
    switch (i) {
      case 0:
        _questionerProfile(context, client: client, userClient: userClient);
        break;
      case 1:
        pushNewScreen(context, screen: ClientMatchupPage(email: email));
        break;
      case 2:
        pushNewScreen(context, screen: CounselorUserTncPage(client: client));
        break;
      case 3:
        if (await canLaunch(KARS)) {
          launch(KARS);
        } else {
          Get.snackbar("Perhatian", "can't open $KARS");
        }
        break;
      default:
    }
  }

  Future<void> _questionerProfile(BuildContext context,
      {required ClientStatusModel client, UserData? userClient}) async {
    var _res =
        await Api().GET("$USER_GET_TO_KNOW${client.code}", useToken: true);

    if (_res?.statusCode == 200) {
      var _list = _res?.data['data'] as List<dynamic>;
      List<UserQuestionerPayload> dataUserQuestionerIntroduction = [];
      try {
        for (var i = 0; i < _list.length; i++) {
          dataUserQuestionerIntroduction
              .add(UserQuestionerPayload.fromJson(_list[i]));
        }

        if (dataUserQuestionerIntroduction.length == 12) {
          await pushNewScreen(context,
              screen: ClientQuestionerIntroductionPage(
                existingAnswer: dataUserQuestionerIntroduction,
                client: userClient,
              ));
        } else {
          throw Exception(
              "Data tidak valid\nTotal data ${dataUserQuestionerIntroduction.length}");
        }
      } catch (e) {
        print(e.toString());
        ERROR_SNACK_BAR("Perhatian",
            'Data tidak valid\ntotal data ${dataUserQuestionerIntroduction.length}');
        // await pushNewScreen(context, screen: UserQustionerPage());
      }
    }
    Loading.hide();
  }

  Column _buttonList(BuildContext context, UserData? userClient) {
    return Column(
      children: List.generate(_buttonTitle.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: CustomButton(
            titleRow: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 10,
                  fit: FlexFit.tight,
                  child: Text(
                    _buttonTitle[i],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      fontFamily: "MavenPro",
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: math.pi / 1.0,
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                )
              ],
            ),
            onPressed: () => _onPress(i, context, userClient),
            heigth: 40,
          ),
        );
      }),
    );
  }
}

class ActivePackages extends StatelessWidget {
  final double totalDays;
  final double remainingDays;

  const ActivePackages(
      {Key? key, required this.totalDays, required this.remainingDays})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.size.width,
        decoration: BoxDecoration(
          color: Colors.grey[350],
          borderRadius: BorderRadius.circular(20),
        ),
        height: 15,
        child: Stack(
          children: [
            AnimatedContainer(
              width:
                  ((Get.size.width / totalDays) * (totalDays - remainingDays)),
              decoration: BoxDecoration(
                color: BLUEKALM,
                borderRadius: BorderRadius.circular(20),
              ),
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ));
  }
}

class ClientProfileController extends GetxController {
  bool openDetailPakages = false;

  void openDetail(bool isOpen) {
    openDetailPakages = isOpen;
    update();
  }

  Future<ClientQuetionerResModel?> getToknow(String clientCode) async {
    var dataApi = await Api().GET(GET_TO_KNOW, useToken: true);
    var _res = ClientQuetionerResModel.fromJson(dataApi?.data);
    return _res;
  }

  UserData? client(context, {String? email}) => STATE(context)
      .counselorClientResModel
      ?.data
      ?.where((e) {
        return e.clientResData?.email == email;
      })
      .toList()
      .map((e) {
        return e.clientResData;
      })
      .toList()
      .first;

  Duration clientActivePackagesDays(context, {String? email}) {
    return DateTime.parse(
            client(context, email: email)!.userSubscriptionList!.last!.endAt!)
        .difference(DateTime.parse(client(context, email: email)!
            .userSubscriptionList!
            .first!
            .startAt!));
  }

  int clientUsedDays(context, {String? email}) {
    return DateTime.parse(
            client(context, email: email)!.userSubscriptionList!.last!.endAt!)
        .difference(DateTime.now())
        .inDays;
  }

  int totalPackagesDays(context, {String? email}) {
    return (client(context, email: email)!.userSubscriptionList)!
        .map((e) => DateTime.parse(e!.endAt!)
            .difference(DateTime.parse(e.startAt!))
            .inDays)
        .toList()
        .fold<int>(0, (p, c) => p + c);
  }

  List<UserSubscriptionList?>? clientSubscriptionList(context,
      {String? email}) {
    return client(context, email: email)!
        .userSubscriptionList
        ?.map((e) => e)
        .toList();
  }
}
