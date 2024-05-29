class CounselorQuestionerPostModel {
  String? role;
  List<QuestPostData>? data;

  CounselorQuestionerPostModel({this.role, this.data});

  factory CounselorQuestionerPostModel.fromJson(Map<String, dynamic> json) {
    List<QuestPostData> dataQuestioner = <QuestPostData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataQuestioner.add(QuestPostData.fromJson(v));
      });
    }
    return CounselorQuestionerPostModel(
      role: json['role'],
      data: dataQuestioner,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role'] = role;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "CounselorQuestionerPostModel{role: $role, data: $data}";
  }
}

class QuestPostData {
  int? questionnaireId;
  String? question;
  int? questionCategory;
  int? answer;
  var answerDescription;

  QuestPostData(
      {required this.questionnaireId,
      required this.question,
      required this.questionCategory,
      required this.answer,
      required this.answerDescription});

  factory QuestPostData.fromJson(Map<String, dynamic> json) {
    return QuestPostData(
      questionnaireId: json['questionnaire_id'],
      question: json['question'],
      questionCategory: json['question_category'],
      answer: json['answer'],
      answerDescription: json['answer_description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionnaire_id'] = questionnaireId;
    data['question'] = question;
    data['question_category'] = questionCategory;
    data['answer'] = answer;
    data['answer_description'] = answerDescription;
    return data;
  }

  @override
  String toString() {
    return "QuestPostData{questionnaireId: $questionnaireId, question: $question, questionCategory: $questionCategory, answer: $answer, answerDescription: $answerDescription}";
  }
}
