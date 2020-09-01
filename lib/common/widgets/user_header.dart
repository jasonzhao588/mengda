import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:flutter/material.dart';

Widget userHeader({
  @required String userName,
  String avatarUrl,
  String subTitle,
  Function avatarTap,
  EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(20, 0, 20, 24),
  Widget after,
}) {
  return Container(
    padding: padding,
    child: Row(
      children: <Widget>[
        circleAvatar(
          url: avatarUrl,
          size: 60,
          onTap: avatarTap,
        ),
        SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyText,
                ),
              ),
            ],
          ),
        ),
        Container(
          child: after,
        )
      ],
    ),
  );
}
