import 'user_data.dart';

class UserModel {
  int? status;
  String? message;
  UserData? data;

  UserModel({this.status, this.message, this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json['status'].runtimeType == int ? json['status'] : int.parse(json['status']),
        message: json['message'] as String?,
        data: json['data'] == null ? null : UserData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
