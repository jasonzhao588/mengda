import 'package:flutter/material.dart';
import 'package:mengda/common/values/values.dart';

/// 圆形文字按钮
Widget circleBox(
    {String text,
    Function onTap,
    Color color: Colors.orange,
    Widget child,
    double size: 50.0,
    EdgeInsetsGeometry margin,
    String backgroundImage,
    FontWeight fontWeight}) {
  return Container(
    margin: margin,
    child: Stack(
      overflow: Overflow.clip,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            image: backgroundImage == null
                ? null
                : DecorationImage(
                    image: AssetImage(backgroundImage),
                    fit: BoxFit.cover,
                  ),
          ),
          child: text == null
              ? child
              : Text(
                  text,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: fontWeight),
                ),
        ),
        Positioned.fill(
            child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(size / 2),
            splashColor: Colors.black.withOpacity(0.1),
            highlightColor: Colors.black.withOpacity(0.05),
            onTap: onTap,
          ),
        )),
      ],
    ),
  );
}

/// 圆形按钮
Widget circleButton(
    {Widget child,
    Color color,
    Function onTap,
    double radius: 16,
    double elevation: 0.0,
    double highlightElevation: 0.0}) {
  return Container(
    width: radius * 2,
    height: radius * 2,
    child: MaterialButton(
      color: color,
      elevation: elevation,
      highlightElevation: highlightElevation,
      padding: EdgeInsets.all(0),
      child: child,
      onPressed: onTap,
      shape: CircleBorder(),
    ),
  );
}

/// 圆形头像

Widget circleAvatar({String url, double size = 40, Function onTap}) {
  return Stack(
    children: <Widget>[
      CircleAvatar(
        backgroundImage: url == null
            ? AssetImage(AssetsPath.defaultAvatar)
            : NetworkImage(url),
        radius: size / 2,
        backgroundColor: Colors.grey[300],
      ),
      Positioned.fill(
          child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          splashColor: Colors.black.withOpacity(0.1),
          highlightColor: Colors.black.withOpacity(0.05),
          onTap: onTap,
        ),
      ))
    ],
  );
}
