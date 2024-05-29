import 'dart:convert';

class CounselorQuestionerResModel {
  int? status;
  String? message;
  String? wording;
  CounselorQuestionerData? data;

  CounselorQuestionerResModel({this.status, this.message, this.data});

  CounselorQuestionerResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    wording = json['wording'];
    data = json['data'] != null
        ? CounselorQuestionerData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['wording'] = wording;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return "CounselorQuestionerResModel{status: $status, message: $message, data: $data}";
  }
}

class CounselorQuestionerData {
  String? tempUserCode;
  int? questionnaireId;
  String? question;
  String? questionEn;
  int? questionCategory;
  List<ListAnswer>? listAnswer;
  int? answer;
  String? answerDescription;
  String? answerDescriptionEn;

  CounselorQuestionerData(
      {this.tempUserCode,
      this.questionnaireId,
      this.question,
      this.questionEn,
      this.questionCategory,
      this.listAnswer,
      this.answer,
      this.answerDescription,
      this.answerDescriptionEn});

  CounselorQuestionerData.fromJson(Map<String, dynamic> json) {
    tempUserCode = json['temp_user_code'];
    questionnaireId = json['questionnaire_id'];
    question = json['question'];
    questionEn = json['question_en'];
    questionCategory = json['question_category'];
    List<ListAnswer> listAnswer = <ListAnswer>[];
    if (json['list_answer'] != null) {
      jsonDecode(json['list_answer']).forEach((v) {
        listAnswer.add(ListAnswer.fromJson(v));
      });
    }
    answer = json['answer'];
    answerDescription = json['answer_description'];
    answerDescriptionEn = json['answer_description_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp_user_code'] = tempUserCode;
    data['questionnaire_id'] = questionnaireId;
    data['question'] = question;
    data['question_en'] = questionEn;
    data['question_category'] = questionCategory;
    if (listAnswer != null) {
      data['list_answer'] = listAnswer?.map((v) => v.toJson()).toList();
    }
    data['answer'] = answer;
    data['answer_description'] = answerDescription;
    data['answer_description_en'] = answerDescriptionEn;
    return data;
  }

  @override
  String toString() {
    return "CounselorQuestionerData{tempUserCode: $tempUserCode, questionnaireId: $questionnaireId, question: $question, questionEn: $questionEn, questionCategory: $questionCategory, listAnswer: $listAnswer, answer: $answer, answerDescription: $answerDescription, answerDescriptionEn: $answerDescriptionEn}";
  }
}

class ListAnswer {
  int? id;
  String? answer;
  String? alert;

  ListAnswer({this.id, this.answer, this.alert});

  ListAnswer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answer = json['answer'];
    alert = json['alert'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['answer'] = answer;
    data['alert'] = alert;
    return data;
  }

  @override
  String toString() {
    return "ListAnswer{id: $id, answer: $answer, alert: $alert}";
  }
}
