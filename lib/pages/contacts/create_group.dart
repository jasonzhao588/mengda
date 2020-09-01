import 'package:mengda/common/apis/im.dart';
import 'package:mengda/common/controllers/controllers.dart';
import 'package:mengda/common/entitys/common.dart';
import 'package:mengda/common/entitys/im.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mengda/im/pages/conversation_page.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import 'package:mengda/im/pages/item/conversation_list_item.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart' as prefix;

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<String> _selectedList = List<String>();
  TextEditingController _groupName = TextEditingController();

  ConversationListItemDelegate delegate;
  Conversation conversation;

  @override
  void initState() {
    super.initState();
  }

  _createGroup() async {
    print('创建群组');
    dialogConfirm(
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: inputTextEdit(
          hintText: '请输入组名',
          height: 40,
          controller: _groupName,
        ),
      ),
      onCancel: () => Get.back(),
      onConfirm: _groupConfirm,
    );
  }

  _groupConfirm() async {
    ResponseInfo result = await ImAPI.createGroup(
      groupName: _groupName.text,
      userIds: _selectedList.join(','),
    );

    setState(() {
      _selectedList = [];
      _groupName.text = '';
    });
    Get.back();
    if (result.code == 0) {
      msg(msg: '创建成功');

      _goConversation(result.data);
    } else {
      msg(msg: result.msg);
    }
  }

  void _goConversation(String groupId) {
    Map arg = {
      "coversationType": prefix.RCConversationType.Group,
      "targetId": groupId,
    };
    Get.off(ConversationPage(
      arguments: arg,
    ));
  }

  Widget _renderList(List<People> friends) {
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
              setState(() {
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

  _renderBuilder() {
    return GetBuilder<Controller>(
      init: Controller(),
      initState: (_) {
        Controller.to.getContacts();
      },
      builder: (_) {
        if (_.friendList == null) {
          return loading();
        } else {
          return Column(
            children: <Widget>[
              Expanded(
                  child: _.friendList.length < 1
                      ? empty(text: '暂无好友')
                      : _renderList(_.friendList)),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: SafeArea(
                  child: flatButton(
                      title: '创建群组',
                      onPressed:
                          _selectedList.length >= 2 ? _createGroup : null),
                ),
              )
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建群组'),
      ),
      // backgroundColor: AppColors.primaryBackground,
      body: _renderBuilder(),
    );
  }
}
