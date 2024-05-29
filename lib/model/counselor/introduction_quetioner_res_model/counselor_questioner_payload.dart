class CounselorQuestionerPayload {
  int? questionnaireId;
  String? question;
  int? answer;
  dynamic answerDescription;

  CounselorQuestionerPayload({
    this.questionnaireId,
    this.question,
    this.answer,
    this.answerDescription,
  });

  factory CounselorQuestionerPayload.fromJson(Map<String, dynamic> json) {
    return CounselorQuestionerPayload(
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
    return "CounselorQuestionerPayload{ id : $questionnaireId, question : $question, answer : $answer, answerDescription : $answerDescription}";
  }
}
