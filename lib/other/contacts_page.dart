import 'package:mengda/common/apis/im.dart';
import 'package:mengda/common/controllers/controllers.dart';
import 'package:mengda/common/entitys/im.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:mengda/global.dart';
import 'package:mengda/im/pages/conversation_page.dart';
import 'package:mengda/pages/contacts/add_contact.dart';
import 'package:mengda/pages/contacts/create_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart' as prefix;
import 'package:get/get.dart';

import '../im/util/user_info_datesource.dart' as example;

class ContactsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ContactsPageState();
  }
}

class _ContactsPageState extends State<ContactsPage> {
  List<Widget> widgetList = new List();
  List<example.UserInfo> userList = new List();
  final Controller c = Get.put(Controller());
  final token = Global.profile?.accessToken;
  List<People> _friendList;

  TabController controller;

  @override
  void initState() {
    super.initState();
    // _addFriends();
    _getFriends();
  }

  _getFriends() async {
    _friendList = await ImAPI.getFriendList(token: token);

    if (mounted) {
      setState(() {});
    }
  }

  void _onTapUser(People user) {
    Map arg = {
      "coversationType": prefix.RCConversationType.Private,
      "targetId": user.userName,
    };
    // Navigator.pushNamed(context, "/conversation", arguments: arg);
    Get.to(ConversationPage(
      arguments: arg,
      user: user,
    ));
  }

  Widget _nomalPopMenu() {
    return PopupMenuButton<String>(
        icon: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Icon(Icons.add),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(value: '1', child: Text('添加好友')),
              PopupMenuItem<String>(value: '2', child: Text('创建群组')),
            ],
        onSelected: (String value) {
          print(value);
          switch (value) {
            case '1':
              Get.to(AddContact()).then((value) => _getFriends());
              break;
            case '2':
              Get.to(CreateGroup()).then((value) => _getFriends());
              break;
          }
          setState(() {});
        });
  }

  _renderFriends() {
    return _friendList.length == 0
        ? empty(text: '暂无联系人')
        : ListView.separated(
            itemCount: _friendList.length,
            itemBuilder: (BuildContext context, int index) {
              People item = _friendList[index];
              return Ink(
                color: Colors.white,
                child: ListTile(
                  title: Text(item.nickName),
                  leading: Container(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: item.avatar,
                      ),
                    ),
                  ),
                  onTap: () {
                    _onTapUser(item);
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int) {
              return Container(
                height: .5,
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: <Widget>[_nomalPopMenu()],
        title: Text('联系人(${_friendList == null ? 0 : _friendList.length})'),
      ),
      body: _friendList == null ? loading() : _renderFriends(),
    );
  }
}

Widget _tabPageWdiget() {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: TabBar(
            tabs: <Tab>[
              Tab(
                text: "好友",
              ),
              Tab(
                text: "群组",
              ),
            ],
            isScrollable: true,
            indicatorColor: Colors.transparent,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            labelStyle: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: AppColors.primaryDark,
            unselectedLabelStyle: TextStyle(
              fontSize: 14.0,
            ),
          )),
      body: TabBarView(children: <Widget>[
        Container(
          child: Text("好友"),
        ),
        Container(
          child: Text('群组'),
        )
      ]),
    ),
  );
}
