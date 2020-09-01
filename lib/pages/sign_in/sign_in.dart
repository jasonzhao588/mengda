import 'package:mengda/common/apis/apis.dart';
import 'package:mengda/im/util/http_util.dart';
import 'package:flutter/material.dart';
import 'package:mengda/common/entitys/entitys.dart';
import 'package:mengda/utils/utils.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:mengda/global.dart';
import 'package:mengda/pages/application/application.dart';
import 'package:mengda/pages/index/index.dart';
import 'package:mengda/pages/sign_up/sign_up.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    _initAccount();
  }

  // 跳转 注册界面
  _handleNavSignUp() {
    Get.to(SignUpPage());
    // ExtendedNavigator.rootNavigator.pushNamed(Routes.signUpPageRoute);
  }

  _initAccount() async {
    var loginInfo = await StorageUtil().getJSON(STORE_LOGIN_INFO);
    if (loginInfo != null) {
      setState(() {
        _userNameController.text = loginInfo['UserName'];
        _passwordController.text = loginInfo['Password'];
      });
    }
  }

  // 执行登录操作
  _handleSignIn() {
    if (_userNameController.text == '') {
      msg(msg: '请输入用户名');
      // msg(msg: '请输入用户名');
      return;
    }
    if (!duCheckStringLength(_passwordController.text, 6)) {
      msg(msg: '密码不能小于6位');
      return;
    }
    if (_passwordController.text == '') {
      msg(msg: '请输入密码');
    }

    setState(() {
      showLoading = true;
    });
    _login();
    // _loginTestAccount();
  }

  void _login() async {
    LoginRequestEntity params = LoginRequestEntity(
      userName: _userNameController.text,
      // password: duSHA256(_passwordController.text),
      password: _passwordController.text,
    );
    Global.clearProfile(context, isGoLogin: false);
    // 登录请求
    LoginResponseEntity loginResponse = await UserAPI.login(
      context: context,
      params: params,
    );

    setState(() {
      showLoading = false;
    });
    if (loginResponse.code == 0) {
      print(loginResponse.toString());

      msg(title: '提示', msg: '登录成功');
      setState(() {
        Global.isOfflineLogin = true;
      });
      Global.saveProfile(loginResponse);
      Global.saveLogin(params);
      _saveUserInfo(
        id: params.userName,
        token: loginResponse.accessToken,
      );
      Get.off(IndexPage());
    } else {
      toastInfo(msg: loginResponse.msg);
    }
  }

  // 测试账户登录
  void _loginTestAccount() async {
    Map param = new Map();
    param["region"] = 86;
    param["userName"] = int.parse(_userNameController.text);
    param["password"] = _passwordController.text;
    HttpDio.post("http://api.sealtalk.im/user/login", (data) {
      if (data != null) {
        Map body = data;
        int errorCode = body["code"];
        setState(() {
          showLoading = false;
        });
        if (errorCode == 200) {
          Map result = body["result"];
          String id = result["id"];
          String token = result["token"];
          _saveUserInfo(id: id, token: token);

          Get.off(ApplicationPage());
        } else if (errorCode == -1) {
          msg(msg: "网络未连接，请连接网络重试");
        } else {
          msg(msg: "服务器登录失败，errorCode： $errorCode");
        }
      } else {
        msg(msg: '数据不能为空');
      }
    }, params: param);
  }

  void _saveUserInfo({String id, String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id);
    prefs.setString("token", token);
    prefs.setString("userName", _userNameController.text);
    prefs.setString("password", _passwordController.text);
  }

  // 登录表单
  Widget _buildInputForm() {
    return Container(
      width: 260,
      // height: 204,
      margin: EdgeInsets.only(top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Input
          inputTextEdit(
            prefixIcon: Icons.person,
            controller: _userNameController,
            hintText: "用户名",
            marginTop: 0,
          ),
          // password input
          inputTextEdit(
            marginTop: 24,
            prefixIcon: Icons.lock,
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            hintText: "登录密码",
            isPassword: true,
          ),

          // 注册、登录 横向布局
          Container(
            margin: EdgeInsets.symmetric(vertical: 32),
            child: Row(
              children: [
                // 注册
                flatButton(
                  onPressed: _handleNavSignUp,
                  bgColor: AppColors.primary.withOpacity(.1),
                  fontColor: AppColors.primary,
                  title: "注册",
                ),
                Spacer(),
                // 登录
                flatButton(
                  onPressed: () => _handleSignIn(),
                  bgColor: AppColors.primary,
                  title: "登录",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildLogo(),
                    _buildInputForm(),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: !showLoading
                  ? Container()
                  : Container(
                      color: Colors.white.withOpacity(.5),
                      child: loading(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
