class SubmitExamModel {
  String ?result;
  String ?message;



  SubmitExamModel({this.result, this.message});

  SubmitExamModel.map(dynamic obj) {
    this.result = obj["result"];
    this.message = obj["message"];
  }
  SubmitExamModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];

  }
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["result"] = result;
    map["message"] = message;
    return map;
  }

}