import 'package:flutter/material.dart';
import 'package:mengda/utils/utils.dart';
import 'package:mengda/common/values/values.dart';

/// 输入框
Widget inputTextEdit({
  TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String hintText,
  bool isPassword = false,
  bool isSelector = false,
  double marginTop = 0,
  bool autofocus = false,
  Widget after,
  IconData prefixIcon,
  Widget child,
  Function onTap,
  String selectValue,
  double height = 48,
  double fontSize = 16,
  FontWeight fontWeight,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.fromLTRB(20, 12, 8, 12),
}) {
  _renderSelector() {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                selectValue == null ? hintText : selectValue,
                style: TextStyle(
                  fontSize: fontSize,
                  color: selectValue == null
                      ? AppColors.greyText.withOpacity(.8)
                      : AppColors.primaryDark,
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.greyText,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  _renderInput() {
    return Stack(
      children: <Widget>[
        TextField(
          autofocus: autofocus,
          controller: controller,
          keyboardType: keyboardType,
          textAlignVertical: TextAlignVertical.center,

          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.greyText.withOpacity(.8),
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
            ),
            contentPadding: contentPadding,
            border: InputBorder.none,
            prefixIcon: prefixIcon == null
                ? null
                : Opacity(
                    opacity: .5,
                    child: Icon(
                      prefixIcon,
                    ),
                  ),
          ),
          style: TextStyle(
            color: AppColors.primaryDark,
            fontFamily: "Avenir",
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
          maxLines: 1,
          autocorrect: false, // 自动纠正
          obscureText: isPassword, // 隐藏输入内容, 密码框
        ),
        Positioned(
          right: 0,
          top: -13,
          child: Container(
            child: after,
          ),
        )
      ],
    );
  }

  return Container(
    height: height,
    margin: EdgeInsets.only(top: marginTop),
    decoration: BoxDecoration(
      color: AppColors.inputBgColor,
      borderRadius: Radii.k6pxRadius,
    ),
    child: child != null
        ? child
        : (isSelector ? _renderSelector() : _renderInput()),
  );
}

/// email 输入框
/// 背景白色，文字黑色，带阴影
Widget inputEmailEdit({
  TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String hintText,
  bool isPassword = false,
  double marginTop = 15,
  bool autofocus = false,
}) {
  return Container(
    height: 44,
    margin: EdgeInsets.only(top: marginTop),
    decoration: BoxDecoration(
      color: AppColors.primaryBackground,
      borderRadius: Radii.k6pxRadius,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(41, 0, 0, 0),
          offset: Offset(0, 1),
          blurRadius: 0,
        ),
      ],
    ),
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(20, 10, 6, 10),
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: AppColors.primaryDark,
        ),
      ),
      style: TextStyle(
        color: AppColors.primaryDark,
        fontFamily: "Avenir",
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      maxLines: 1,
      autocorrect: false, // 自动纠正
      obscureText: isPassword, // 隐藏输入内容, 密码框
    ),
  );
}
