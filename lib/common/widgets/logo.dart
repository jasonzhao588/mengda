import 'package:flutter/material.dart';
import 'package:mengda/common/values/values.dart';

Widget buildLogo({
  appName = '萌搭',
  subName = '让聊天变得更简单',
}) {
  return Container(
    // width: 110,
    margin: EdgeInsets.only(top: 40 + 44.0), // 顶部系统栏 44px
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 80,
          width: 80,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "assets/images/logo.png",
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Container(
        //   margin: EdgeInsets.only(top: 15),
        //   child: Text(
        //     appName,
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       color: AppColors.primaryDark,
        //       fontFamily: "Montserrat",
        //       fontWeight: FontWeight.w600,
        //       fontSize: 24,
        //       height: 1,
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: 8,
        // ),
        // Text(
        //   subName,
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     color: AppColors.greyText,
        //     fontFamily: "Avenir",
        //     fontWeight: FontWeight.w400,
        //     fontSize: 14,
        //     height: 1,
        //   ),
        // ),
      ],
    ),
  );
}
