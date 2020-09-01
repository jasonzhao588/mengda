import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mengda/common/entitys/entitys.dart';
import 'package:mengda/utils/utils.dart';

import 'common/values/values.dart';

class Global {
  static ThemeData globalThemeData = ThemeData(
    primaryColor: AppColors.primary,
    accentColor: AppColors.secondary,
    scaffoldBackgroundColor: AppColors.primaryBackground,
    splashColor: Colors.black.withOpacity(.1),
    // hoverColor: AppColors.primaryElement.withOpacity(.1),
    highlightColor: Colors.black.withOpacity(.05),
    dividerColor: AppColors.greyBorder,
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: AppColors.appBarBgColor,
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: AppColors.primaryDark),
      textTheme: TextTheme(
        title: TextStyle(
          color: AppColors.primaryDark,
          fontSize: 17.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  /// 用户配置
  static LoginResponseEntity profile = LoginResponseEntity(
    accessToken: null,
  );

  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  /// init
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // 工具初始
    await StorageUtil.init();
    HttpUtil();

    // 读取设备第一次打开
    isFirstOpen = !StorageUtil().getBool(STORAGE_DEVICE_ALREADY_OPEN_KEY);
    if (isFirstOpen) {
      StorageUtil().setBool(STORAGE_DEVICE_ALREADY_OPEN_KEY, true);
    }

    // 读取离线用户信息
    var _profileJSON = await StorageUtil().getJSON(STORAGE_USER_PROFILE_KEY);
    print('用户登录信息$_profileJSON');
    if (_profileJSON != null) {
      profile = LoginResponseEntity.fromJson(_profileJSON);
      isOfflineLogin = true;
    }

    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  // 持久化 用户信息
  static Future<bool> saveProfile(LoginResponseEntity userResponse) {
    profile = userResponse;
    return StorageUtil().setJSON(STORAGE_USER_PROFILE_KEY, profile.toJson());
  }

  // 退出登录
  static Future<bool> clearProfile(
    BuildContext context, {
    bool isGoLogin = true,
  }) {
    isOfflineLogin = false;
    if (isGoLogin) {
      goLoginPage(context);
    }
    return StorageUtil().setJSON(STORAGE_USER_PROFILE_KEY, null);
  }

  // 持久化 账号密码
  static Future<bool> saveLogin(LoginRequestEntity userRequest) {
    return StorageUtil().setJSON(STORE_LOGIN_INFO, userRequest);
  }
}
