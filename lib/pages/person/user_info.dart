import 'dart:io';

import 'package:mengda/common/apis/apis.dart';
import 'package:mengda/common/apis/file.dart';
import 'package:mengda/common/controllers/controllers.dart';
import 'package:mengda/common/entitys/entitys.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:mengda/im/util/media_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final Controller c = Get.put(Controller());
  TextEditingController _nickNameCtl = TextEditingController();
  File _imgPath;
  String _imgUrl;
  String _nickName;

  @override
  void initState() {
    super.initState();
    _initInfo();
  }

  _initInfo() {
    setState(() {
      _imgUrl = c.userInfo.avatar;
      _nickName = c.userInfo.nickName;
      _nickNameCtl.text = c.userInfo.nickName;
    });
  }

  Future<void> _uploadImg(File file) async {
    var formData = {'file': file};
    final res =
        await UploadFileAPI.uploadImage(context: context, params: formData);
    if (res['code'] == 0) {
      msg(msg: '上传成功');

      print(res['url']);
      setState(() {
        _imgUrl = res['url'];
      });
    } else {
      msg(msg: '上传失败');
    }
  }

  _saveInfo() async {
    ResponseInfo saveInfo = await UserAPI.saveAvatar(
      avatar: _imgUrl,
      nickName: _nickNameCtl.text,
    );
    if (saveInfo.code == 0) {
      Get.back();
    } else {
      msg(msg: saveInfo.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人帐号'),
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          cell(
            title: '头像',
            onTap: () async {
              _imgPath =
                  await ImagePicker.pickImage(source: ImageSource.gallery);
              _uploadImg(_imgPath);
            },
            trailing: circleAvatar(url: _imgUrl, size: 36),
          ),
          cell(
            title: '昵称',
            note: _nickName,
            onTap: () {
              dialogConfirm(
                content: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  child: inputTextEdit(
                    controller: _nickNameCtl,
                  ),
                ),
                onConfirm: () {
                  setState(() {
                    _nickName = _nickNameCtl.text;
                  });
                  Get.back();
                },
              );
            },
          ),
          // cell(
          //   title: '手机号',
          //   note: '',
          //   onTap: () {},
          // ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: flatButton(title: '保存', onPressed: _saveInfo),
          )
        ],
      ),
    );
  }
}
