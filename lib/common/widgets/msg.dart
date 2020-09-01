import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MsgType { SUCCESS, WARNING, ERROR }

Future<void> msg({
  @required String msg,
  String title,
  Widget icon,
  MsgType type,
}) async {
  Color bgColor = Colors.black.withOpacity(.7);
  String msgTitle = '提示';
  IconData typeIcon = Icons.info_outline;

  if (type == MsgType.SUCCESS) {
    bgColor = Colors.green[600].withOpacity(.8);
    msgTitle = '成功';
    typeIcon = Icons.check;
  } else if (type == MsgType.WARNING) {
    bgColor = Colors.orange[600].withOpacity(.8);
    msgTitle = '警告';
  } else if (type == MsgType.ERROR) {
    bgColor = Colors.red[400].withOpacity(.8);
    msgTitle = '错误';
  }

  return Get.snackbar(
    title ?? msgTitle, // title
    msg, // message
    icon: icon ?? Icon(typeIcon, color: Colors.white.withOpacity(.8)),
    shouldIconPulse: true,
    barBlur: 20,
    isDismissible: true,
    duration: Duration(seconds: 2),
    backgroundColor: bgColor,
    colorText: Colors.white,
    animationDuration: Duration(milliseconds: 500),
    snackPosition: SnackPosition.BOTTOM,
    // maxWidth: 300,
    borderRadius: 10,
    margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
  );
}

////////// ALL FEATURES //////////
//     Color colorText,
//     Duration duration,
//     SnackPosition snackPosition,
//     Widget titleText,
//     Widget messageText,
//     bool instantInit,
//     Widget icon,
//     bool shouldIconPulse,
//     double maxWidth,
//     EdgeInsets margin,
//     EdgeInsets padding,
//     double borderRadius,
//     Color borderColor,
//     double borderWidth,
//     Color backgroundColor,
//     Color leftBarIndicatorColor,
//     List<BoxShadow> boxShadows,
//     Gradient backgroundGradient,
//     FlatButton mainButton,
//     OnTap onTap,
//     bool isDismissible,
//     bool showProgressIndicator,
//     AnimationController progressIndicatorController,
//     Color progressIndicatorBackgroundColor,
//     Animation<Color> progressIndicatorValueColor,
//     SnackStyle snackStyle,
//     Curve forwardAnimationCurve,
//     Curve reverseAnimationCurve,
//     Duration animationDuration,
//     double barBlur,
//     double overlayBlur,
//     Color overlayColor,
//     Form userInputForm
///////////////////////////////////
