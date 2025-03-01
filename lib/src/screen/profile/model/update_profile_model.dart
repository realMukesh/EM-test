class UpdateProfileModel {
  String? result;
  String? message;
  Content? content;

  UpdateProfileModel({this.result, this.message, this.content});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? username;
  String? email;
  String? emailVerifiedAt;
  int? wallet;
  String? slug;
  int? loginEnabled;
  String? phone;
  String? image;
  String? dateOfBirth;
  int? stateId;
  int? cityId;
  int? referredBy;
  int? isDelete;
  int? status;
  String? createdAt;
  String? updatedAt;

  Content(
      {this.id,
        this.name,
        this.username,
        this.email,
        this.emailVerifiedAt,
        this.wallet,
        this.slug,
        this.loginEnabled,
        this.phone,
        this.image,
        this.dateOfBirth,
        this.stateId,
        this.cityId,
        this.referredBy,
        this.isDelete,
        this.status,
        this.createdAt,
        this.updatedAt});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    wallet = json['wallet'];
    slug = json['slug'];
    loginEnabled = json['login_enabled'];
    phone = json['phone'];
    image = json['image'];
    dateOfBirth = json['date_of_birth'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    referredBy = json['referredBy'];
    isDelete = json['is_delete'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['wallet'] = this.wallet;
    data['slug'] = this.slug;
    data['login_enabled'] = this.loginEnabled;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['date_of_birth'] = this.dateOfBirth;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['referredBy'] = this.referredBy;
    data['is_delete'] = this.isDelete;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}