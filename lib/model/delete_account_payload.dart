class DeleteAccountPayload {
  String? userCode;

  DeleteAccountPayload({
    this.userCode,
  });

  factory DeleteAccountPayload.fromJson(Map<String, dynamic> json) => DeleteAccountPayload(
    userCode: json['user_code'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'user_code': userCode,
  };
}