import 'client_answer.dart';

class ClientQuestionerData {
  int? id;
  String? category;
  int? userRole;
  String? question;
  String? description;
  int? questionCategory;
  int? questionType;
  List<ClientAnswer>? answer;
  int? status;
  int? order;

  ClientQuestionerData({
    this.id,
    this.category,
    this.userRole,
    this.question,
    this.description,
    this.questionCategory,
    this.questionType,
    this.answer,
    this.status,
    this.order,
  });

  factory ClientQuestionerData.fromJson(Map<String, dynamic> json) {
    return ClientQuestionerData(
      id: json['id'] as int?,
      category: json['category'] as String?,
      userRole: json['user_role'] as int?,
      question: json['question'] as String?,
      description: json['description'] as String?,
      questionCategory: json['question_category'] as int?,
      questionType: json['question_type'] as int?,
      answer: (json['answer'] as List<dynamic>?)
          ?.map((e) => ClientAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
      order: json['order'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'user_role': userRole,
        'question': question,
        'description': description,
        'question_category': questionCategory,
        'question_type': questionType,
        'answer': answer?.map((e) => e.toJson()).toList(),
        'status': status,
        'order': order,
      };
  @override
  String toString() {
    return "ClientQuestionerData{id: $id, category: $category, userRole: $userRole, question: $question, description: $description, questionCategory: $questionCategory, questionType: $questionType, answer: $answer, status: $status, order: $order} \n";
  }
}
