class SaveQuestionModel {
  bool? result;
  String? message;
  List<QuestionData>? questionList;

  SaveQuestionModel({this.result, this.message, this.questionList});

  SaveQuestionModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['question_list'] != null) {
      questionList = <QuestionData>[];
      json['question_list'].forEach((v) {
        questionList!.add(new QuestionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.questionList != null) {
      data['question_list'] =
          this.questionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionData {
  int? sqCatId;
  int? questionId;
  String? sqCatName;
  int? id;
  String? examId;
  String? eQuestion;
  int? isParagraph;
  dynamic paragraphQuestion;

  QuestionData(
      {this.sqCatId,
        this.sqCatName,
        this.id,
        this.examId,
        this.eQuestion,
        this.isParagraph,
        this.paragraphQuestion,this.questionId});

  QuestionData.fromJson(Map<String, dynamic> json) {
    sqCatId = json['sq_cat_id'];
    sqCatName = json['sq_cat_name'];
    id = json['id'];
    examId = json['exam_id'];
    eQuestion = json['e_question'];
    isParagraph = json['is_paragraph'];
    paragraphQuestion = json['paragraph_question'];
    questionId = json['question_id'];
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
    data['question_id'] = this.questionId;
    return data;
  }
}
