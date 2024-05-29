class QuestionerWelcomePayload {
  int? questionnaireId;
  String? question;
  int? questionCategory;
  int? answer;
  String? answerDescription;

  QuestionerWelcomePayload({
    this.questionnaireId,
    this.question,
    this.questionCategory,
    this.answer,
    this.answerDescription,
  });

  factory QuestionerWelcomePayload.fromJson(Map<String, dynamic> json) {
    return QuestionerWelcomePayload(
      questionnaireId: json['questionnaire_id'] as int?,
      question: json['question'] as String?,
      questionCategory: json['question_category'] as int?,
      answer: json['answer'] as int?,
      answerDescription: json['answer_description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'questionnaire_id': questionnaireId,
        'question': question,
        'question_category': questionCategory,
        'answer': answer,
        'answer_description': answerDescription,
      };
}
