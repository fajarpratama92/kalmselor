import 'dart:convert';
import 'dart:io';

import 'package:counselor/api/api.dart';
import 'package:counselor/controller/counselor-chat-controller.dart';
import 'package:counselor/model/about_res_model/about_res_model.dart';
import 'package:counselor/model/article_res_model/article_res_model.dart';
import 'package:counselor/model/client_quetioner_res_model/client_questioner_payload.dart';
import 'package:counselor/model/client_quetioner_res_model/client_quetioner_res_model.dart';
import 'package:counselor/model/contact_us_res_model/contact_us_res_model.dart';
import 'package:counselor/model/counselor-client-model.dart';
import 'package:counselor/model/counselor/introduction_quetioner_res_model/counselor_questioner_payload.dart';
import 'package:counselor/model/counselor/introduction_quetioner_res_model/counselor_quetioner_res_model.dart';
import 'package:counselor/model/counselor/welcome_questioner_res_model/counselor_welcome_questioner_data.dart';
import 'package:counselor/model/counselor/welcome_questioner_res_model/counselor_welcome_questioner_res_model.dart';
import 'package:counselor/model/counselor_data.dart';
import 'package:counselor/model/country_res_model/country_res_model.dart';
import 'package:counselor/model/directory_page_res_model/directory_res_model.dart';
import 'package:counselor/model/directory_res_model/directory_res_model.dart';
import 'package:counselor/model/faq_res_model/faq_res_model.dart';
import 'package:counselor/model/firebase_wording_model.dart';
import 'package:counselor/model/how_to_res_model/how_to_res_model.dart';
import 'package:counselor/model/quote_res_model/quote_res_model.dart';
import 'package:counselor/model/register_payload.dart';
import 'package:counselor/model/state_res_model/address_res_item.dart';
import 'package:counselor/model/survey_res_model.dart';
import 'package:counselor/model/tnc_res_model/tnc_res_model.dart';
import 'package:counselor/model/user_matchup_payload.dart';
import 'package:counselor/model/user_matchup_res_model/matchup_datum.dart';
import 'package:counselor/model/user_matchup_res_model/user_matchup_res_model.dart';
import 'package:counselor/model/user_model/user_data.dart';
import 'package:counselor/model/user_model/user_model.dart';
import 'package:counselor/model/wonderpush_payload.dart';
import 'package:counselor/pages/auth/login.dart';
import 'package:counselor/properties/properties.dart';
import 'package:counselor/utilities/deep_link_redirect.dart';
import 'package:counselor/utilities/util.dart';
import 'package:counselor/widget/dialog.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_controller.dart';
import 'package:counselor/widget/persistent_tab/persistent_tab_util.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

// import '../../pages/auth/loginX.dart';
import '../../tab_pages/home_page.dart';

PR(_res) => debugPrint(jsonEncode(_res), wrapWidth: 1024);
UserController PRO = Provider.of(Get.context!, listen: false);
// UserController PRO(BuildContext context) {
//   return Provider.of(context, listen: false);
// }

// ProgressNotifier PROGRES_STATE(context) =>
//     Provider.of<ProgressNotifier>(context);

UserController STATE(BuildContext context, {bool isListen = true}) =>
    Provider.of<UserController>(context, listen: isListen);
GetStorage _box = GetStorage();

String? get PIN_LOCK => _box.read(PIN_CODE_STORAGE);
const String _email = "admin@kalm.com";
const String _password = "a79d76e843a8248e207504c983a3a2ef";
const String USER_STORAGE = "USER";
const String PIN_CODE_STORAGE = "PIN_CODE_STORAGE";
const String USER_TEMP_CODE = "USER_TEMP_CODE";

FirebaseWordingModel? snackBarMessage;

class UserController extends ChangeNotifier {
  bool newBadge = false;
  int initialIndex = 0;
  bool devMode = false;
  // int counterA = 0;
  // int counterB = 0;
  // bool devLock = true;
  CounselorClientResModel? counselorClientResModel;
  FirebaseWordingResModel? snackBarMessage;
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver analyticObserver =
      FirebaseAnalyticsObserver(analytics: _analytics);

  PersistentTabController tabController =
      PersistentTabController(initialIndex: 0);

  void updateInitialIndexTab(int index) {
    tabController.index = index;
    notifyListeners();
    tabController.jumpToTab(index);
  }

  setBadgesReference(bool? isBadges, String? code) {
    if (code == null) return;
    DatabaseReference _badgesRef =
        FirebaseDatabase.instance.ref().child('user_statuses/$code');
    _badgesRef.update({"badges": isBadges});
  }

  userBadgesReference(String? code) async {
    print('userBadges Triggered');
    DatabaseReference _badgesRef =
        FirebaseDatabase.instance.ref().child('user_statuses/$code');
    var _badges = await _badgesRef.once();
    if (_badges.snapshot.value == null) {
      _badgesRef.update({"badges": false});
      _badgesRef.onValue.listen((event) {
        newBadge = event.snapshot.value != null
            ? (event.snapshot.value as dynamic)['badges']!
            : false;
        // print('event Snapshot A ${event.snapshot.value as dynamic}');
        notifyListeners();
        Loading.hide();
      });
    } else {
      // _badgesRef.update({"badges": true});
      _badgesRef.onValue.listen((event) {
        newBadge = event.snapshot.value != null
            ? (event.snapshot.value as dynamic)['badges']!
            : false;
        // print(
        //     'event Snapshot B ${(event.snapshot.value as dynamic)['badges']!}');
        notifyListeners();
        Loading.hide();
      });
    }
  }

// ------------------------------- FIREBASE ANALTICS

  void onChangeTab(int index) {
    tabController.index = index;
    _sendAnalyticsEvent(index);
    notifyListeners();
    TAB_CHANGE_DEBOUNCER(index, () async {
      switch (index) {
        case 0:
          await getHomeArticles();
          await getQuote();
          break;
        case 1:
          await getCounselorClientList(userData!.code!);
          break;
        case 2:
          await getVideos();
          await getDirectoryArticles();
          await getDirectoryPlace();
          break;
        case 3:
          print('setting');
          break;
        default:
      }
    }, second: 10);
  }

  String _analyticSetName(int i) {
    switch (i) {
      case 0:
        return "homePage";
      // case 1:
      //   return "gratitudePage";
      case 1:
        return "chatPage";
      case 2:
        return "discoveryPage";
      case 3:
        return "settingPage";
      default:
        return "";
    }
  }

  Future<void> _sendAnalyticsEvent(int i) async {
    await PRO.analyticObserver.analytics.logEvent(
      name: _analyticSetName(i),
      parameters: <String, dynamic>{
        'first_name': PRO.userData?.firstName,
        'email': PRO.userData?.email,
        'page': _analyticSetName(i),
      },
    );
  }

  String _dob() {
    if (PRO.userData?.dob != null) {
      return (DateTime.parse(PRO.userData!.dob!.toString()).year -
              DateTime.now().year)
          .toString();
    } else {
      return "user doesnt answering questioner";
    }
  }

  String _pushNotifToken() {
    if (PRO.userData?.onesignalToken != null) {
      return PRO.userData!.onesignalToken!;
    } else {
      return "";
    }
  }

  String _subscription() {
    if (PRO.userData?.userSubscription != null) {
      return "${PRO.userData?.userSubscription?.name} ${PRO.userData?.userSubscription?.endAt}";
    } else {
      return "doesnt have package";
    }
  }

  Future<void> setUserProperty() async {
    await PRO.analyticObserver.analytics.setUserProperty(
        name: "gender", value: userData?.gender == 1 ? "Male" : "Female");
    await PRO.analyticObserver.analytics
        .setUserProperty(name: "age", value: "${_dob()} ");
    await PRO.analyticObserver.analytics.setUserProperty(
        name: "device", value: Platform.isAndroid ? "Android" : "IOS");
    await PRO.analyticObserver.analytics
        .setUserProperty(name: "push_notif_token", value: _pushNotifToken());
    await PRO.analyticObserver.analytics
        .setUserProperty(name: "app_version", value: "$APP_VERSION");
    await PRO.analyticObserver.analytics
        .setUserProperty(name: "subscription", value: _subscription());
    await PRO.analyticObserver.analytics
        .setUserProperty(name: "email", value: "${userData?.email}");
    await PRO.analyticObserver.analytics
        .setUserProperty(name: "app_name", value: "KALMSELOR");
  }

// ------------------------------- FIREBASE ANALTICS

  final database = FirebaseDatabase.instance;

  Future<void> pushNotif(String? message) async {
    var _body = WonderpushPayload(
        content: message ?? "new message",
        userId: counselorData?.counselor?.id,
        title: "${userData?.firstName} ${userData?.lastName}");
    var _res = await Api().POST(WONDER_PUSH_NOTIF, _body.toJson(),
        useLoading: false, useClearData: false, useSnackbar: false);
    if (_res?.statusCode == 200) {
    } else {
      return;
    }
  }

  late FirebaseAuth firebaseAuth;
  late FirebaseWordingModel firebaseWordingModel;
  late DatabaseReference wording;
  late DatabaseReference orsRef;
  late DatabaseReference orsResultRef;



  Future<void> firebaseSignin() async {
    firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signInWithEmailAndPassword(
        email: _email, password: _password);
    notifyListeners();
  }

  SurveyResModel? surveyResModel;


  Future<void> updateWording() async {
    try {
      if (firebaseAuth.currentUser == null) {
        ERROR_SNACK_BAR("Perhatian", 'Error 900');
        return;
      }
      // else {
      //   wording = database.ref("wording");
      //   var _snap = await wording.get();
      //   firebaseWordingModel = FirebaseWordingModel.fromJson(
      //       Map<String, dynamic>.from(_snap.value as Map<Object?, Object?>));
      //   notifyListeners();
      // }
    } catch (e) {
      ERROR_SNACK_BAR("Perhatian", 'Error 900');
    }
  }

  String? APP_VERSION;

  DatabaseReference get versionRef =>
      FirebaseDatabase.instance.ref('version/counselor');

  Future<void> checkAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      APP_VERSION = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      print('app name $appName');
      print('package name $packageName');
      print('app version $APP_VERSION');
      print('build number $buildNumber');

      notifyListeners();
      versionRef.onValue.listen(
        (DatabaseEvent event) async {
          var _data =
              Map<String, dynamic>.from(event.snapshot.value as dynamic);
          if (Platform.isAndroid) {
            var _androidVersion =
                int.parse((_data['android'] as String).replaceAll(".", ""));
            var _androidLocalVersion =
                int.parse(APP_VERSION!.replaceAll(".", ""));
            if (_androidLocalVersion < _androidVersion) {
              await SHOW_DIALOG(_data['message'],
                  onAcc: () async => await GO_TO_STORE(),
                  barrierDismissible: false);
              print('android local version $_androidLocalVersion');
              print('android version $_androidVersion');
            } else {
              return;
            }
          } else {
            var _iosVersion =
                int.parse((_data['ios'] as String).replaceAll(".", ""));
            var _iosLocalVersion = int.parse(APP_VERSION!.replaceAll(".", ""));
            if (_iosLocalVersion < _iosVersion) {
              await SHOW_DIALOG(_data['message'],
                  onAcc: () async => await GO_TO_STORE(),
                  barrierDismissible: false);
              print('ios local version $_iosLocalVersion');
              print('ios version $_iosVersion');
            } else {
              return;
            }
          }
        },
        onError: (Object o) {
          final error = o as FirebaseException;
          print('Error: ${error.code} ${error.message}');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  DatabaseReference get matchupRef =>
      FirebaseDatabase.instance.ref('user_matchup/${userData?.code}');
  DatabaseReference? chatRef;

  getChat() async {
    chatRef = database.ref('chats/${counselorData?.matchupId}');
    await chatRef!.keepSynced(true);
    notifyListeners();
  }

  bool get isHavePackages {
    return userData?.userSubscription != null &&
        userData?.userSubscriptionList != null;
  }

  bool get isChatting {
    return counselorData?.counselor != null &&
        userData?.userSubscription != null &&
        userData?.userHasActiveCounselor?.isReadTnc == 1;
  }

  bool get isShowTnc {
    return counselorData?.counselor != null &&
        userData?.userSubscription != null &&
        userData?.userHasActiveCounselor?.isReadTnc == 0;
  }

  Future<List> _getStatusCredential() async {
    WrapResponse? _resData =
        await Api().GET(APPROVAL_MANDATORY_FILES, useToken: true);
    var _res = UserModel.fromJson(_resData?.data);

    if (_res.status == 200) {
      PRO.setUserSession(data: _res);
      return [true, (_res.message ?? "")];
    } else {
      return [false, (_res.message ?? "")];
    }
  }

  CounselorData? counselorData;




  TncResModel? tncResModel;



  removeCounselorClientResModel() {
    counselorClientResModel = null;
    notifyListeners();
  }

  Future<void> updateSession({
    bool useLoading = false,
    required BuildContext context,
  }) async {
    try {
      var _res = await Api().GET(SESSION(PRO.userData!.code!),
          useToken: true, useLoading: useLoading, useSnackbar: false);
      if (_res?.statusCode == 200) {
        await saveLocalUser(UserModel.fromJson(_res?.data).data);
        await setUserSession(data: UserModel.fromJson(_res?.data));
        notifyListeners();
        // PR(_res?.data);
        // if (userData?.userHasActiveCounselor == null) {
        //   await getPendingKalmselorCode();
        // } else {
        //   await getCounselor(useLoading: useLoading);
        //   pendingKalmselorCodeModel = null;
        // }
      } else if (_res?.statusCode == 404) {
        pushRemoveUntilScreen(context, screen: LoginPage());

        return;
      } else {
        ERROR_SNACK_BAR("Perhatian", _res?.message);
        return;
        // userData = null;
        // notifyListeners();
      }
    } catch (e) {}
  }




  ContactUsResModel? contactUsResModel;

  Future<void> getContactUs() async {
    var _res = await Api().GET(CONTACT_US);
    if (_res?.statusCode == 200) {
      contactUsResModel = ContactUsResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  UserData? userData;

  void readLocalUser({bool isPrint = false}) {
    try {
      var _user = _box.read(USER_STORAGE);
      userData = UserData.fromJson(_user);
      isPrint ? PR(userData?.toJson()) : null;
      !isPrint ? notifyListeners() : null;
    } catch (e) {
      // print("Welcome");
    }
  }

  Future<void> saveLocalUser(UserData? data) async {
    // Write to local storage
    await _box.write(USER_STORAGE, data?.toJson());
    // Update state
    userData = data;
    notifyListeners();
  }

  Future<void> savePinCode(String pin) async {
    // Write to local storage
    await _box.write(PIN_CODE_STORAGE, pin);
    // Update state
    notifyListeners();
  }

  Future<void> clearAllData() async {
    userData = null;
    counselorData = null;
    counselorClientResModel = null;
    counselorClientResModel = null;
    tncResModel = null;
    HomeController().timer?.cancel();
    await HomeController().cancelTimer();
    CounselorChatController().timer?.cancel();
    await CounselorChatController().cancelTimer();
    notifyListeners();
    await _box.remove(USER_STORAGE);
    await _box.remove(PIN_CODE_STORAGE);
    // PRO.devMode
    //     ? await Get.offAll(() => LoginXPage())
    //     :
    await Get.offAll(() => LoginPage());
  }

  Future<void> clearAllDataWithoutNavigation() async {
    userData = null;
    counselorData = null;
    counselorClientResModel = null;
    counselorClientResModel = null;
    tncResModel = null;
    notifyListeners();
    await _box.remove(USER_STORAGE);
    await _box.remove(PIN_CODE_STORAGE);
  }

  Future<void> clearAllDataCustom() async {
    await _box.remove(USER_STORAGE);
    notifyListeners();
  }

  RegisterPayload? registerPayload;

  void updateRegisterPayload(RegisterPayload? payload) {
    registerPayload = payload;
    notifyListeners();
  }

  int sendProgress = 0;

  void onSendProgresss(int send, int total) {
    var _send = ((send / total) * 100).toInt();
    // print("SEND $_send");
    sendProgress = _send;
    if (sendProgress == 100) {
      sendProgress = 0;
    }
    notifyListeners();
  }

  int receiveProgress = 0;

  void onReceiveProgresss(int send, int total) {
    var _receive = ((total / send) * 100).toInt();
    // print("RECEIVE $_receive");
    receiveProgress = _receive;
    if (receiveProgress == 100) {
      receiveProgress = 0;
    }
    notifyListeners();
  }

  QuoteResModel? quoteResModel;

  Future<void> getQuote() async {
    print("get quote");
    var _res = await Api().GET(INSPIRATION_QOUTE, useLoading: false);
    if (_res?.statusCode == 200) {
      quoteResModel = QuoteResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  ArticleResModel? articleHomeResModel;

  Future<void> getHomeArticles() async {
    print("get home article");
    var _res = await Api().GET(USER_ARTICLE, useLoading: false);
    if (_res?.statusCode == 200) {
      articleHomeResModel = ArticleResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  ArticleResModel? articleDirectoryResModel;

  Future<void> getDirectoryArticles() async {
    print("get directory article");
    var _res = await Api().GET(ARTICLE_DATA, useLoading: false);
    if (_res?.statusCode == 200) {
      articleDirectoryResModel = ArticleResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  DirectoryResModel? directoryResModel;

  Future<void> getDirectoryPlace() async {
    print("get directory");
    var _res = await Api().GET(DIRECTORY_SORTED, useLoading: false);
    if (_res?.statusCode == 200) {
      directoryResModel = DirectoryResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  List<String?>? videoList;

  Future<void> getVideos() async {
    print("get videos");
    var _res = await Api().GET(PAGE_DIR(10), useLoading: false);
    var _res2 = await Api().GET(PAGE_DIR(12), useLoading: false);
    var _vid1 = DirectoryPageResModel.fromJson(_res?.data);
    var _vid2 = DirectoryPageResModel.fromJson(_res2?.data);
    videoList = [
      youtubeFindId(_vid1.data?.file),
      youtubeFindId(_vid2.data?.file)
    ];
    notifyListeners();
  }

  String? youtubeFindId(String? url) {
    try {
      return url
          ?.replaceAll("https://youtu.be/", "")
          .replaceAll("https://youtube.com/", "");
    } catch (e) {
      return null;
    }
  }

  CountryResModel? countryResModel;

  Future<void> getCountry(
      {bool useLoading = true, bool useSnackbar = true}) async {
    stateResItem = null;
    cityResItem = null;
    var _res = await Api().GET(GET_COUNTRIES,
        useToken: true, useLoading: useLoading, useSnackbar: useSnackbar);
    if (_res?.statusCode == 200) {
      countryResModel = CountryResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  AddressResItem? stateResItem;

  Future<void> getStates(int? countryId) async {
    cityResItem = null;
    var _res = await Api()
        .GET(GET_STATES(id: countryId), useToken: true, useLoading: false);
    if (_res?.statusCode == 200) {
      stateResItem = AddressResItem.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  AddressResItem? cityResItem;

  Future<void> getCity(int? stateId) async {
    var _res = await Api()
        .GET(GET_CITIES(id: stateId), useToken: true, useLoading: false);
    // PR(_res?.data);
    if (_res?.statusCode == 200) {
      cityResItem = AddressResItem.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  AboutResModel? aboutResModel;

  Future<void> getAboutUs() async {
    var _res = await Api().GET(ABOUT_KALM);
    if (_res?.statusCode == 200) {
      aboutResModel = AboutResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  CounselorQuetionerResModel? counselorQuestionerResModel;
  List<CounselorQuestionerPayload?>? payloaditemCounselor;

  Future<void> getCounselorQuestioner(
      {bool useLoading = true, useSnackbar = true}) async {
    var _res =
        await Api().GET(QUESTIONER, useToken: true, useLoading: useLoading);

    // var _res = await Api().GET(QUESTIONER, useLoading: useLoading);
    if (_res?.statusCode == 200) {
      counselorQuestionerResModel =
          CounselorQuetionerResModel.fromJson(_res?.data);
      payloaditemCounselor =
          List.generate(counselorQuestionerResModel!.data!.length, (i) => null);
      notifyListeners();
    } else {
      return;
    }
  }

  ClientQuetionerResModel? clientQuestionerResModel;
  List<ClientQuestionerPayload?>? payloaditemClient;

  Future<void> getClientQuestioner(
      {bool useLoading = true, useSnackbar = true}) async {
    var _res = await Api().GET(QUESTIONER10,
        useToken: true, useLoading: useLoading, useSnackbar: useSnackbar);
    // var _res = await Api().GET(QUESTIONER10, useLoading: useLoading);

    if (_res?.statusCode == 200) {
      clientQuestionerResModel = ClientQuetionerResModel.fromJson(_res?.data);
      payloaditemClient =
          List.generate(counselorQuestionerResModel!.data!.length, (i) => null);
      notifyListeners();
    } else {
      return;
    }
  }

  List<MatchupData>? userMatchupResModel;
  List<UserMatchupPayload?> userMatchupPayload = [];

  Future<void> getUserMatchup({bool useLoading = true}) async {
    var _res = await Api().GET(MATCHUP, useToken: true, useLoading: useLoading);
    if (_res?.statusCode == 200) {
      userMatchupResModel = UserMatchupResModel.fromJson(_res?.data)
          .matchupData
          ?.where((e) => e.id == 5 || e.id == 1)
          .toList();
      userMatchupPayload = List.generate(userMatchupResModel!.length, (index) {
        return null;
      });
      notifyListeners();
    } else {
      return;
    }
  }

  int? statusTestDebug;

  void changeStatusTestDebug(int i) {
    statusTestDebug = i;
    notifyListeners();
  }

  bool keyboardVisibility = false;

  void updateKeyboardVisibility(bool visible) {
    keyboardVisibility = visible;
    notifyListeners();
  }

  FaqResModel? faqResModel;

  Future<void> getFaq() async {
    var _res = await Api().GET(FAQ_CATEGORY);
    if (_res?.statusCode == 200) {
      faqResModel = FaqResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  HowToResModel? howToResModel;

  Future<void> getHowTo() async {
    var _res = await Api().GET(HOW_TO);
    if (_res?.statusCode == 200) {
      howToResModel = HowToResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  HowToResModel? privacyPolicyResModel;

  Future<void> getPrivacyPolicy() async {
    var _res = await Api().GET(PRIVACY);
    if (_res?.statusCode == 200) {
      privacyPolicyResModel = HowToResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }

  HowToResModel? termAndConditionResModel;

  Future<void> getTermAndCondition() async {
    var _res = await Api().GET(TERM_AND_CONDITION_CATEGORY);
    if (_res?.statusCode == 200) {
      termAndConditionResModel = HowToResModel.fromJson(_res?.data);
      notifyListeners();
    } else {
      return;
    }
  }


  ///Counselor
  List<CounselorWelcomeQuestionerData>? welcomeQuestionerData;

  Future<void> getWelcomeQuestioner() async {
    var _res = await Api().GET(QUESTIONER);
    if (_res?.statusCode == 200) {
      welcomeQuestionerData =
          CounselorWelcomeQuestionerResModel.fromJson(_res?.data)
              .welcomeQuestionerData;
      notifyListeners();
    } else {
      return;
    }
  }

  String? get userTempCode => _box.read(USER_TEMP_CODE);

  Future<void> saveTempCode(String? tempCode) async {
    await _box.write(USER_TEMP_CODE, tempCode);
  }

  Future<void> removeTempCode() async {
    await _box.remove(USER_TEMP_CODE);
  }

  Future<void> getStatusFileMandatory() async {
    var _approval = await Api()
        .GET(APPROVAL_MANDATORY_FILES, useToken: true, useLoading: false);
    UserModel? _userModel = UserModel.fromJson(_approval?.data);
    // PR(_approval?.data);
    if (_approval?.statusCode == 200) {
      await saveLocalUser(_userModel.data);
    } else {
      return;
    }
  }

  Future<void> setUserSession({required UserModel? data}) async {
    await saveLocalUser(data?.data);
    print("set session");
    userData = data?.data;
    notifyListeners();
  }

  Future<void> getCounselorClientList(String userCode,
      {bool useLoading = false}) async {
    print("GET COUNSELOR CLIENT LIST");
    var _res = await Api().GET(COUNSELOR_CLIENT(PRO.userData?.code ?? userCode),
        useToken: true, useLoading: useLoading, connectTimeout: 180000);
    if (_res?.statusCode == 200) {
      counselorClientResModel = CounselorClientResModel.fromJson(_res?.data);
    } else {
      ERROR_SNACK_BAR('Perhatian', _res?.message);
    }
    notifyListeners();
  }

  removeCounselorClientList() {
    counselorClientResModel = null;
    notifyListeners();
  }
}
