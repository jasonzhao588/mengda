import 'package:flutter/material.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:mengda/pages/sign_in/sign_in.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // Container(
          //   color: AppColors.primaryElement,
          // ),
          Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset('assets/images/welcome.png'),
                        width: 320,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Hello,在吗？',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '开始聊天吧，让我们畅所欲言',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: AppColors.greyText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                bottom: true,
                child: blockButton(
                  context: context,
                  onTap: () {
                    Get.to(SignInPage());
                  },
                  text: '进入',
                  margin: EdgeInsets.fromLTRB(32, 20, 32, 32),
                  width: 200,
                  height: 44,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
