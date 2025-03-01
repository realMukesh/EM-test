class ExamDetailsModel {
  dynamic result;
  String? message;
  Content? content;

  ExamDetailsModel({this.result, this.message, this.content});

  ExamDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? title;
  int? mark;
  dynamic negativeMark;
  dynamic duration;
  String? instruction;
  int? totalQuestions;
  String? timeLeft;
  List<ExamQuestion>? examQuestion;
  int? isAttempt;
  int? isCompeleted;
  int? isPause;
  int? isDailyQuiz; //missing
  dynamic publishAt; //missing
  dynamic editorialId; //missing
  dynamic categoryId; //missing

  Content(
      {this.id,
      this.title,
      this.mark,
      this.negativeMark,
      this.duration,
      this.instruction,
      this.totalQuestions,
      this.timeLeft,
      this.examQuestion,
      this.isAttempt,
      this.isCompeleted,
      this.isPause,
      this.publishAt,
      this.editorialId});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mark = json['mark'];
    negativeMark = json['negative_mark'];
    duration = json['duration'];
    instruction = json['instruction'];
    totalQuestions = json['total_questions'];
    timeLeft = json['time_left'];
    if (json['exam_question'] != null) {
      examQuestion = <ExamQuestion>[];
      json['exam_question'].forEach((v) {
        examQuestion!.add(new ExamQuestion.fromJson(v));
      });
    }
    isAttempt = json['is_attempt'];
    isCompeleted = json['is_compeleted'];
    isPause = json['is_pause'];
    publishAt = json['publish_at'];
    editorialId = json['editorial_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['mark'] = this.mark;
    data['negative_mark'] = this.negativeMark;
    data['duration'] = this.duration;
    data['instruction'] = this.instruction;
    data['total_questions'] = this.totalQuestions;
    data['time_left'] = this.timeLeft;
    if (this.examQuestion != null) {
      data['exam_question'] =
          this.examQuestion!.map((v) => v.toJson()).toList();
    }
    data['is_attempt'] = this.isAttempt;
    data['is_compeleted'] = this.isCompeleted;
    data['is_pause'] = this.isPause;
    data['publish_at'] = this.publishAt;
    data['editorial_id'] = this.editorialId;

    return data;
  }
}

class ExamQuestion {
  int? id;
  String? eQuestion;
  int? isParagraph;
  String? marks;
  int? isAttempt;
  int? isSelect;
  List<OptionsData>? options;
  Solutions? solutions;
  int isREAttmpted = 0;
  int? ansType; //missing
  int? isBookmark; //missing
  int? bookmarkCateId; //missing

  int? savedQuestionId; //missing

  ExamQuestion(
      {this.id,
      this.eQuestion,
      this.isParagraph,
      this.marks,
      this.isAttempt,
      this.isSelect,
      this.options,
      this.solutions,
      required this.isREAttmpted,
      this.isBookmark});

  ExamQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eQuestion = json['e_question'];
    isParagraph = json['is_paragraph'];
    marks = json['marks'];
    isAttempt = json['is_attempt'];
    isSelect = json['is_select'];
    isBookmark = json['mark'];
    if (json['options'] != null) {
      options = <OptionsData>[];
      json['options'].forEach((v) {
        options!.add(new OptionsData.fromJson(v));
      });
    }
    solutions = json['solutions'] != null
        ? new Solutions.fromJson(json['solutions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['e_question'] = this.eQuestion;
    data['is_paragraph'] = this.isParagraph;
    data['marks'] = this.marks;
    data['is_attempt'] = this.isAttempt;
    data['is_select'] = this.isSelect;
    data['mark'] = this.isBookmark;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.solutions != null) {
      data['solutions'] = this.solutions!.toJson();
    }
    return data;
  }
}

class OptionsData {
  int? id;
  int? qId;
  String? optionE;
  int? correct;
  int? checked;
  int? attempted = 0;

  OptionsData(
      {this.id,
      this.qId,
      this.optionE,
      this.correct,
      this.checked,
      required this.attempted});

  OptionsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qId = json['q_id'];
    optionE = json['option_e'];
    correct = json['correct'];
    checked = json['checked'];
    attempted = json['attempted']??0;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['q_id'] = this.qId;
    data['option_e'] = this.optionE;
    data['correct'] = this.correct;
    data['checked'] = this.checked;
    data['attempted'] = this.attempted;
    return data;
  }
}

class Solutions {
  int? id;
  int? qId;
  String? eSolutions;

  Solutions({this.id, this.qId, this.eSolutions});

  Solutions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qId = json['q_id'];
    eSolutions = json['e_solutions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['q_id'] = this.qId;
    data['e_solutions'] = this.eSolutions;
    return data;
  }
}

