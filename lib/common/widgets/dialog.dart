import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mengda/common/values/values.dart';

Future<void> dialogConfirm({
  String title,
  @required Widget content,
  Function onConfirm,
  Function onCancel,
}) async {
  Get.defaultDialog(
    title: title ?? '提示',
    content: content,
    onConfirm: onConfirm,
    onCancel: onCancel,
    textConfirm: '确定',
    textCancel: '取消',
    radius: 10,
    cancelTextColor: AppColors.greyText,
    confirmTextColor: AppColors.primary,
  );
}
