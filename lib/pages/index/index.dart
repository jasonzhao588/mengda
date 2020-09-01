import 'package:flutter/material.dart';
import 'package:mengda/global.dart';
import 'package:mengda/pages/application/application.dart';
import 'package:mengda/pages/sign_in/sign_in.dart';
import 'package:mengda/pages/welcome/welcome.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
    print('----------------------------');
    print(Global.isOfflineLogin);
    print(Global.profile?.accessToken);
    print('----------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Global.isOfflineLogin ? ApplicationPage() : SignInPage(),
    );
  }
}
