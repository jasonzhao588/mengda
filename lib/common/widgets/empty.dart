import 'package:flutter/material.dart';

Widget empty({double height, String text: '暂无数据'}) {
  return Container(
    height: height,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 50),
    alignment: Alignment.center,
    child: Text(
      text,
      style: TextStyle(color: Colors.grey, fontSize: 15),
    ),
  );
}
