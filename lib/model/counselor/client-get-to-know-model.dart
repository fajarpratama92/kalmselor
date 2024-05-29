class CounselorGetToKnow {
  int? status;
  String? message;
  List<CounselorGetToKnowData>? data;

  CounselorGetToKnow({this.status, this.message, this.data});

  factory CounselorGetToKnow.fromJson(Map<String, dynamic> json) {
    // status = json['status'];
    // message = json['message'];
    List<CounselorGetToKnowData> data = <CounselorGetToKnowData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(CounselorGetToKnowData.fromJson(v));
      });
    }
    return CounselorGetToKnow(
      status: json['status'],
      message: json['message'],
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
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

  factory CounselorGetToKnowData.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // tempUserCode = json['temp_user_code'];
    // questionnaireId = json['questionnaire_id'];
    // question = json['question'];
    // description = json['description'];
    // descriptionEn = json['description_en'];
    // questionCategory = json['question_category'];
    List<ListAnswer> listAnswer = <ListAnswer>[];
    if (json['list_answer'] != null) {
      json['list_answer'].forEach((v) {
        listAnswer.add(ListAnswer.fromJson(v));
      });
    }
    // answer = json['answer'];
    // answerDescription = json['answer_description'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
    return CounselorGetToKnowData(
      id: json['id'],
      tempUserCode: json['temp_user_code'],
      questionnaireId: json['questionnaire_id'],
      question: json['question'],
      description: json['description'],
      descriptionEn: json['description_en'],
      questionCategory: json['question_category'],
      listAnswer: listAnswer,
      answer: json['answer'],
      answerDescription: json['answer_description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
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
}
