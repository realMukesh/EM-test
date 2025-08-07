import 'package:english_madhyam/resrc/models/model/quiz_details.dart';

class SaveQuestionExamModel {
  bool? result;
  String? message;
  List<QuestionsList>? questionsList;

  SaveQuestionExamModel({this.result, this.message, this.questionsList});

  SaveQuestionExamModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['content'] != null) {
      questionsList = <QuestionsList>[];
      json['content'].forEach((v) {
        questionsList!.add(new QuestionsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.questionsList != null) {
      data['content'] =
          this.questionsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionsList {
  int? id;
  String? examId;
  String? eQuestion;
  int? isParagraph;
  Null? paragraphQuestion;
  int? savedQId;
  List<Options>? options;
  Solutions? solution;


  QuestionsList(
      {this.id,
        this.examId,
        this.eQuestion,
        this.isParagraph,
        this.paragraphQuestion,
        this.savedQId,
        this.options,
        this.solution});

  QuestionsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    examId = json['exam_id'];
    eQuestion = json['e_question'];
    isParagraph = json['is_paragraph'];
    paragraphQuestion = json['paragraph_question'];
    savedQId = json['saved_q_id'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    solution = json['solution'] != null
        ? new Solutions.fromJson(json['solution'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['exam_id'] = this.examId;
    data['e_question'] = this.eQuestion;
    data['is_paragraph'] = this.isParagraph;
    data['paragraph_question'] = this.paragraphQuestion;
    data['saved_q_id'] = this.savedQId;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.solution != null) {
      data['solution'] = this.solution!.toJson();
    }
    return data;
  }
}
