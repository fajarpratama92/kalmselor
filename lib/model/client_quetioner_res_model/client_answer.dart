class ClientAnswer {
  int? id;
  String? answer;
  String? alert;

  ClientAnswer({this.id, this.answer, this.alert});

  factory ClientAnswer.fromJson(Map<String, dynamic> json) => ClientAnswer(
        id: json['id'] as int?,
        answer: json['answer'] as String?,
        alert: json['alert'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'answer': answer,
        'alert': alert,
      };
  @override
  String toString() {
    return "ClientAnswer{id: $id, answer: $answer, alert: $alert} \n";
  }
}
