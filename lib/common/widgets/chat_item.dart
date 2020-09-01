import 'package:flutter/material.dart';
import 'package:mengda/utils/utils.dart';
import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:intl/intl.dart';

Widget chatItem({
  String avatar,
  String time = '3分钟前',
  String content,
  String userName,
  Widget contentChild,
  bool recivied = true,
  bool showTime = true,
}) {
  _messageBody() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: recivied,
            child: Column(
              children: <Widget>[
                Text(
                  userName ?? '',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.greyText,
                  ),
                ),
                SizedBox(
                  height: userName == null ? 0 : 5,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: contentChild != null
                ? contentChild
                : content == null
                    ? null
                    : Text(
                        content,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
            constraints: BoxConstraints(minWidth: 60),
            decoration: BoxDecoration(
              color: recivied ? Colors.white : Colors.blue[100],
              // boxShadow: [
              //   BoxShadow(
              //     blurRadius: 12,
              //     color: Colors.black.withOpacity(.05),
              //     offset: Offset(0, 5),
              //   )
              // ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(recivied ? 0 : 10),
                bottomRight: Radius.circular(recivied ? 10 : 0),
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  return Container(
    margin: EdgeInsets.only(top: 10),
    child: Column(
      children: <Widget>[
        Visibility(
          visible: showTime,
          child: Center(
            child: time == null
                ? Container()
                : Container(
                    margin: EdgeInsets.only(top: 14),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.black.withOpacity(.2),
                    ),
                  ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: recivied
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    circleAvatar(url: avatar, size: 36),
                    SizedBox(
                      width: 10,
                    ),
                    _messageBody(),
                    Container(
                      width: 40,
                    )
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(width: 40),
                    _messageBody(),
                    SizedBox(width: 10),
                    circleAvatar(url: avatar, size: 36),
                  ],
                ),
        )
      ],
    ),
  );
}
