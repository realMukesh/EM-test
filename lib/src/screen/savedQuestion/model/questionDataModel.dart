class QuestionDetailModel {
  bool? result;
  String? message;
  List<QuestionDetail>? content;

  QuestionDetailModel({this.result, this.message, this.content});

  QuestionDetailModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['content'] != null) {
      content = <QuestionDetail>[];
      json['content'].forEach((v) {
        content!.add(new QuestionDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionDetail {
  int? id;
  String? eQuestion;
  int? isParagraph;
  String? marks;
  int? isAttempt;
  int? isSelect;
  List<OptionsData>? options;
  Solution? solutions;
  int isREAttmpted = 0;
  int? ansType; //missing
  int? isBookmark; //missing
  int? savedQuestionId; //missing

  QuestionDetail(
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

  QuestionDetail.fromJson(Map<String, dynamic> json) {
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
    solutions = json['solution'] != null
        ? new Solution.fromJson(json['solution'])
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
      data['solution'] = this.solutions!.toJson();
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
/*class QuestionDetail {
  String? marks;
  int? isAttempt;
  int? isSelect;
  int isREAttmpted = 0;
  int? ansType; //missing
  int? isBookmark; //missing
  int? savedQuestionId; //missing
  dynamic? sqCatId;
  dynamic? sqCatName;
  int? id;
  String? examId;
  String? eQuestion;
  int? isParagraph;
  dynamic paragraphQuestion;
  List<OptionsData>? options;
  Solution? solution;

  QuestionDetail(
      {this.sqCatId,
        this.sqCatName,
        this.id,
        this.examId,
        this.eQuestion,
        this.isParagraph,
        this.paragraphQuestion,
        this.options,
        this.solution});

  QuestionDetail.fromJson(Map<String, dynamic> json) {
    sqCatId = json['sq_cat_id'];
    sqCatName = json['sq_cat_name'];
    id = json['id'];
    examId = json['exam_id'];
    eQuestion = json['e_question'];
    isParagraph = json['is_paragraph'];
    paragraphQuestion = json['paragraph_question'];
    if (json['options'] != null) {
      options = <OptionsData>[];
      json['options'].forEach((v) {
        options!.add(new OptionsData.fromJson(v));
      });
    }
    solution = json['solution'] != null
        ? new Solution.fromJson(json['solution'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sq_cat_id'] = this.sqCatId;
    data['sq_cat_name'] = this.sqCatName;
    data['id'] = this.id;
    data['exam_id'] = this.examId;
    data['e_question'] = this.eQuestion;
    data['is_paragraph'] = this.isParagraph;
    data['paragraph_question'] = this.paragraphQuestion;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.solution != null) {
      data['solution'] = this.solution!.toJson();
    }
    return data;
  }
}

class OptionsData {
  String? optionE;
  int? correct;

  OptionsData({this.optionE, this.correct});

  OptionsData.fromJson(Map<String, dynamic> json) {
    optionE = json['option_e'];
    correct = json['correct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_e'] = this.optionE;
    data['correct'] = this.correct;
    return data;
  }
}*/

class Solution {
  String? eSolutions;

  Solution({this.eSolutions});

  Solution.fromJson(Map<String, dynamic> json) {
    eSolutions = json['e_solutions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['e_solutions'] = this.eSolutions;
    return data;
  }
}
