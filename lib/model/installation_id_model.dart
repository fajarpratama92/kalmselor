class InstallationIdPayload {
  String? installationId;
  String? userCode;

  InstallationIdPayload({
    this.installationId,
    this.userCode,
  });

  factory InstallationIdPayload.fromJson(Map<String, dynamic> json) =>
      InstallationIdPayload(
        installationId: json['installation_id'] as String?,
        userCode: json['user_code'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'installation_id': installationId,
        'user_code': userCode,
      };
}
