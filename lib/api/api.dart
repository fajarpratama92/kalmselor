import 'package:connectivity/connectivity.dart';
import 'package:counselor/controller/global/user_controller.dart';
import 'package:counselor/tab_pages/chat_room.dart';
import 'package:counselor/translation/translation.dart';
import 'package:counselor/widget/loading.dart';
import 'package:counselor/widget/snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

_checkNetwork() async {
  return await (Connectivity().checkConnectivity());
}

Future<bool> IS_ACTIVE_NETWORK() async {
  var _net = await (Connectivity().checkConnectivity());
  return _net != ConnectivityResult.none;
}

/// Switch Prod/Staging
bool IsStaging = false;

/// BASE API
String CMS = IsStaging ? 'https://kalm-stg.cranium.id/' : 'https://v3.kalm-app.com/';
String BASE_URL = IsStaging ? 'https://kalm-stg.cranium.id/api/v2/' : 'https://v3.kalm-app.com/api/v2/';
String IMAGE_URL = IsStaging ? "https://kalm-stg.cranium.id/files/" : "https://v3.kalm-app.com/files/";
String COUNSELOR_IMAGE_URL =
IsStaging ? 'https://kalm-stg.cranium.id/files/counselor-files/' : 'https://v3.kalm-app.com/files/counselor-files/';
String KARS = IsStaging ? 'https://kalm-stg.cranium.id/kars' : 'https://v3.kalm-app.com/kars';

Map<String, String> OCRHeader = {
  "X-API-Key": "OpBIsDd5M62q8NzzR5Ptz7t24ligE9LGaciqQlT7",
  "Content-Type": "multipart/form-data"
};

Future<ConnectivityResult> checkNetwork() async {
  return await (Connectivity().checkConnectivity());
}

class Api {
  BaseOptions _baseDioOption({String? customBaseUrl, int? connectTimeout}) {
    return BaseOptions(
        connectTimeout: connectTimeout ?? 90000,
        baseUrl: customBaseUrl ?? BASE_URL);
  }

  String? _unknowError(dynamic error) {
    try {
      return error['message'];
    } catch (e) {
      return null;
    }
  }

  Future<WrapResponse?> POST(
    String url,
    dynamic body, {
    bool useLoading = true,
    bool useToken = false,
    bool useSnackbar = true,
    Map<String, String>? customHeader,
    String? customBaseUrl,
    bool useClearData = true,
    int? connectTimeout,
  }) async {
    // check user networt
    var _net = await checkNetwork();
    try {
      useLoading ? Loading.show(context: Get.context!) : null;
      var _execute = Dio(_baseDioOption(
              customBaseUrl: customBaseUrl, connectTimeout: connectTimeout))
          .post(
        url, data: body,
        // calculate receiving data progresss
        onReceiveProgress: (int sent, int total) {
          // print("RECEIVING ${(total / total) * 100}");

          PRO.onReceiveProgresss(sent, total);
        },
        // calculate send data progresss
        onSendProgress: (int sent, int total) {
          // print("SENDING ${(total / total) * 100}");
          PRO.onSendProgresss(sent, total);
        },
        // Header
        options: Options(
          headers: (useToken
              ? {
                  "Content-Type": 'application/json',
                  "Authorization": "Bearer ${PRO.userData?.token}",
                }
              : {
                  "Content-Type": 'application/json',
                }),
        ),
      );
      // Execute
      var _res = await _execute;
      return WrapResponse(
          message: _res.statusMessage,
          statusCode: _res.statusCode,
          data: _res.data);
    } on DioError catch (e) {
      // print(e.response?.data);
      if (e.type == DioErrorType.response) {
        if (e.response?.statusCode == 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          useClearData ? PRO.clearAllData() : null;
          return null;
        } else if (e.response!.statusCode! >= 400 &&
            e.response!.statusCode! != 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        } else {
          useSnackbar
              ? ERROR_SNACK_BAR(
                  '${e.response?.statusCode}', e.response?.statusMessage)
              : null;

          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        }
      } else if (e.type == DioErrorType.connectTimeout) {
        useSnackbar
            ? ERROR_SNACK_BAR("Perhatian", "Koneksi tidak stabil")
            : null;
        return WrapResponse(
            message: "connection timeout",
            statusCode: e.response?.statusCode ?? 0);
      } else if (_net == ConnectivityResult.none) {
        ERROR_SNACK_BAR("Perhatian", "Pastikan Anda terhubung ke Internet");
        return WrapResponse(message: "connection timeout", statusCode: 000);
      } else {
        ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
        return WrapResponse(message: "connection timeout", statusCode: 999);
      }
    }
  }

  Future<WrapResponse?> PATCH(
    String url,
    dynamic body, {
    bool useLoading = true,
    bool useToken = false,
    bool useSnackbar = true,
    Map<String, String>? customHeader,
    String? customBaseUrl,
    bool useClearData = true,
    int? connectTimeout,
  }) async {
    // check user networt
    var _net = await checkNetwork();
    try {
      useLoading ? Loading.show(context: Get.context!) : null;

      var _execute = Dio(_baseDioOption(
              customBaseUrl: customBaseUrl, connectTimeout: connectTimeout))
          .patch(url, data: body,
              // calculate receiving data progresss
              onReceiveProgress: (int sent, int total) {
        // print("RECEIVING ${(total / total) * 100}");

        PRO.onReceiveProgresss(sent, total);
      },
              // calculate send data progresss
              onSendProgress: (int sent, int total) {
        // print("SENDING ${(total / total) * 100}");
        PRO.onSendProgresss(sent, total);
      },
              // Header
              options: Options(
                  headers: (useToken
                      ? {
                          "Content-Type": 'application/json',
                          "Authorization": "Bearer ${PRO.userData?.token}",
                        }
                      : {
                          "Content-Type": 'application/json',
                        })));
      // Execute
      var _res = await _execute;
      return WrapResponse(
          message: _res.statusMessage,
          statusCode: _res.statusCode,
          data: _res.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        if (e.response?.statusCode == 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          useClearData ? PRO.clearAllData() : null;
          return null;
        } else if (e.response!.statusCode! >= 400 &&
            e.response!.statusCode! != 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        } else {
          useSnackbar
              ? ERROR_SNACK_BAR(
                  '${e.response?.statusCode}', e.response?.statusMessage)
              : null;

          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        }
      } else if (e.type == DioErrorType.connectTimeout) {
        useSnackbar
            ? ERROR_SNACK_BAR("Perhatian", "Koneksi tidak stabil")
            : null;
        return WrapResponse(
            message: "connection timeout",
            statusCode: e.response?.statusCode ?? 0);
      } else if (_net == ConnectivityResult.none) {
        ERROR_SNACK_BAR("Perhatian", "Pastikan Anda terhubung ke Internet");
        return WrapResponse(message: "connection timeout", statusCode: 000);
      } else {
        ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
        return WrapResponse(message: "connection timeout", statusCode: 999);
      }
    }
  }

  Future<WrapResponse?> PUT(
    String url,
    dynamic body, {
    bool useLoading = true,
    bool useToken = false,
    bool useSnackbar = true,
  }) async {
    var _net = await checkNetwork();
    try {
      useLoading ? Loading.show(context: Get.context!) : null;

      var _execute = Dio(_baseDioOption()).put(url,
          data: body,
          // onReceiveProgress: (int sent, int total) => PRO.onSendProgress(sent, total),
          // onSendProgress: (int sent, int total) => PRO.onSendProgress(sent, total),
          options: Options(
              headers: useToken
                  ? {
                      "Content-Type": 'application/json',
                      "Authorization": "Bearer ${PRO.userData?.token}",
                      'Accept': 'application/json'
                    }
                  : {
                      "Content-Type": 'application/json',
                    }));
      var _res = await _execute;
      Loading.hide();
      return WrapResponse(
          message: _res.statusMessage,
          statusCode: _res.statusCode,
          data: _res.data);
    } on DioError catch (e) {
      // print(e.requestOptions.data);
      Loading.hide();
      ERROR_SNACK_BAR("ERROR", "${e.response?.data}");
      if (e.type == DioErrorType.response) {
        if (e.response!.statusCode! == 401) {
          useSnackbar
              ? ERROR_SNACK_BAR(
                  "${e.response?.statusCode}", e.response?.statusMessage)
              : null;
          PRO.clearAllData();
          return null;
        } else if (e.response!.statusCode! >= 400 &&
            e.response!.statusCode! != 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;
          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        } else {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;

          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        }
      } else if (e.type == DioErrorType.connectTimeout) {
        useSnackbar
            ? ERROR_SNACK_BAR("Perhatian", "Koneksi tidak stabil")
            : null;
        return WrapResponse(
            message: "connection timeout",
            statusCode: e.response?.statusCode ?? 0);
      } else if (_net == ConnectivityResult.none) {
        ERROR_SNACK_BAR("Perhatian", "Pastikan Anda terhubung ke Internet");
        return WrapResponse(message: "connection timeout", statusCode: 000);
      } else {
        ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
        return WrapResponse(message: "connection timeout", statusCode: 999);
      }
    }
  }

  Future<dynamic> pushNotification(
    Map<String, dynamic> payload, {
    required String counApi,
  }) async {
    var _net = await _checkNetwork();
    try {
      WrapResponse? _res = await Api().POST(
        "https://onesignal.com/api/v1/notifications",
        payload,
        useToken: true,
        useLoading: true,
      );
      if (_res?.statusCode == 200) {
        return _res?.data;
      } else {
        return _res?.data;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        throw WrapResponse(
            message: "connection timeout",
            statusCode: e.response?.statusCode ?? 0);
      } else if (e.type == DioErrorType.response) {
        if (e.response?.statusCode == 500) {
          throw WrapResponse(
              statusCode: e.response?.statusCode,
              message: e.message,
              data: e.response?.data);
        } else if (e.response?.statusCode == 400) {
          throw WrapResponse(
              statusCode: e.response?.statusCode,
              message: e.message,
              data: e.response?.data);
        } else if (e.response?.statusCode == 404) {
          throw WrapResponse(
              statusCode: e.response?.statusCode,
              message: e.message,
              data: e.response?.data);
        } else if (e.response?.statusCode == 401) {
          throw WrapResponse(
              statusCode: e.response?.statusCode,
              message: e.message,
              data: e.response?.data);
        } else {
          throw """{"message":"Internal Server Error","status":1000}""";
        }
      } else if (_net == ConnectivityResult.none) {
        throw """{"message":"Please check your internet connection"}""";
      }
    }
  }

  Future<dynamic> WonderPushNotif(WonderPushPayload payload) async {
    try {
      var _execute =
          Dio(_baseDioOption(customBaseUrl: BASE_URL, connectTimeout: 60000))
              .post(
        "push-notification", data: payload.toJson(),
        onReceiveProgress: (int sent, int total) {
          PRO.onReceiveProgresss(sent, total);
        },
        onSendProgress: (int sent, int total) {
          PRO.onSendProgresss(sent, total);
        },
        // Header
        options: Options(
          headers: ({
            "Content-Type": 'application/json',
            "Authorization": "Bearer ${PRO.userData?.token}",
          }),
        ),
      );
      await _execute;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<WrapResponse?>? GET(
    String url, {
    bool useLoading = true,
    bool useToken = false,
    bool useSnackbar = true,
    String? customBaseUrl,
    String? customToken,
    int? connectTimeout,
  }) async {
    var _net = await checkNetwork();
    try {
      useLoading ? Loading.show(context: Get.context!) : null;

      var _execute = Dio(_baseDioOption(
              customBaseUrl: customBaseUrl, connectTimeout: connectTimeout))
          .get(
        url,
        onReceiveProgress: (int sent, int total) =>
            PRO.onReceiveProgresss(sent, total),
        options: Options(
          headers: useToken
              ? {
                  "Content-Type": 'application/json',
                  "Authorization":
                      "Bearer ${customToken ?? PRO.userData?.token}",
                }
              : {
                  "Content-Type": 'application/json',
                },
        ),
      );

      var _res = await _execute;
      Loading.hide();
      return WrapResponse(
          message: _res.statusMessage,
          statusCode: _res.statusCode,
          data: _res.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        if (e.response!.statusCode! == 401) {
          useSnackbar
              ? ERROR_SNACK_BAR(
                  "${e.response?.statusCode}", e.response?.statusMessage)
              : null;
          await PRO.clearAllData();
          return null;
        } else if (e.response!.statusCode! >= 400 &&
            e.response!.statusCode! != 401) {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;

          return WrapResponse(
            message: e.response?.statusMessage ?? e.message,
            statusCode: e.response?.statusCode ?? 0,
            data: e.response?.data,
          );
        } else {
          useSnackbar
              ? ERROR_SNACK_BAR("${e.response?.statusCode}",
                  _unknowError(e.response?.data) ?? e.response?.statusMessage)
              : null;

          return WrapResponse(
              message: e.response?.statusMessage ?? e.message,
              statusCode: e.response?.statusCode ?? 0,
              data: e.response?.data);
        }
      } else if (e.type == DioErrorType.connectTimeout) {
        useSnackbar
            ? ERROR_SNACK_BAR("Perhatian", "Koneksi tidak stabil")
            : null;
        return WrapResponse(
            message: "connection timeout",
            statusCode: e.response?.statusCode ?? 0);
      } else if (_net == ConnectivityResult.none) {
        ERROR_SNACK_BAR("Perhatian", "Pastikan Anda terhubung ke Internet");
        return WrapResponse(message: "connection timeout", statusCode: 000);
      } else {
        ERROR_SNACK_BAR("Perhatian", "Terjadi Kesalahan");
        return WrapResponse(message: "connection timeout", statusCode: 999);
      }
    }
  }

  postDataWithTokens(
      {required String url,
      required Map<String, dynamic> payload,
      required bool useErrorPage}) {}
}

/// user/
String SESSION(String code) => 'user/$code';

/// "10" for user,
///  "20" for counselor
const String USER_ROLE = "20";

/// change USER_ROLE AT STATIC URL to change icon,
String get APP_ICON =>
    USER_ROLE == "10" ? "assets/icon/kalm.png" : "assets/icon/counselor.png";

/// change USER_ROLE AT STATIC URL to change icon ,
List<String> get LOGIN_HEADER => [
      USER_ROLE == "10" ? "assets/icon/kalm.png" : "assets/icon/counselor.png",
      USER_ROLE == "10"
          ? "assets/logins/kalm.png"
          : "assets/icon/counselor_login.png"
    ];

FirebaseDatabase? DATABASE_FIREBASE;

/// inspirational-quote?lang=id&roles=$USER_ROLE"
String INSPIRATION_QOUTE = "inspirational-quote?lang=id&roles=20";

/// article?lang=id&main=1&is_counselor=${USER_ROLE == "20" ? "0" : "1"}
String USER_ARTICLE = "article?lang=id&main=1&is_counselor=1";
String ARTICLE_DATA = "article?lang=id&main=0&is_counselor=1";

/// ORS
const String STORE_ORS = "/user/ors/store";
const String GET_ORS = "/user/ors/list";

/// inspirational/
const String INSPIRATIONAL_QUOTE = "inspirational/";

String PROMO_CHECK({required String? subsId, required String? promo}) =>
    'check-subscription-promo/$subsId/$promo';

/// articles/
const String ARTICLE = "articles/";

/// questionnaire-sign-up?user_role=$USER_ROLE
String QUESTIONER = "questionnaire-sign-up?user_role=20";
String QUESTIONER10 = "questionnaire-sign-up?user_role=10";
String MANDATORY_FILES = "counselor/upload-credentials";
String APPROVAL_MANDATORY_FILES = "counselor/upload-approval-status";
String UPDATE_STATUS = "user/update-status/${PRO.userData?.code}";
String ABOUT_ME = "counselor/about-me/${PRO.userData?.code}";
String POST_QUESTIONER = "auth/questionnaire-sign-up";
String UPDATE_QUESTIONER = "auth/questionnaire-update/${PRO.userData?.code}";

/// flash-page?role=$USER_ROLE
String FLASHPAGE = "flash-page?role=20";

/// auth/register
const String REGISTER = 'auth/register';
const String INSTALLATION_ID = "setting/installation-id";
const String USER_SUBSCRIBE = 'user/subscribe';
const String SETTING_CONTACT = "setting/contact";
String CONTACT_US = "page/32lang=id";
String ABOUT_KALM = "page/30lang=id";
const String FAQ_CATEGORY = 'faq?category=20';
String HOW_TO = 'page/22?lang=id';
String SOP_CONFIRM = 'page/34?lang=id';
String DELETE_ACCOUNT = "user/delete";

String COUNSELOR_TERM_CONDITION =
    "counselor/term-conditions/${PRO.userData?.code}";
String COUNSELOR_STORE_TERM_CONDITION =
    "counselor/term-conditions/store/${PRO.userData?.code}";
String COUNSELOR_UPDATE_TERM_CONDITION =
    "counselor/term-conditions/update/id_tnc";
String COUNSELOR_DELETE_TERM_CONDITION =
    "counselor/term-conditions/delete/id_tnc";

String PRIVACY = 'page/33?lang=id';
String TERM_AND_CONDITION_CATEGORY = 'term-condition?category=20&lang=id';

String CHECK_VOUCHER(String voucher) => "user/voucher/check/$voucher";
const String ASSIGN_VOUCHER = "user/voucher/assign";
const String FORGOT_PASSWORD = 'auth/forgot-password';
const String RESEND_CODE = "auth/resend-activation-code";
const String AUTH = 'auth/login';
const String LOGOUT = "auth/logout";

/// get-countries
const String GET_COUNTRIES = 'get-countries';

String TNC_DATA(String counCOde) =>
    "counselor/term-conditions/for-user/$counCOde";

String TNC_VIEW(String clienCode) =>
    "counselor/term-conditions/accepted/$clienCode";

/// get-states/${id}
String GET_STATES({required int? id}) => 'get-states/${id.toString()}';

String GET_COUNSELOR(String code) => "user/counselor-detail-info/$code";
const String EMAIL_SUBSCRIPTION =
    'counselor/setting/notification-setting/email-client-send-message';
const String NOTIF_SUBSCRIPTION =
    'counselor/setting/notification-setting/notification-client-send-message';
String REQUEST_CHANGE_COUNSELOR =
    'user/change-counselor-request/${PRO.userData?.code}';

String PAGE_DIR(int page) => 'page/$page?lang=id';
String REQUEST_TRANSFER_CLIENT =
    'counselor/request-user-stop/${PRO.userData?.code}';

/// get-cities/${id}
String GET_CITIES({required int? id}) => 'get-cities/${id.toString()}';
const String POST_MATCHUP = "matchup";
const String ACTIVATION_CODE = "auth/register-activation-code";
String MATCHUP = "matchup?lang=id";
const String GET_EXPERIENCE = "user-experience";
const String ASSIGN_UNIQCODE = "assign-unique-code";
const String PENDING_UNIQCODE = "pending-unique-code";
const String CHECK_UNIQCODE = "check-unique-code/";
const String PENDING_PAYMENT = "user/subscription/pending";

String DELETE_PAYMENT({required String? id}) => "user/subscription/cancel/$id";
String USER_UPDATE = 'user/update/${PRO.userData?.code}';
String UPDATE_PROFILE_IMAGE = 'user/update-photo/${PRO.userData?.code}';
// String GET_SUBSCRIPTION_LIST = "get-subscriptions?lang=id";
String GET_SUBSCRIPTION_LIST =
    "get-subscriptions?lang=${Translating().API_LANG.tr}";
String GRATITUDE_JOURNAL = "user/gratitude-journal/${PRO.userData?.code}";
String GRATITUDE_WALL = 'user/gratitude-walls/${PRO.userData?.code}';
const String STORE_EXPERIENCE = "user-experience/store";
const String USER_PAYMENT_INFO = "user/payment-information";

String ACC_TNC(String counselorCode) => 'matchup/user/accept/$counselorCode';
String REJECT_TNC = 'user/change-counselor-request/${PRO.userData?.code}';
const String DIRECTORY_SORTED = "directory-sorted";
String GET_TO_KNOW = "user/get-to-know/${PRO.userData?.code}";

String CHANGE_PASSWORD = "auth/change-password/${PRO.userData?.code}";
String WONDER_PUSH_NOTIF = "push-notification";

String COUNSELOR_CLIENT(String userCode) =>
    "counselor/list-users/${PRO.userData?.code}";
String STOP_CLIENT_REQUEST =
    "counselor/setting/change-stop-request/${PRO.userData?.code}";
String COUNSELOR_DECIDE = "matchup/counselor/decide";

String USER_GET_TO_KNOW = "user/get-to-know/";
String CLIENT_GET_TO_KNOW = "user/";

///Payment Gateway
const String PAYMENT_LIST_API = "payment/list";
//STG
// const String PAYMENT_GATEWAY = 'https://kalm-payment.cranium.id/api/v3/';
//LIVE
const String PAYMENT_GATEWAY = 'https://api3.kalm-app.com/api/v3/';
const String MIDTRANS_CC = "midtrans/credit-card";
const String MIDTRANS_BANK_TF = "midtrans/bank-transfer";
const String INDODANA_TRANSACTION = "indodana/purchase-transaction";
const String INDODANA_INSTALLMENT = "indodana/get-installment";
const String XENDIT_CREATE = "xendit/create/ovo";
const String XENDIT_GET = "xendit/get/ovo";
const String GOPAY = "midtrans/gopay";
const String SHOPEE = "midtrans/shopee";

class WrapResponse {
  String? message;
  int? statusCode;
  dynamic data;

  WrapResponse({
    this.message,
    this.statusCode,
    this.data,
  });

  WrapResponse.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString();
    statusCode = json['code'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status_code'] = statusCode;
    _data['data'] = data;
    return _data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "WrapResponse{message: $message, statusCode: $statusCode, data: $data}";
  }
}
