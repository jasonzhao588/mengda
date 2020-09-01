import 'package:flutter/material.dart';

Widget card({
  @required Widget child,
  EdgeInsetsGeometry margin = const EdgeInsets.fromLTRB(16, 0, 16, 16),
  EdgeInsetsGeometry padding,
  double borderRadius = 8,
  double height,
  Function onTap,
  Color bgColor = Colors.white,
  Color shadowColor = const Color(0x10000000),
  double elevation = 10,
  String backgroundImage,
  Color filterColor,
  double aspectRatio,
}) {
  return Container(
    height: height,
    margin: margin,
    child: Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: elevation,
            color: shadowColor,
          ),
        ],
        image: backgroundImage == null
            ? null
            : DecorationImage(
                image: NetworkImage(backgroundImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  filterColor,
                  BlendMode.hardLight,
                ),
              ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding,
          child: aspectRatio == null
              ? child
              : AspectRatio(
                  aspectRatio: aspectRatio,
                  child: child,
                ),
        ),
      ),
    ),
  );
}
