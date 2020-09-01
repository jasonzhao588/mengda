import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:mengda/common/widgets/widgets.dart';

class QrCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('二维码'),
      ),
      backgroundColor: Colors.white,
      body: GetBuilder<Controller>(
          init: Controller(),
          initState: (_) {
            Controller.to.getQrcode();
          },
          builder: (_) {
            return _.qrcode == null
                ? loading()
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 200,
                          width: 200,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primaryDark.withOpacity(.6),
                              style: BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          child: Image.network(
                            _.qrcode.data,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('扫码添加好友')
                      ],
                    ),
                  );
          }),
    );
  }
}
