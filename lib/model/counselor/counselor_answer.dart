class CounselorAnswer {
  int? id;
  String? answer;
  String? alert;

  CounselorAnswer({this.id, this.answer, this.alert});

  factory CounselorAnswer.fromJson(Map<String, dynamic> json) =>
      CounselorAnswer(
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
    return "CounselorAnswer{id: $id, answer: $answer, alert: $alert} \n";
  }
}
