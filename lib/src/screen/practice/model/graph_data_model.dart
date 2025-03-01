class GraphDataModel {
  String? result;
  String? message;
  GraphData? content;
  bool? status;

  GraphDataModel({this.result, this.message, this.content, this.status});

  GraphDataModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    content =
    json['content'] != null ? new GraphData.fromJson(json['content']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class GraphData {
  int? totalMarks;
  dynamic marks;
  String? time;
  int? totalQuestion;
  int? correctQuestion;
  int? incorrectQuestion;
  int? skipQuestion;
  int? rank;
  int? totalStudents;

  GraphData(
      {this.totalMarks,
        this.marks,
        this.time,
        this.totalQuestion,
        this.correctQuestion,
        this.incorrectQuestion,
        this.skipQuestion,
        this.rank,
        this.totalStudents});

  GraphData.fromJson(Map<String, dynamic> json) {
    totalMarks = json['total_marks'];
    marks = json['marks'];
    time = json['time'];
    totalQuestion = json['total_question'];
    correctQuestion = json['correct_question'];
    incorrectQuestion = json['incorrect_question'];
    skipQuestion = json['skip_question'];
    rank = json['rank'];
    totalStudents = json['total_students'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_marks'] = this.totalMarks;
    data['marks'] = this.marks;
    data['time'] = this.time;
    data['total_question'] = this.totalQuestion;
    data['correct_question'] = this.correctQuestion;
    data['incorrect_question'] = this.incorrectQuestion;
    data['skip_question'] = this.skipQuestion;
    data['rank'] = this.rank;
    data['total_students'] = this.totalStudents;
    return data;
  }
}
