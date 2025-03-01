class QuestionCategoryModel {
  String? data;
  String? message;
  List<SqCategories>? sqCategories;

  QuestionCategoryModel({this.data, this.message, this.sqCategories});

  QuestionCategoryModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    if (json['sq_categories'] != null) {
      sqCategories = <SqCategories>[];
      json['sq_categories'].forEach((v) {
        sqCategories!.add(new SqCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['message'] = this.message;
    if (this.sqCategories != null) {
      data['sq_categories'] =
          this.sqCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SqCategories {
  int? id;
  String? name;

  SqCategories({this.id, this.name});

  SqCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
