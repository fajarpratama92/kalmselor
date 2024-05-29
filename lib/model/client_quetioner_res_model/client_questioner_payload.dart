class ClientQuestionerPayload {
  int? questionnaireId;
  String? question;
  int? answer;
  dynamic answerDescription;

  ClientQuestionerPayload({
    this.questionnaireId,
    this.question,
    this.answer,
    this.answerDescription,
  });

  factory ClientQuestionerPayload.fromJson(Map<String, dynamic> json) {
    return ClientQuestionerPayload(
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
    return "ClientQuestionerPayload{ id : $questionnaireId, question : $question, answer : $answer, answerDescription : $answerDescription}";
  }
}
