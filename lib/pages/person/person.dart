import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/user_header.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:mengda/global.dart';
import 'package:mengda/pages/person/qrcode.dart';
import 'package:mengda/pages/person/user_info.dart';
import 'package:mengda/pages/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart' as prefix;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:mengda/common/controllers/controllers.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  void _initPage() {
    c.getUserInfo();
  }

  void _logout() async {
    prefix.RongIMClient.disconnect(false);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove("token");
    Global.clearProfile(context);
    Get.off(SignInPage());
  }

  void _pushToDebug() {
    Navigator.pushNamed(context, "/debug");
  }

  _renderBody() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 10),
      children: <Widget>[
        _renderBuilder(),
        card(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                // cellItem(
                //   title: '用户信息',
                //   icon: Icons.person_outline,
                //   onTap: () => Get.toNamed('/userInfo'),
                // ),
                cellItem(
                  title: '检测更新',
                  icon: Icons.update,
                  onTap: () {
                    msg(msg: '当前已是最新版本');
                  },
                ),
                cellItem(
                  title: '二维码',
                  icon: Icons.crop_free,
                  onTap: () => Get.to(QrCodePage()),
                ),
                cellItem(
                  title: '关于我们',
                  icon: Icons.info_outline,
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationIcon: Image.asset('assets/images/logo.png'),
                      applicationName: '萌搭',
                      applicationVersion: 'version 1.1.0',
                      applicationLegalese: '2015-2020 @ 萌搭版权所有',
                    );
                  },
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: flatButton(
            title: '退出登录',
            bgColor: Colors.red[400],
            onPressed: _logout,
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: flatButton(
        //     title: '调试',
        //     onPressed: _pushToDebug,
        //   ),
        // )
      ],
    );
  }

  _renderBuilder() {
    return GetBuilder<Controller>(
      init: Controller(),
      initState: (_) {
        Controller.to.getUserInfo();
      },
      builder: (_) {
        if (_.userInfo == null) {
          return Container(height: 100, child: loading());
        } else {
          return card(
            onTap: () =>
                Get.to(UserInfoPage()).then((value) => _.getUserInfo()),
            child: userHeader(
              avatarUrl: _.userInfo.avatar,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              userName: '${_.userInfo.nickName}',
              subTitle: '${_.userInfo.userName}',
              after: Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            left: -50,
            top: -30,
            child: circleBox(size: 200, color: Colors.red.withOpacity(.05))),
        Positioned(
            left: 150,
            top: -50,
            child: circleBox(size: 130, color: Colors.blue.withOpacity(.1))),
        Positioned(
            right: -50,
            top: -50,
            child: circleBox(size: 160, color: Colors.green.withOpacity(.1))),
        Positioned(
            right: 150,
            top: 150,
            child: circleBox(size: 60, color: Colors.purple.withOpacity(.06))),
        Positioned(
            right: 80,
            top: 100,
            child: circleBox(size: 30, color: Colors.pink.withOpacity(.1))),
        Positioned(
            left: 150,
            top: 80,
            child: circleBox(size: 90, color: Colors.orange.withOpacity(.06))),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('我的'),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                  )),
              SizedBox(
                width: 5,
              )
            ],
          ),
          body: _renderBody(),
        ),
      ],
    );
  }
}
