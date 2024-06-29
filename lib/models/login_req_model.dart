class LoginReqModel {
  String? username;
  String? password;
  String? grantType;

  LoginReqModel({
    this.username,
    this.password,
    this.grantType,
  });

  factory LoginReqModel.fromJson(Map<String, dynamic> json) => LoginReqModel(
    username: json["username"],
    password: json["password"],
    grantType: json["grant_type"],
  );

  Map<String, String> toJson() => {
    "username": username!,
    "password": password!,
    "grant_type": grantType!,
  };
}
