class MatchupPostModel {
  int? question;
  List<dynamic>? answer;

  MatchupPostModel({this.question, this.answer});

  factory MatchupPostModel.fromJson(Map<String, dynamic> json) {
    // question = json['question'];
    // answer = json['answer'].cast<dynamic>();
    return MatchupPostModel(
      question: json['question'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answer'] = answer;
    return data;
  }
}
