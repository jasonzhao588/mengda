import 'package:flutter/material.dart';
import 'package:mengda/common/values/values.dart';

class AppText {
  // 标题文字 ===================
  static final TextStyle lgTitleText = TextStyle(
    fontSize: 18,
    color: AppColors.primaryDark,
    height: 1,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle titleText = TextStyle(
    fontSize: 16,
    color: AppColors.primaryDark,
    height: 1.2,
    fontWeight: FontWeight.bold,
  );

  // 灰色文字 ===================
  static final TextStyle smTitleText = TextStyle(
    fontSize: 13,
    color: AppColors.greyText,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle greyText = TextStyle(
    fontSize: 16,
    color: AppColors.greyText,
  );

  static final TextStyle xsGreyText = TextStyle(
    fontSize: 12,
    color: AppColors.greyText,
  );

  static final TextStyle smGreyText = TextStyle(
    fontSize: 14,
    color: AppColors.greyText,
  );

  // 默认文字 ===================
  static final TextStyle normalText = TextStyle(
    fontSize: 16,
    color: AppColors.primaryDark,
    height: 1.2,
  );
  static final TextStyle smNormalText = TextStyle(
    fontSize: 14,
    color: AppColors.primaryDark,
    height: 1.2,
  );

  static final TextStyle lgNormalText = TextStyle(
    fontSize: 16,
    color: AppColors.primaryDark,
    height: 1.2,
  );

  // 连接文字 ===================
  static final TextStyle linkText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey[600],
  );

  // 区块文字 ===================
  static final TextStyle blockText = TextStyle(
    fontSize: 14,
    color: AppColors.primaryDark,
    height: 1.8,
    letterSpacing: 1,
  );
}
