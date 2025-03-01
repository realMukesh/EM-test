
class ExamListModel {
  String? result;
  String? message;
  Content? content;

  ExamListModel({this.result, this.message, this.content});

  ExamListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    return data;
  }
}

class Content {
  int? currentPage;
  List<ExamData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Content(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Content.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ExamData>[];
      json['data'].forEach((v) {
        data!.add(new ExamData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class ExamData {
  int? id;
  int? categoryId;
  String? title;
  int? mark;
  String? duration;
  int? type;
  int? totalQuestions;
  ExamResult? examResult;
  String? image;
  double? procTime;
  UserRank? userRank;
  bool? attempted;
  dynamic completed;

  ExamData(
      {this.id,
      this.categoryId,
      this.title,
      this.mark,
      this.duration,
      this.type,
      this.totalQuestions,
      this.examResult,
      this.image,
      this.procTime,
      this.userRank,
      this.attempted,
      this.completed});

  ExamData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    title = json['title'];
    mark = json['mark'];
    duration = json['duration'];
    type = json['type'];
    totalQuestions = json['total_questions'];
    examResult = json['exam_result'] != null
        ? new ExamResult.fromJson(json['exam_result'])
        : null;
    image = json['image'];
    procTime = json['proc_time'];
    userRank = json['user_rank'] != null
        ? new UserRank.fromJson(json['user_rank'])
        : null;
    attempted = json['attempted'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['mark'] = this.mark;
    data['duration'] = this.duration;
    data['type'] = this.type;
    data['total_questions'] = this.totalQuestions;
    if (this.examResult != null) {
      data['exam_result'] = this.examResult!.toJson();
    }
    data['image'] = this.image;
    data['proc_time'] = this.procTime;
    if (this.userRank != null) {
      data['user_rank'] = this.userRank!.toJson();
    }
    data['attempted'] = this.attempted;
    data['completed'] = this.completed;
    return data;
  }
}

class ExamResult {
  int? id;
  int? userId;
  int? examId;
  dynamic examData;
  int? totalQuestion;
  int? correctQuestion;
  int? incorrectQuestion;
  int? skipQuestion;
  double? totalMarks;
  dynamic marks;
  String? time;
  int? rank;
  String? createdAt;
  String? updatedAt;

  ExamResult(
      {this.id,
      this.userId,
      this.examId,
      this.examData,
      this.totalQuestion,
      this.correctQuestion,
      this.incorrectQuestion,
      this.skipQuestion,
      this.totalMarks,
      this.marks,
      this.time,
      this.rank,
      this.createdAt,
      this.updatedAt});

  ExamResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    examId = json['exam_id'];
    examData = json['exam_data'];
    totalQuestion = json['total_question'];
    correctQuestion = json['correct_question'];
    incorrectQuestion = json['incorrect_question'];
    skipQuestion = json['skip_question'];
    totalMarks = json.containsKey('total_marks') && json['total_marks'] != null
        ? double.parse(json['total_marks'].toString())
        : null;
    marks = json['marks'];
    time = json['time'];
    rank = json['rank'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['exam_id'] = this.examId;
    data['exam_data'] = this.examData;
    data['total_question'] = this.totalQuestion;
    data['correct_question'] = this.correctQuestion;
    data['incorrect_question'] = this.incorrectQuestion;
    data['skip_question'] = this.skipQuestion;
    data['total_marks'] = this.totalMarks;
    data['marks'] = this.marks;
    data['time'] = this.time;
    data['rank'] = this.rank;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class UserRank {
  int? rank;
  int? totalStudents;

  UserRank({this.rank, this.totalStudents});

  UserRank.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    totalStudents = json['total_students'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['total_students'] = this.totalStudents;
    return data;
  }
}
