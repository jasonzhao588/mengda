import 'package:flutter/material.dart';
import 'package:mengda/global.dart';
import 'package:mengda/pages/person/person.dart';
import 'package:mengda/utils/utils.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/im/pages/conversation_list_page.dart';
import 'package:mengda/other/contacts_page.dart';
import 'package:mengda/im/util/event_bus.dart';
import 'package:mengda/im/util/db_manager.dart';
import 'package:mengda/im/util/user_info_datesource.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'dart:developer' as developer;

class ApplicationPage extends StatefulWidget {
  ApplicationPage({Key key}) : super(key: key);

  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage>
    with SingleTickerProviderStateMixin {
  // 当前 tab 页码
  int _page = 0;
  // 页控制器
  PageController _pageController;
  String pageName = 'mainPage';

  // 底部导航项目
  final List<BottomNavigationBarItem> _bottomTabs = <BottomNavigationBarItem>[
    new BottomNavigationBarItem(
      icon: Icon(Iconfont.home),
      activeIcon: Icon(Iconfont.home),
      title: Column(
        children: <Widget>[SizedBox(height: 3), Text('首页')],
      ),
      // backgroundColor: Colors.white,
    ),
    new BottomNavigationBarItem(
      icon: Icon(Iconfont.grid),
      activeIcon: Icon(Iconfont.grid),
      title: Column(
        children: <Widget>[SizedBox(height: 3), Text('联系人')],
      ),
    ),
    new BottomNavigationBarItem(
      icon: Icon(Iconfont.me),
      activeIcon: Icon(Iconfont.me),
      title: Column(
        children: <Widget>[SizedBox(height: 3), Text('我的')],
      ),
    ),
  ];

  // tab栏动画
  void _handleNavBarTap(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  // tab栏页码切换
  void _handlePageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: this._page);

    _initUserInfoCache();
    initPlatformState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 内容页
  Widget _buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        ConversationListPage(),
        ContactsPage(),
        PersonPage(),
      ],
      controller: _pageController,
      onPageChanged: _handlePageChanged,
    );
  }

  // 底部导航
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: AppColors.tabBarBgColor,
      items: _bottomTabs,
      currentIndex: _page,
      fixedColor: AppColors.primary,
      type: BottomNavigationBarType.fixed,
      onTap: _handleNavBarTap,
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedItemColor: AppColors.lightText,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 50,
    );
  }

  int curIndex = 0;

  _backLoginPage() {
    // Get.off(SignInPage());
  }

  initPlatformState() async {
    //1.初始化 im SDK
    // RongIMClient.init(RongAppKey);

    var token = Global.profile?.accessToken;

    //2.连接 im SDK
    if (token != null && token.length > 0) {
      // int rc = await RongIMClient.connect(token);
      RongIMClient.connect(token, (int code, String userId) {
        developer.log("connect result " + code.toString(), name: pageName);
        EventBus.instance.commit(EventKeys.UpdateNotificationQuietStatus, {});
        if (code == 31004 || code == 12) {
          developer.log("connect result " + code.toString(), name: pageName);
          _backLoginPage();
        } else if (code == 0) {
          developer.log("connect userId" + userId, name: pageName);
          // 连接成功后打开数据库
          _initUserInfoCache();
        }
      });
    } else {
      _backLoginPage();
    }
  }

  // 初始化用户信息缓存
  void _initUserInfoCache() {
    DbManager.instance.openDb();
    UserInfoCacheListener cacheListener = UserInfoCacheListener();
    cacheListener.getUserInfo = (String userId) {
      return UserInfoDataSource.generateUserInfo(userId);
    };
    cacheListener.getGroupInfo = (String groupId) {
      return UserInfoDataSource.generateGroupInfo(groupId);
    };
    UserInfoDataSource.setCacheListener(cacheListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppBar(),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
