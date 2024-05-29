class UserQuestionerPayload {
  int? questionnaireId;
  String? question;
  int? answer;
  dynamic answerDescription;

  UserQuestionerPayload({
    this.questionnaireId,
    this.question,
    this.answer,
    this.answerDescription,
  });

  factory UserQuestionerPayload.fromJson(Map<String, dynamic> json) {
    return UserQuestionerPayload(
      questionnaireId: json['questionnaire_id'],
      question: json['question'],
      answer: int.parse(json['answer']),
      answerDescription: json['answer_description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'questionnaire_id': questionnaireId,
        'question': question,
        'answer': answer,
        'answer_description': answerDescription,
      };
  @override
  String toString() {
    return "UserQuestionerPayload{ id : $questionnaireId, question : $question, answer : $answer, answerDescription : $answerDescription}";
  }
}
