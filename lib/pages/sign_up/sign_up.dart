import 'package:mengda/common/entitys/entitys.dart';
import 'package:flutter/material.dart';
import 'package:mengda/common/apis/apis.dart';
import 'package:mengda/common/entitys/user.dart';
// import 'package:mengda/common/utils/utils.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:mengda/utils/utils.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nickNameController = TextEditingController();

  // 返回上一页
  _handleNavPop() {
    Navigator.pop(context);
  }

  // 执行注册操作
  _handleSignUp() async {
    if (_usernameController.text == '') {
      toastInfo(msg: '请输入用户名');
      return;
    }
    if (!duCheckStringLength(_passwordController.text, 6)) {
      toastInfo(msg: '密码不能小于6位');
      return;
    }
    if (_nickNameController.text == '') {
      toastInfo(msg: '请输入昵称');
      return;
    }
    if (_confirmPasswordController.text == null) {
      toastInfo(msg: '请再次输入密码');
      return;
    }
    if (_confirmPasswordController.text != _passwordController.text) {
      toastInfo(msg: '两次密码输入不一致');
      return;
    }

    SignupRequestEntity params = SignupRequestEntity(
      userName: _usernameController.text,
      password: _passwordController.text,
      nickName: _nickNameController.text,
    );
    ResponseInfo res = await UserAPI.signup(context: context, params: params);
    print(params.toJson());
    if (res.code == 0) {
      Get.back();
      toastInfo(msg: '注册成功');
    } else {
      toastInfo(msg: res.msg);
    }
  }

  // 有账号
  Widget _buildHaveAccountButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: flatButton(
        onPressed: _handleNavPop,
        height: 44,
        width: 200,
        bgColor: AppColors.secondary,
        fontColor: AppColors.primaryDark,
        title: "已有账号",
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );
  }

  // logo
  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "用户注册",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryDark,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              fontSize: 24,
              height: 1,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            '免费注册，成为我们的会员可参与各种优惠活动',
            style: AppText.smGreyText,
          )
        ],
      ),
    );
  }

  // 注册表单
  Widget _buildInputForm() {
    return Container(
      width: 295,
      margin: EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // fullName input

          inputTextEdit(
            controller: _usernameController,
            hintText: "用户名",
          ),

          SizedBox(height: 24),

          // password input
          inputTextEdit(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            hintText: "密码",
            isPassword: true,
          ),
          SizedBox(height: 24),
          inputTextEdit(
            controller: _confirmPasswordController,
            keyboardType: TextInputType.visiblePassword,
            hintText: "确认密码",
            isPassword: true,
          ),
          SizedBox(height: 24),
          inputTextEdit(
            controller: _nickNameController,
            hintText: "昵称",
          ),

          // 创建
          Container(
            height: 44,
            margin: EdgeInsets.only(top: 24),
            child: flatButton(
              onPressed: _handleSignUp,
              width: 200,
              fontWeight: FontWeight.w600,
              title: "创建账号",
            ),
          ),
          _buildHaveAccountButton(),
          // Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: transparentAppBar(
        context: context,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: AppColors.primaryDark,
            ),
            onPressed: () {
              msg(msg: '这是注册界面');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitle(),
              _buildInputForm(),
            ],
          ),
        ),
      ),
    );
  }
}
