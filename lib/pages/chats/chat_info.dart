import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:mengda/common/apis/apis.dart';
import 'package:mengda/common/apis/im.dart';
import 'package:mengda/common/controllers/controllers.dart';
import 'package:mengda/common/entitys/entitys.dart';
import 'package:mengda/common/entitys/im.dart';
import 'package:mengda/common/values/text.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:mengda/global.dart';
import 'package:mengda/pages/contacts/add_contact.dart';
import 'package:mengda/pages/index/index.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

class ChatInfo extends StatefulWidget {
  @override
  _ChatInfoState createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  Map arguments = Get.arguments;
  List<People> _memberList;
  People _friendInfo;
  bool _isDisturb = false;
  bool _isBlackList = false;
  int _chatType;
  String _targetId;
  List<String> _selectedList = List<String>();
  Controller c = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  _initPage() {
    setState(() {
      _chatType = arguments['chatType'];
      _targetId = arguments['targetId'];
    });
    _getTargetInfo();
  }

  void _getTargetInfo() async {
    if (_chatType == 1) {
      People result = await ImAPI.getFriend(userName: _targetId);
      setState(() {
        _friendInfo = result;
      });
    } else {
      _getMembers();
    }
  }

  Widget _renderTiles() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SwitchListTile(
            activeColor: AppColors.primary,
            title: Text('消息免打扰'),
            subtitle: Text(
              _isDisturb ? '免打扰' : '有消息提醒',
              style: AppText.xsGreyText,
            ),
            value: _isDisturb,
            onChanged: (value) {
              RongIMClient.setConversationNotificationStatus(
                _chatType,
                _targetId,
                value,
                (int status, int code) {
                  if (status == 0) {
                    setState(() {
                      _isDisturb = value;
                    });
                  } else {
                    setState(() {
                      _isDisturb = value;
                    });
                  }
                },
              );
            },
          ),
          _chatType == 3
              ? Container()
              : SwitchListTile(
                  activeColor: AppColors.primary,
                  title: Text('加入黑名单'),
                  subtitle: Text(
                    _isBlackList ? '已加入黑名单' : '不在黑名单',
                    style: AppText.xsGreyText,
                  ),
                  value: _isBlackList,
                  onChanged: (bool value) {
                    if (value) {
                      RongIMClient.addToBlackList(
                        _targetId,
                        (int code) {
                          if (code == 0) {
                            setState(() {
                              _isBlackList = value;
                            });
                          }
                        },
                      );
                    } else {
                      RongIMClient.removeFromBlackList(
                        _targetId,
                        (int code) {
                          if (code == 0) {
                            setState(() {
                              _isBlackList = value;
                            });
                          }
                        },
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }

  Widget _renderMember() {
    return Container(
      color: Colors.white,
      child: _chatType == 1
          ? _friendInfo == null
              ? loading()
              : ListTile(
                  title: Text(_friendInfo.nickName),
                  leading: circleAvatar(url: _friendInfo.avatar, size: 48),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Text('用户名：${_friendInfo.userName}'),
                    ],
                  ),
                )
          : _memberList == null
              ? loading()
              : GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: _memberList.length + 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2 / 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    int itemIndex =
                        index < _memberList.length ? index : index - 1;
                    return _renderGridList(_memberList[itemIndex], index);
                  },
                ),
    );
  }

  Widget _renderGridList(People item, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: index < _memberList.length
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(item.avatar), fit: BoxFit.cover),
                    ),
                  )
                : _plusBtn(),
          ),
        ),
        Text(
          index < _memberList.length ? item.nickName : '',
          style: AppText.xsGreyText,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )
      ],
    );
  }

  Widget _plusBtn() {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            // color: Colors.grey[100],
            border: Border.all(
              color: Colors.grey[300],
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.add,
            size: 32,
            color: Colors.grey[300],
          ),
        ),
        Positioned.fill(
            child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _addMember,
          ),
        ))
      ],
    );
  }

  _getMembers() async {
    final result = await ImAPI.getGroup(id: _targetId);

    setState(() {
      _memberList = result.members;
    });
  }

  _addMember() {
    c.getContacts();
    Get.bottomSheet(
        SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                child: Text(
                  '选择好友',
                  style: AppText.titleText,
                ),
              ),
              Expanded(
                child: StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return _renderFriendList(setState);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: flatButton(
                    title: '拉进群', height: 40, onPressed: _pullToGroup),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white);
  }

  _pullToGroup() async {
    print(_selectedList.join(','));
    ResponseInfo result = await ImAPI.joinGroup(
      groupId: _targetId,
      userName: _selectedList.join(','),
    );
    if (result.code == 0) {
      print('加入成功');
      setState(() {
        _selectedList = [];
      });
      _getMembers();
    } else {
      print(result.msg);
    }
    Get.back();
  }

  Widget _renderFriendList(newState) {
    List<People> friends = c.friendList;
    return ListView.separated(
      itemCount: friends.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: .5,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        People item = friends[index];

        return Ink(
          color: Colors.white,
          child: CheckboxListTile(
            title: Text(item.nickName),
            value: _selectedList.contains(item.userName),
            secondary: circleAvatar(url: item.avatar),
            activeColor: AppColors.primary,
            onChanged: (bool selected) {
              newState(() {
                selected
                    ? _selectedList.add(item.userName)
                    : _selectedList.remove(item.userName);
                print(_selectedList);
              });
            },
          ),
        );
      },
    );
  }

  void _quitGroup(UserInfoEntity user) async {
    print('用户名：${user.userName}');
    ResponseInfo result =
        await ImAPI.quitGroup(groupId: _targetId, userName: user.userName);

    if (result.code == 0) {
      msg(msg: '已退出群');
      Get.off(IndexPage());
    } else {
      msg(msg: result.msg);
    }
  }

  void _deleteFriend() {}

  Widget _renderBody(Controller _) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _renderMember(),
          SizedBox(height: 16),
          _renderTiles(),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: _chatType == 3
                ? flatButton(
                    title: '退出该群',
                    bgColor: Colors.red,
                    onPressed: () => _quitGroup(_.userInfo),
                  )
                : flatButton(
                    title: '删除好友',
                    bgColor: Colors.red,
                    onPressed: _deleteFriend,
                  ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_chatType == 1 ? '聊天信息' : '群信息'),
        // backgroundColor: Colors.white,
      ),
      body: GetBuilder<Controller>(
          init: Controller(),
          initState: (_) {
            Controller.to.getUserInfo();
          },
          builder: (_) {
            return _renderBody(_);
          }),
    );
  }
}
