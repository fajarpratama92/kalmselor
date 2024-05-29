import 'counselor_welcome_questioner_data.dart';

class CounselorWelcomeQuestionerResModel {
  int? status;
  String? message;
  String? dataWelcome;
  List<CounselorWelcomeQuestionerData>? welcomeQuestionerData;

  CounselorWelcomeQuestionerResModel({
    this.status,
    this.message,
    this.dataWelcome,
    this.welcomeQuestionerData,
  });

  factory CounselorWelcomeQuestionerResModel.fromJson(
      Map<String, dynamic> json) {
    List<CounselorWelcomeQuestionerData> data =
        <CounselorWelcomeQuestionerData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(CounselorWelcomeQuestionerData.fromJson(v));
      });
    }

    return CounselorWelcomeQuestionerResModel(
        status: json['status'] as int?,
        message: json['message'] as String?,
        dataWelcome: json['data_welcome'] as String?,
        welcomeQuestionerData: data);
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data_welcome': dataWelcome,
        'data': welcomeQuestionerData?.map((e) => e.toJson()).toList(),
      };
  @override
  String toString() {
    return "CounselorWelcomeQuestionerResModel{status: $status, message: $message, dataWelcome: $dataWelcome, welcomeQuestionerData: $welcomeQuestionerData} \n";
  }
}
