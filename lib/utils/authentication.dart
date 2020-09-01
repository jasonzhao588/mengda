import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mengda/utils/utils.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/global.dart';
import 'package:mengda/pages/sign_in/sign_in.dart';
import 'package:get/get.dart';

/// 检查是否有 token
Future<bool> isAuthenticated() async {
  var profileJSON = StorageUtil().getJSON(STORAGE_USER_PROFILE_KEY);
  return profileJSON != null ? true : false;
}

/// 删除缓存 token
Future deleteAuthentication() async {
  await StorageUtil().remove(STORAGE_USER_PROFILE_KEY);
  Global.profile = null;
}

/// 重新登录
Future goLoginPage(BuildContext context) async {
  await deleteAuthentication();
  Get.to(SignInPage());
}
