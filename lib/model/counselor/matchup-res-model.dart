class MatchupResModel {
  int? status;
  String? message;
  List<MatchupResData>? data;

  MatchupResModel({this.status, this.message, this.data});

  factory MatchupResModel.fromJson(Map<String, dynamic> json) {
    // status = json['status'];
    // message = json['message'];
    List<MatchupResData> data = <MatchupResData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(MatchupResData.fromJson(v));
      });
    }
    return MatchupResModel(
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

class MatchupResData {
  int? id;
  int? category;
  String? question;
  String? description;
  int? priority;
  int? isNoPreference;
  int? isCounselorDob;
  int? order;
  List<MatchupAnswers>? matchupAnswers;

  MatchupResData(
      {this.id,
      this.category,
      this.question,
      this.description,
      this.priority,
      this.isNoPreference,
      this.isCounselorDob,
      this.order,
      this.matchupAnswers});

  factory MatchupResData.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // category = json['category'];
    // question = json['question'];
    // description = json['description'];
    // priority = json['priority'];
    // isNoPreference = json['is_no_preference'];
    // isCounselorDob = json['is_counselor_dob'];
    // order = json['order'];
    List<MatchupAnswers> matchupAnswers = <MatchupAnswers>[];
    if (json['matchup_answers'] != null) {
      json['matchup_answers'].forEach((v) {
        matchupAnswers.add(MatchupAnswers.fromJson(v));
      });
    }
    return MatchupResData(
      id: json['id'],
      category: json['category'],
      question: json['question'],
      description: json['description'],
      priority: json['priority'],
      isNoPreference: json['is_no_preference'],
      isCounselorDob: json['is_counselor_dob'],
      order: json['order'],
      matchupAnswers: matchupAnswers,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    data['question'] = question;
    data['description'] = description;
    data['priority'] = priority;
    data['is_no_preference'] = isNoPreference;
    data['is_counselor_dob'] = isCounselorDob;
    data['order'] = order;
    if (matchupAnswers != null) {
      data['matchup_answers'] = matchupAnswers?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MatchupAnswers {
  int? id;
  String? answer;
  int? priority;
  int? order;
  List<AnswerChildren>? answerChildren;

  MatchupAnswers(
      {this.id, this.answer, this.priority, this.order, this.answerChildren});

  factory MatchupAnswers.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // answer = json['answer'];
    // priority = json['priority'];
    // order = json['order'];
    List<AnswerChildren> answerChildren = <AnswerChildren>[];
    if (json['answer_children'] != null) {
      json['answer_children'].forEach((v) {
        answerChildren.add(AnswerChildren.fromJson(v));
      });
    }
    return MatchupAnswers(
      id: json['id'],
      answer: json['answer'],
      priority: json['priority'],
      order: json['order'],
      answerChildren: answerChildren,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['answer'] = answer;
    data['priority'] = priority;
    data['order'] = order;
    if (answerChildren != null) {
      data['answer_children'] = answerChildren?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnswerChildren {
  int? id;
  String? answer;
  int? order;

  AnswerChildren({this.id, this.answer, this.order});

  factory AnswerChildren.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    // answer = json['answer'];
    // order = json['order'];
    return AnswerChildren(
      id: json['id'],
      answer: json['answer'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['answer'] = answer;
    data['order'] = order;
    return data;
  }
}
