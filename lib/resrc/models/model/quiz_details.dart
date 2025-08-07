class ExamDetails {
  String? result;
  String? message;
  Content? content;

  ExamDetails({this.result, this.message, this.content});

  ExamDetails.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('result')){
      if(json['result'] is bool){
        if(json['result']==true){
          result="success";
        }else{
          result="failure";
        }
      }else{
        result = json['result'];

      }
    }
    if (json.containsKey('message')) message = json['message'];
    if (json.containsKey('content')) {
      content = Content.fromJson(json['content']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  int? categoryId;
  int? editorialId;
  String? title;
  String? image;
  double? mark;
  double? negativeMark;
  int? type;
  int? isDailyQuiz;
  String? duration;
  String? instruction;
  int? totalQuestions;
  String? publishAt;
  int? status;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  dynamic startDate;
  dynamic endDate;
  dynamic startTime;
  dynamic endTime;
  String? timeLeft;
  int? examQuestionCount;
  List<ExamQuestion>? examQuestion;
  int? isAttempt;
  int? isCompleted;
  int? isPause;

  Content({
    this.id,
    this.categoryId,
    this.editorialId,
    this.title,
    this.image,
    this.mark,
    this.negativeMark,
    this.type,
    this.isDailyQuiz,
    this.duration,
    this.instruction,
    this.totalQuestions,
    this.publishAt,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.timeLeft,
    this.examQuestionCount,
    this.examQuestion,
    this.isAttempt,
    this.isCompleted,
    this.isPause,
  });

  Content.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('id')) id = json['id'];
    if (json.containsKey('category_id')) categoryId = json['category_id'];
    if (json.containsKey('editorial_id')) editorialId = json['editorial_id'];
    if (json.containsKey('title')) title = json['title'];
    if (json.containsKey('image')) image = json['image'];
    if (json.containsKey('mark')) mark = double.parse(json['mark'].toString());
    if (json.containsKey('negative_mark')) {
      negativeMark = double.parse(json['negative_mark'].toString());
    }
    if (json.containsKey('type')) type = json['type'];
    if (json.containsKey('is_daily_quiz')) isDailyQuiz = json['is_daily_quiz'];
    if (json.containsKey('duration')) duration = json['duration'];
    if (json.containsKey('instruction')) instruction = json['instruction'];
    if (json.containsKey('total_questions')) {
      totalQuestions = json['total_questions'];
    }
    if (json.containsKey('publish_at')) publishAt = json['publish_at'];
    if (json.containsKey('status')) status = json['status'];
    if (json.containsKey('is_deleted')) isDeleted = json['is_deleted'];
    if (json.containsKey('created_at')) createdAt = json['created_at'];
    if (json.containsKey('updated_at')) updatedAt = json['updated_at'];
    if (json.containsKey('start_date')) startDate = json['start_date'];
    if (json.containsKey('end_date')) endDate = json['end_date'];
    if (json.containsKey('start_time')) startTime = json['start_time'];
    if (json.containsKey('end_time')) endTime = json['end_time'];
    if (json.containsKey('time_left')) timeLeft = json['time_left'];
    if (json.containsKey('exam_question_count')) {
      examQuestionCount = json['exam_question_count'];
    }
    if (json.containsKey('exam_question')) {
      examQuestion = <ExamQuestion>[];
      json['exam_question'].forEach((v) {
        examQuestion!.add(ExamQuestion.fromJson(v));
      });
    }
    if (json.containsKey('is_attempt')) isAttempt = json['is_attempt'];
    if (json.containsKey('is_compeleted')) isCompleted = json['is_compeleted'];
    if (json.containsKey('is_pause')) isPause = json['is_pause'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['editorial_id'] = this.editorialId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['mark'] = this.mark;
    data['negative_mark'] = this.negativeMark;
    data['type'] = this.type;
    data['is_daily_quiz'] = this.isDailyQuiz;
    data['duration'] = this.duration;
    data['instruction'] = this.instruction;
    data['total_questions'] = this.totalQuestions;
    data['publish_at'] = this.publishAt;
    data['status'] = this.status;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['time_left'] = this.timeLeft;
    data['exam_question_count'] = this.examQuestionCount;
    if (this.examQuestion != null) {
      data['exam_question'] =
          this.examQuestion!.map((v) => v.toJson()).toList();
    }
    data['is_attempt'] = this.isAttempt;
    data['is_compeleted'] = this.isCompleted;
    data['is_pause'] = this.isPause;
    return data;
  }
}
class ExamQuestion {
  int? id;
  dynamic hQuestion;
  String? examId;
  String? eQuestion;
  int ?savedQuestionId;
  dynamic image;
  dynamic subjectName;
  int? boards;
  int? classId;
  String? subject;
  int? chapter;
  int? topic;
  String? marks;
  String? createdAt;
  String? updatedAt;
  int? qId;
  int? isAttempt;
  int? isSelect;
  List<Options>? options;
  Solutions? solutions;
  int? guess;
  int? mark;
  int? ansType;
  String? selectedOptionId;
  int isREAttmpted = 0;
  bool? reported = false;

  ExamQuestion({
    this.id,
    this.hQuestion,
    this.examId,
    this.eQuestion,
    this.savedQuestionId,
    this.image,
    this.subjectName,
    this.boards,
    this.classId,
    this.subject,
    this.chapter,
    this.topic,
    this.reported,
    this.marks,
    this.createdAt,
    this.updatedAt,
    this.qId,
    this.isAttempt,
    this.isSelect,
    this.options,
    this.solutions,
    this.guess,
    this.mark,
    this.ansType,
    required this.isREAttmpted,
  });

  ExamQuestion.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('id') ? json['id'] : null;
    hQuestion = json.containsKey('h_question') ? json['h_question'] : null;
    examId = json.containsKey('exam_id') ? json['exam_id'] : null;
    eQuestion = json.containsKey('e_question') ? json['e_question'] : null;
    savedQuestionId = json.containsKey('saved_q_id') ? json['saved_q_id'] : null;
    image = json.containsKey('image') ? json['image'] : null;
    subjectName = json.containsKey('subject_name') ? json['subject_name'] : null;
    boards = json.containsKey('boards') ? json['boards'] : null;
    classId = json.containsKey('class_id') ? json['class_id'] : null;
    subject = json.containsKey('subject') ? json['subject'] : null;
    chapter = json.containsKey('chapter') ? json['chapter'] : null;
    topic = json.containsKey('topic') ? json['topic'] : null;
    marks = json.containsKey('marks') ? json['marks'] : null;
    createdAt = json.containsKey('created_at') ? json['created_at'] : null;
    updatedAt = json.containsKey('updated_at') ? json['updated_at'] : null;
    qId = json.containsKey('q_id') ? json['q_id'] : null;
    isAttempt = json.containsKey('is_attempt') ? json['is_attempt'] : null;
    isSelect = json.containsKey('is_select') ? json['is_select'] : null;
    if (json.containsKey('options')) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    solutions = json.containsKey('solutions') ? Solutions.fromJson(json['solutions']) : json.containsKey('solution')?Solutions.fromJson(json['solution']) :null;
    guess = json.containsKey('guess') ? json['guess'] : null;
    mark = json.containsKey('mark') ? json['mark'] : null;
    ansType = json.containsKey('ansType') ? json['ansType'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['h_question'] = this.hQuestion;
    data['exam_id'] = this.examId;
    data['e_question'] = this.eQuestion;
    data['image'] = this.image;
    data['subject_name'] = this.subjectName;
    data['boards'] = this.boards;
    data['class_id'] = this.classId;
    data['subject'] = this.subject;
    data['chapter'] = this.chapter;
    data['topic'] = this.topic;
    data['marks'] = this.marks;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['q_id'] = this.qId;
    data['is_attempt'] = this.isAttempt;
    data['is_select'] = this.isSelect;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.solutions != null) {
      data['solutions'] = this.solutions!.toJson();
    }
    data['guess'] = this.guess;
    data['mark'] = this.mark;
    data['ansType'] = this.ansType;
    return data;
  }
}

class Options {
  int? id;
  int? qId;
  dynamic? optionH;
  String? optionE;
  int? correct;
  dynamic? image;
  int? del;
  String? createdAt;
  String? updatedAt;
  int? checked;
  int attempted = 0;

  Options({
    this.id,
    this.qId,
    this.optionH,
    this.optionE,
    this.correct,
    this.image,
    this.del,
    this.createdAt,
    this.updatedAt,
    this.checked,
    required this.attempted,
  });

  Options.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('id') ? json['id'] : null;
    qId = json.containsKey('q_id') ? json['q_id'] : null;
    optionH = json.containsKey('option_h') ? json['option_h'] : null;
    optionE = json.containsKey('option_e') ? json['option_e'] : null;
    correct = json.containsKey('correct') ? json['correct'] : null;
    image = json.containsKey('image') ? json['image'] : null;
    del = json.containsKey('del') ? json['del'] : null;
    createdAt = json.containsKey('created_at') ? json['created_at'] : null;
    updatedAt = json.containsKey('updated_at') ? json['updated_at'] : null;
    checked = json.containsKey('checked') ? json['checked'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['q_id'] = this.qId;
    data['option_h'] = this.optionH;
    data['option_e'] = this.optionE;
    data['correct'] = this.correct;
    data['image'] = this.image;
    data['del'] = this.del;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['checked'] = this.checked;
    data['attempted'] = this.attempted;
    return data;
  }
}

class Solutions {
  int? id;
  int? qId;
  String? eSolutions;
  dynamic hSolutions;
  dynamic image;
  dynamic admittedBy;
  int? del;
  String? createdAt;
  String? updatedAt;

  Solutions({
    this.id,
    this.qId,
    this.eSolutions,
    this.hSolutions,
    this.image,
    this.admittedBy,
    this.del,
    this.createdAt,
    this.updatedAt,
  });

  Solutions.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('id') ? json['id'] : null;
    qId = json.containsKey('q_id') ? json['q_id'] : null;
    eSolutions = json.containsKey('e_solutions') ? json['e_solutions'] : null;
    hSolutions = json.containsKey('h_solutions') ? json['h_solutions'] : null;
    image = json.containsKey('image') ? json['image'] : null;
    admittedBy = json.containsKey('admitted_by') ? json['admitted_by'] : null;
    del = json.containsKey('del') ? json['del'] : null;
    createdAt = json.containsKey('created_at') ? json['created_at'] : null;
    updatedAt = json.containsKey('updated_at') ? json['updated_at'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['q_id'] = this.qId;
    data['e_solutions'] = this.eSolutions;
    data['h_solutions'] = this.hSolutions;
    data['image'] = this.image;
    data['admitted_by'] = this.admittedBy;
    data['del'] = this.del;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

