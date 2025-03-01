
import '../../exam/model/exam_detail_model.dart';

class SaveQuestionExamListModel {
  bool? result;
  String? message;
  String? question;
  String? category;

  List<ExamQuestion>? exams;

  SaveQuestionExamListModel({this.result, this.message, this.exams,this.question,this.category});

  SaveQuestionExamListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    question = json['question'];
    category = json['category'];
    if (json['exams'] != null) {
      exams = <ExamQuestion>[];
      json['exams'].forEach((v) {
        exams!.add(new ExamQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    data["question"]= this.question;
    data['category']= this.category;
    if (this.exams != null) {
      data['exams'] = this.exams!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




