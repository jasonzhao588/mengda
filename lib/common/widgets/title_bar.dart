import 'package:flutter/material.dart';
import 'package:mengda/common/values/values.dart';

Widget titleBar(
    {@required String title,
    Function onMoreTap,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(16, 12, 10, 12),
    Widget after,
    String rightText = '全部'}) {
  return Container(
    padding: padding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark),
        ),
        Spacer(),
        Container(
          child: after,
        ),
        Container(
          child: onMoreTap == null
              ? null
              : InkWell(
                  onTap: onMoreTap,
                  borderRadius: BorderRadius.circular(3),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        rightText,
                        style: TextStyle(
                            fontSize: 13.0, color: AppColors.greyText),
                      ),
                      Icon(
                        Icons.arrow_right,
                        size: 20,
                        color: AppColors.greyText.withOpacity(.5),
                      )
                    ],
                  ),
                ),
        ),
      ],
    ),
  );
}

Widget smallTitle(String title,
    {EdgeInsetsGeometry margin = const EdgeInsets.only(top: 10)}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    margin: margin,
    child: Text(
      title,
      style: AppText.smTitleText,
    ),
  );
}
