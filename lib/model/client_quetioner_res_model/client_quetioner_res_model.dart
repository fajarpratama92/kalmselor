import 'client_questioner_data.dart';

class ClientQuetionerResModel {
  int? status;
  String? message;
  List<ClientQuestionerData>? questionerData;

  ClientQuetionerResModel({this.status, this.message, this.questionerData});

  factory ClientQuetionerResModel.fromJson(Map<String, dynamic> json) {
    return ClientQuetionerResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      questionerData: (json['data'] as List<dynamic>?)
          ?.map((e) => ClientQuestionerData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': questionerData?.map((e) => e.toJson()).toList(),
      };
  @override
  String toString() {
    return "ClientQuetionerResModel{status: $status, message: $message, questionerData: $questionerData} \n";
  }
}
