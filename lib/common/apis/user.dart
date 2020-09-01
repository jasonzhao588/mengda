import 'package:mengda/global.dart';
import 'package:flutter/material.dart';
import 'package:mengda/common/entitys/entitys.dart';
import 'package:mengda/utils/utils.dart';

/// 用户
class UserAPI {
  /// 登录
  static Future<LoginResponseEntity> login({
    @required BuildContext context,
    @required LoginRequestEntity params,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/CommonHandler.ashx?action=Login',
      context: context,
      params: params.toJson(),
    );
    return LoginResponseEntity.fromJson(response);
  }

  /// 注册
  static Future<ResponseInfo> signup({
    @required BuildContext context,
    @required SignupRequestEntity params,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/CommonHandler.ashx?action=Register',
      context: context,
      params: params.toJson(),
    );
    return ResponseInfo.fromJson(response);
  }

  /// 用户信息
  static Future<UserInfoEntity> getUserInfo({
    BuildContext context,
    @required token,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/UserHandler.ashx?action=Get',
      context: context,
      params: {'Token': token},
    );
    return UserInfoEntity.fromJson(response['data']);
  }

  /// 修改用户头像
  static Future<ResponseInfo> saveAvatar({
    BuildContext context,
    @required avatar,
    @required nickName,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/UserHandler.ashx?action=Save',
      context: context,
      params: {
        'Token': Global.profile?.accessToken,
        'Avatar': avatar,
        'NickName': nickName,
      },
    );
    return ResponseInfo.fromJson(response);
  }

  /// 二维码
  static Future<ResponseInfo> getQrCode({
    BuildContext context,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/UserHandler.ashx?action=GetQRCode',
      context: context,
      params: {
        'Token': Global.profile?.accessToken,
      },
    );
    return ResponseInfo.fromJson(response);
  }
}
