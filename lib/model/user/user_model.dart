class UserModel {
  String? status;
  User? user;
  Authorisation? authorisation;

  UserModel({this.status, this.user, this.authorisation});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    authorisation = json['authorisation'] != null
        ? Authorisation.fromJson(json['authorisation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (authorisation != null) {
      data['authorisation'] = authorisation!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? profileImage;
  String? createdAt;
  String? updatedAt;
  String? profileUrl;

  User(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.profileImage,
        this.createdAt,
        this.updatedAt,
        this.profileUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    profileImage = json['profile_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileUrl = json['profile_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['profile_image'] = profileImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['profile_url'] = profileUrl;
    return data;
  }
}

class Authorisation {
  String? token;
  String? type;

  Authorisation({this.token, this.type});

  Authorisation.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['type'] = type;
    return data;
  }
}