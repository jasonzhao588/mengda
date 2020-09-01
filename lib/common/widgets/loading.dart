import 'package:flutter/material.dart';
import 'package:mengda/common/values/values.dart';

Widget loading() {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
    ),
  );
}
