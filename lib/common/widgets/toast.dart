import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> toastInfo({
  @required String msg,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  ToastGravity position = ToastGravity.BOTTOM,
  Toast toastLength = Toast.LENGTH_SHORT,
  double fontSize = 14,
}) async {
  return await Fluttertoast.showToast(
    msg: msg,
    toastLength: toastLength,
    gravity: position,
    timeInSecForIos: 1,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}
