
import 'package:english_madhyam/resrc/models/model/quiz_list/quiz_list.dart';

class SaveQuestionExamListModel {
  bool? result;
  String? message;
  List<ExamData>? exams;

  SaveQuestionExamListModel({this.result, this.message, this.exams});

  SaveQuestionExamListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['exams'] != null) {
      exams = <ExamData>[];
      json['exams'].forEach((v) {
        exams!.add(new ExamData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.exams != null) {
      data['exams'] = this.exams!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




