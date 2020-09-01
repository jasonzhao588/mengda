import 'package:flutter/foundation.dart';

// 登录请求
class LoginRequestEntity {
  String userName;
  String password;

  LoginRequestEntity({
    @required this.userName,
    @required this.password,
  });

  factory LoginRequestEntity.fromJson(Map<String, dynamic> json) =>
      LoginRequestEntity(
        userName: json["UserName"],
        password: json["Password"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName,
        "Password": password,
      };
}

// 登录返回
class LoginResponseEntity {
  LoginResponseEntity({this.code, this.accessToken, this.msg});

  int code;
  String accessToken;
  String msg;

  factory LoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      LoginResponseEntity(
        code: json["code"],
        msg: json["msg"],
        accessToken: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": accessToken,
      };
}

// 注册请求
class SignupRequestEntity {
  SignupRequestEntity({
    this.userName,
    this.password,
    this.nickName,
  });

  String userName;
  String password;
  String nickName;

  factory SignupRequestEntity.fromJson(Map<String, dynamic> json) =>
      SignupRequestEntity(
        userName: json["Username"],
        password: json["Password"],
        nickName: json["NickName"],
      );

  Map<String, dynamic> toJson() => {
        "Username": userName,
        "Password": password,
        "NickName": nickName,
      };
}

// 用户信息
class UserInfoEntity {
  UserInfoEntity({
    this.userName,
    this.nickName,
    this.avatar,
  });

  String userName;
  String nickName;
  String avatar;

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) => UserInfoEntity(
        userName: json["UserName"],
        nickName: json["NickName"],
        avatar: json["Avatar"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName,
        "NickName": nickName,
        "Avatar": avatar,
      };
}
