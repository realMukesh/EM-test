class NewUserModel {
  String? result;
  String? token;
  bool? status;
  String? message;
  User? user;

  NewUserModel({this.result, this.token, this.status, this.message, this.user});

  NewUserModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    token = json['token'];
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['token'] = this.token;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? username;
  String? email;
  int? wallet;
  String? slug;
  int? loginEnabled;
  String? phone;
  String? image;
  String? dateOfBirth;
  int? isDelete;
  int? status;
  dynamic googleId;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.name,
        this.username,
        this.email,
        this.wallet,
        this.slug,
        this.loginEnabled,
        this.phone,
        this.image,
        this.dateOfBirth,
        this.isDelete,
        this.status,
        this.googleId,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    wallet = json['wallet'];
    slug = json['slug'];
    loginEnabled = json['login_enabled'];
    phone = json['phone'];
    image = json['image'];
    dateOfBirth = json['date_of_birth'];
    isDelete = json['is_delete'];
    status = json['status'];
    googleId = json['google_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['wallet'] = this.wallet;
    data['slug'] = this.slug;
    data['login_enabled'] = this.loginEnabled;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['date_of_birth'] = this.dateOfBirth;
    data['is_delete'] = this.isDelete;
    data['status'] = this.status;
    data['google_id'] = this.googleId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
