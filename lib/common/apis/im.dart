import 'package:mengda/global.dart';
import 'package:flutter/material.dart';
import 'package:mengda/common/entitys/entitys.dart';
import 'package:mengda/utils/utils.dart';

/// 即时通信
class ImAPI {
  /// 获取好友列表
  static Future<List<People>> getFriendList({
    BuildContext context,
    @required token,
  }) async {
    var response = await HttpUtil().post(
        '/app/Handler/UserHandler.ashx?action=GetFriendList',
        context: context,
        params: {'Token': token});
    // print(response.toString());
    if (response['code'] == 0) {
      return response['data']
          .map<People>((item) => People.fromJson(item))
          .toList();
    } else {
      return null;
    }
  }

  /// 获取查询用户列表
  static Future<List<People>> getFindUserList({
    BuildContext context,
    @required String token,
    @required String keyword,
  }) async {
    var response = await HttpUtil().get(
        '/app/Handler/UserHandler.ashx?action=Search',
        context: context,
        params: {'Token': token, 'keyword': keyword});

    if (response['code'] == 0) {
      return response['data']
          .map<People>((item) => People.fromJson(item))
          .toList();
    } else {
      return null;
    }
  }

  /// 添加好友
  static Future<ResponseInfo> addFriend({
    BuildContext context,
    @required String token,
    @required String userName,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/UserHandler.ashx?action=AddFriend',
      context: context,
      params: {
        'Token': token,
        'UserName': userName,
      },
    );
    return ResponseInfo.fromJson(response);
  }

  /// 获取好友
  static Future<People> getFriend({
    BuildContext context,
    @required String userName,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/UserHandler.ashx?action=GetById',
      context: context,
      params: {
        'Token': Global.profile?.accessToken,
        'UserName': userName,
      },
    );
    return People.fromJson(response['data']);
  }

  /// 创建群组
  static Future<ResponseInfo> createGroup({
    BuildContext context,
    @required String groupName,
    @required String userIds,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/GroupHandler.ashx?action=Create',
      context: context,
      params: {
        'Token': Global.profile?.accessToken,
        'GroupName': groupName,
        'UserIds': userIds,
      },
    );
    return ResponseInfo.fromJson(response);
  }

  /// 获取群组
  static Future<GroupEntity> getGroup({
    BuildContext context,
    @required id,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/GroupHandler.ashx?action=Get',
      context: context,
      params: {
        'id': id,
      },
    );
    return GroupEntity.fromJson(response['data']);
  }

  /// 加入群组
  static Future<ResponseInfo> joinGroup({
    BuildContext context,
    @required groupId,
    @required userName,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/GroupHandler.ashx?action=Join',
      context: context,
      params: {
        'Token': Global.profile?.accessToken,
        'GroupId': groupId,
        'UserName': userName,
      },
    );
    return ResponseInfo.fromJson(response);
  }

  /// 退出群组
  static Future<ResponseInfo> quitGroup({
    BuildContext context,
    @required groupId,
    @required userName,
  }) async {
    var response = await HttpUtil().post(
      '/app/Handler/GroupHandler.ashx?action=Quit',
      context: context,
      params: {
        'Token': Global.profile?.accessToken,
        'GroupId': groupId,
        'UserName': userName,
      },
    );
    return ResponseInfo.fromJson(response);
  }
}
