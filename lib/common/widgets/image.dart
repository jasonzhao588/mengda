import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mengda/utils/utils.dart';
import 'package:mengda/common/values/values.dart';

/// 缓存图片
Widget imageCached(
  String url, {
  double width,
  double height,
  EdgeInsetsGeometry margin,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: Radii.k4pxRadius,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
        ),
      ),
    ),
    placeholder: (context, url) {
      return Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    },
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget image(
  String url, {
  double width,
  double height,
  EdgeInsetsGeometry margin,
  BorderRadiusGeometry borderRadius = Radii.k4pxRadius,
  BoxFit fit = BoxFit.cover,
  double aspectRatio = 16 / 9,
  Function onTap,
}) {
  if (url == null) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: Image.asset(
        AssetsPath.defaultImg,
        fit: fit,
      ),
    );
  } else {
    return Stack(
      children: <Widget>[
        Container(
          height: height,
          width: width,
          margin: margin,
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Image.network(
                url,
                fit: fit,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: InkWell(
            onTap: onTap,
          ),
        )
      ],
    );
  }
}
