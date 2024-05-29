import 'package:counselor/model/counselor/counselor_answer.dart';

class CounselorWelcomeQuestionerData {
  int? id;
  String? category;
  int? userRole;
  String? question;
  String? description;
  int? questionCategory;
  int? questionType;
  List<CounselorAnswer>? answer;
  int? status;
  int? order;
  String? createdAt;
  dynamic updatedAt;
  int? createdBy;
  dynamic updatedBy;

  CounselorWelcomeQuestionerData({
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
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory CounselorWelcomeQuestionerData.fromJson(Map<String, dynamic> json) {
    return CounselorWelcomeQuestionerData(
      id: json['id'] as int?,
      category: json['category'] as String?,
      userRole: json['user_role'] as int?,
      question: json['question'] as String?,
      description: json['description'] as String?,
      questionCategory: json['question_category'] as int?,
      questionType: json['question_type'] as int?,
      answer: (json['answer'] as List<dynamic>?)
          ?.map((e) => CounselorAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
      order: json['order'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as dynamic,
      createdBy: json['created_by'] as int?,
      updatedBy: json['updated_by'] as dynamic,
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
        'created_at': createdAt,
        'updated_at': updatedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
      };
  @override
  String toString() {
    return "CounselorWelcomeQuestionerData{id: $id, category: $category, userRole: $userRole, question: $question, description: $description, questionCategory: $questionCategory, questionType: $questionType, answer: $answer, status: $status, order: $order, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy} \n \n";
  }
}
