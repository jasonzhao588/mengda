import 'package:flutter/material.dart';
import 'package:mengda/common/values/values.dart';

/// 扁平圆角按钮
Widget flatButton({
  Function onPressed,
  double width = 100,
  double height = 44,
  Color bgColor = AppColors.primary,
  String title = "button",
  Color fontColor = AppColors.primaryWhite,
  double fontSize = 16,
  String fontName = "Montserrat",
  FontWeight fontWeight = FontWeight.w600,
  double iconSize = 20,
  IconData icon,
  BorderRadiusGeometry borderRadius = Radii.k4pxRadius,
}) {
  return Container(
    width: width,
    height: height,
    child: FlatButton(
      onPressed: onPressed,
      color: bgColor,
      disabledColor: bgColor.withOpacity(.6),
      disabledTextColor: fontColor.withOpacity(.8),
      padding: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: icon != null,
            child: Container(
              margin: EdgeInsets.only(right: 8),
              child: Icon(
                icon,
                color: fontColor,
                size: iconSize,
              ),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fontColor,
              fontFamily: fontName,
              fontWeight: fontWeight,
              fontSize: fontSize,
              height: 1.1,
            ),
          ),
        ],
      ),
    ),
  );
}

/// 第三方按钮
Widget btnFlatButtonBorderOnlyWidget({
  @required VoidCallback onPressed,
  double width = 88,
  double height = 44,
  String iconFileName,
}) {
  return Container(
    width: width,
    height: height,
    child: FlatButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        side: Borders.primaryBorder,
        borderRadius: Radii.k6pxRadius,
      ),
      child: Image.asset(
        "assets/images/icons-$iconFileName.png",
      ),
    ),
  );
}

Widget blockButton({
  BuildContext context,
  @required Function onTap,
  @required String text,
  double height: 44,
  double width: double.infinity,
  double fontSize: 16,
  EdgeInsetsGeometry margin: const EdgeInsets.symmetric(vertical: 20),
  Color bgColor: AppColors.primary,
  Color textColor: AppColors.primaryWhite,
  double shadowRadius,
  BorderRadiusGeometry borderRadius = Radii.k6pxRadius,
  double iconSize = 20,
  IconData icon,
}) {
  return Container(
    width: width,
    height: height,
    margin: margin,
    decoration: BoxDecoration(
      boxShadow: shadowRadius == null
          ? null
          : [
              BoxShadow(
                offset: Offset(0, 5),
                blurRadius: shadowRadius,
                color: bgColor.withOpacity(.2),
              )
            ],
    ),
    child: FlatButton(
      color: bgColor,
      textColor: textColor,
      disabledColor: bgColor.withOpacity(.6),
      disabledTextColor: textColor.withOpacity(.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: icon != null,
            child: Container(
              margin: EdgeInsets.only(right: 8),
              child: Icon(
                icon,
                color: textColor,
                size: iconSize,
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(fontSize: fontSize, height: 1),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      onPressed: onTap,
    ),
  );
}

Widget flatTextButton({
  @required String text,
  @required Function onTap,
  EdgeInsetsGeometry margin,
  double fontSize: 16,
  Color color: AppColors.primary,
  double height: 40,
}) {
  return Container(
    height: height,
    margin: margin,
    child: FlatButton(
      onPressed: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontFamily: "Avenir",
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
          height: 1, // 设置下行高，否则字体下沉
        ),
      ),
    ),
  );
}

Widget outlineButton({
  @required String text,
  @required Function onTap,
  EdgeInsetsGeometry margin,
  EdgeInsetsGeometry padding: const EdgeInsets.symmetric(horizontal: 5),
  double fontSize: 16,
  Color color: AppColors.primary,
  double height: 40,
  double width,
  double radius: 4,
  double borderWidth: 1,
}) {
  return Container(
    height: height,
    width: width,
    margin: margin,
    child: OutlineButton(
      onPressed: onTap,
      color: color,
      borderSide: BorderSide(color: color, width: borderWidth),
      // highlightColor: color,
      highlightedBorderColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: padding,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontFamily: "Avenir",
          fontWeight: FontWeight.w400,
          fontSize: fontSize,
          // height: 1, // 设置下行高，否则字体下沉
        ),
      ),
    ),
  );
}
