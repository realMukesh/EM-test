class UserModel {
  String? result;
  String? token;
  bool? status;
  String? message;
  User? user;

  UserModel({this.result, this.token, this.status, this.message, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  String? phone;
  dynamic image;
  String? dateOfBirth;
  dynamic socialLoginCreatedBy;
  dynamic googleId;
  int? stateId;
  int? cityId;

  User(
      {this.id,
        this.name,
        this.username,
        this.email,
        this.phone,
        this.image,
        this.dateOfBirth,
        this.socialLoginCreatedBy,
        this.googleId,
        this.stateId,
        this.cityId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    dateOfBirth = json['date_of_birth'];
    socialLoginCreatedBy = json['socialLoginCreatedBy'];
    googleId = json['google_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['date_of_birth'] = this.dateOfBirth;
    data['socialLoginCreatedBy'] = this.socialLoginCreatedBy;
    data['google_id'] = this.googleId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    return data;
  }
}
