class LoginModel {
  Status? status;
  User? response;
  String? error;
  String? errorDescription;

  LoginModel({
    required this.status,
    required this.response,
    required this.error,
    required this.errorDescription,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"] == null ? null : Status.fromJson(json["status"]),
    response: json["response"] == null ? null : User.fromJson(json["response"]),
    error: json["error"],
    errorDescription: json["error_description"],
  );

  Map<String, dynamic> toJson() => {
    "status": status?.toJson(),
    "response": response?.toJson(),
    "error": error,
    "error_description": errorDescription,
  };
}

class User {
  String accessToken;
  String tokenType;
  String refreshToken;
  int expiresIn;
  String scope;
  List<dynamic> userRole;
  String tenantName;
  String userType;
  String userId;
  String userName;
  dynamic primary;

  User({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
    required this.expiresIn,
    required this.scope,
    required this.userRole,
    required this.tenantName,
    required this.userType,
    required this.userId,
    required this.userName,
    required this.primary,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    refreshToken: json["refresh_token"],
    expiresIn: json["expires_in"],
    scope: json["scope"],
    userRole: List<dynamic>.from(json["user_role"].map((x) => x)),
    tenantName: json["tenant_name"],
    userType: json["user_type"],
    userId: json["user_id"],
    userName: json["user_name"],
    primary: json["primary"],
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "refresh_token": refreshToken,
    "expires_in": expiresIn,
    "scope": scope,
    "user_role": List<dynamic>.from(userRole.map((x) => x)),
    "tenant_name": tenantName,
    "user_type": userType,
    "user_id": userId,
    "user_name": userName,
    "primary": primary,
  };
}

class Status {
  int code;
  String? message;

  Status({
    required this.code,
    required this.message,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}
