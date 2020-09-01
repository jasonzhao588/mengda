import 'package:mengda/common/apis/im.dart';
import 'package:mengda/common/controllers/controllers.dart';
import 'package:mengda/common/entitys/entitys.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:mengda/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  TextEditingController _searchText = TextEditingController();
  List<People> _usersList;
  final token = Global.profile?.accessToken;

  Controller c = Get.put(Controller());

  _onSearch() async {
    _usersList = await ImAPI.getFindUserList(
      context: context,
      token: token,
      keyword: _searchText.text,
    );
    print(_usersList.toList());

    if (mounted) {
      setState(() {});
    }
  }

  _onAddFriend(String userName) async {
    print('$userName');
    ResponseInfo result =
        await ImAPI.addFriend(token: token, userName: userName);
    print(result.code == 0);
    if (result.code == 0) {
      msg(msg: '添加成功');
      // Get.back();
    } else {
      msg(msg: result.msg);
    }
  }

  _renderUserList() {
    return _usersList.length == 0
        ? empty()
        : ListView.separated(
            itemCount: _usersList.length,
            itemBuilder: (BuildContext context, int index) {
              People item = _usersList[index];
              return ListTile(
                title: Text(item.userName),
                leading: circleAvatar(url: item.avatar),
                trailing: flatButton(
                  title: '添加',
                  width: 60,
                  height: 32,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  bgColor: AppColors.primary.withOpacity(.1),
                  fontColor: AppColors.primary,
                  borderRadius: BorderRadius.circular(3),
                  onPressed: () => _onAddFriend(item.userName),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 72),
                child: Divider(
                  height: 4,
                  thickness: .33,
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加联系人'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.crop_free), onPressed: () => c.scanCode()),
          SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: inputTextEdit(
                    controller: _searchText,
                    hintText: '请输入帐号/手机号',
                    height: 40,
                    contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                flatButton(
                  title: '搜索',
                  width: 60,
                  height: 40,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  onPressed: _onSearch,
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: .33,
          ),
          Expanded(
            child: _usersList == null ? Container() : _renderUserList(),
          )
        ],
      ),
    );
  }
}
