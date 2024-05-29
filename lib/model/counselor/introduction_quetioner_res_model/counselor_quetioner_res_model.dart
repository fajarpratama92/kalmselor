import 'package:flutter/foundation.dart';

import 'counselor_questioner_data.dart';

class CounselorQuetionerResModel {
  int? status;
  String? message;
  List<CounselorGetToKnowData>? data;
  List<CounselorQuestionerData>? questionerData;

  CounselorQuetionerResModel({this.status, this.message, this.data});

  factory CounselorQuetionerResModel.fromJson(Map<String, dynamic> json) {
    return CounselorQuetionerResModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map(
              (e) => CounselorGetToKnowData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
  @override
  String toString() {
    return 'CounselorQuetionerResModel{status: $status, message: $message, data: $data}';
  }
}

class CounselorGetToKnowData {
  int? id;
  String? tempUserCode;
  int? questionnaireId;
  String? question;
  String? description;
  String? descriptionEn;
  int? questionCategory;
  List<ListAnswer>? listAnswer;
  String? answer;
  String? answerDescription;
  String? createdAt;
  String? updatedAt;

  CounselorGetToKnowData(
      {this.id,
      this.tempUserCode,
      this.questionnaireId,
      this.question,
      this.description,
      this.descriptionEn,
      this.questionCategory,
      this.listAnswer,
      this.answer,
      this.answerDescription,
      this.createdAt,
      this.updatedAt});

  CounselorGetToKnowData.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      tempUserCode = json['temp_user_code'];
      questionnaireId = json['questionnaire_id'];
      question = json['question'];
      description = json['description'];
      descriptionEn = json['description_en'];
      questionCategory = json['question_category'];
      if (json['list_answer'] != null) {
        listAnswer = <ListAnswer>[];
        json['list_answer'].forEach((v) {
          listAnswer?.add(ListAnswer.fromJson(v));
        });
      }
      answer = json['answer'];
      answerDescription = json['answer_description'];
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
    } catch (e) {
        print(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['temp_user_code'] = tempUserCode;
    data['questionnaire_id'] = questionnaireId;
    data['question'] = question;
    data['description'] = description;
    data['description_en'] = descriptionEn;
    data['question_category'] = questionCategory;
    if (listAnswer != null) {
      data['list_answer'] = listAnswer?.map((v) => v.toJson()).toList();
    }
    data['answer'] = answer;
    data['answer_description'] = answerDescription;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return "CounselorGetToKnowData{id: $id, tempUserCode: $tempUserCode, questionnaireId: $questionnaireId, question: $question, description: $description, descriptionEn: $descriptionEn, questionCategory: $questionCategory, listAnswer: $listAnswer, answer: $answer, answerDescription: $answerDescription, createdAt: $createdAt, updatedAt: $updatedAt}";
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
    return "ListAnswer{id: $id, answer: $answer, alert: $alert} \n";
  }
}
