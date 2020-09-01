import 'package:dio/dio.dart';
import 'package:mengda/common/entitys/entitys.dart';
import 'package:flutter/material.dart';
import 'package:mengda/utils/utils.dart';

class UploadFileAPI {
  static Future<Map> uploadImage(
      {@required BuildContext context, params}) async {
    final options = Options(headers: {'Content-Type': 'multipart/form-data;'});
    final file = params['file'];
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: 'avatar.png')
    });
    var response = await HttpUtil().post(
      '/app/Handler/CommonHandler.ashx?action=Upload',
      context: context,
      params: formData,
      options: options,
    );

    return response;
  }
}
