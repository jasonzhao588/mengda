import 'dart:io';

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = Platform.isAndroid ? 80 : 100;
  final String title;
  final Color startColor, endColor, bgColor, titleColor, shadowColor, iconColor;
  final AppBarTextTheme appBarTheme;
  final double elevation;
  final Widget leading;
  final List<Widget> actions;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget bottom;

  CustomAppBar({
    this.title,
    this.startColor,
    this.endColor,
    this.bgColor: Colors.white,
    this.titleColor,
    this.appBarTheme = AppBarTextTheme.light,
    this.elevation = 16,
    this.shadowColor = const Color(0x12000000),
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.iconColor,
    this.bottom,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _preferredHeight,
      alignment: Alignment.center,
      // padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        gradient: startColor == null
            ? null
            : LinearGradient(
                colors: <Color>[
                  startColor,
                  endColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: elevation,
            color: shadowColor,
          )
        ],
      ),
      child: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: leading,
        actions: actions,
        bottom: bottom,
        brightness: appBarTheme == AppBarTextTheme.dark
            ? Brightness.dark
            : Brightness.light,
        automaticallyImplyLeading: automaticallyImplyLeading,
        iconTheme: IconThemeData(
          color: iconColor != null
              ? titleColor
              : appBarTheme == AppBarTextTheme.dark
                  ? Colors.white
                  : Colors.black,
          opacity: .8,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            color: titleColor != null
                ? titleColor
                : appBarTheme == AppBarTextTheme.dark
                    ? Colors.white
                    : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}

enum AppBarTextTheme { light, dark }
