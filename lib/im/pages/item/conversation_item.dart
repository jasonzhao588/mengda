import 'package:mengda/common/apis/im.dart';
import 'package:mengda/common/entitys/entitys.dart';
import 'package:mengda/common/values/text.dart';
import 'package:mengda/global.dart';
import 'package:flutter/material.dart';

import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart' as prefix;
import 'message_item_factory.dart';
import 'widget_util.dart';
import '../../util/style.dart';
import '../../util/user_info_datesource.dart' as example;
import 'dart:developer' as developer;

class ConversationItem extends StatefulWidget {
  prefix.Message message;
  ConversationItemDelegate delegate;
  bool showTime;
  bool multiSelect = false;
  List selectedMessageIds;
  _ConversationItemState state;
  ValueNotifier<int> time = ValueNotifier<int>(0);

  ConversationItem(
      ConversationItemDelegate delegate,
      prefix.Message msg,
      bool showTime,
      bool multiSelect,
      List selectedMessageIds,
      ValueNotifier<int> time) {
    this.message = msg;
    this.delegate = delegate;
    this.showTime = showTime;
    this.multiSelect = multiSelect;
    this.selectedMessageIds = selectedMessageIds;
    this.time = time;
  }

  @override
  State<StatefulWidget> createState() {
    return state = new _ConversationItemState(this.delegate, this.message,
        this.showTime, this.multiSelect, this.selectedMessageIds, this.time);
  }

  void refreshUI(prefix.Message message) {
    this.message = message;
    state._refreshUI(message);
  }
}

class _ConversationItemState extends State<ConversationItem> {
  String pageName = "example.ConversationItem";
  prefix.Message message;
  ConversationItemDelegate delegate;
  bool showTime;
  example.UserInfo user;
  Offset tapPos;
  bool multiSelect;
  bool isSeleceted = false;
  List selectedMessageIds;
  SelectIcon icon;
  People _friendInfo;

  ValueNotifier<int> time = ValueNotifier<int>(0);
  bool needShowMessage = true;

  _ConversationItemState(
      ConversationItemDelegate delegate,
      prefix.Message msg,
      bool showTime,
      bool multiSelect,
      List selectedMessageIds,
      ValueNotifier<int> time) {
    this.message = msg;
    this.delegate = delegate;
    this.showTime = showTime;
    // this.user = example.UserInfoDataSource.getUserInfo(msg.senderUserId);
    this.multiSelect = multiSelect;
    this.selectedMessageIds = selectedMessageIds;
    this.time = time;
    setInfo(message.senderUserId);
    needShowMessage =
        !(msg.messageDirection == prefix.RCMessageDirection.Receive &&
            msg.content != null &&
            msg.content.destructDuration != null &&
            msg.content.destructDuration > 0 &&
            time.value == msg.content.destructDuration);
  }

  void setInfo(String targetId) async {
    _friendInfo = await ImAPI.getFriend(userName: targetId);
    setState(() {});

    example.UserInfo userInfo =
        example.UserInfoDataSource.cachedUserMap[targetId];

    if (userInfo != null) {
      this.user = userInfo;
    } else {
      example.UserInfoDataSource.getUserInfo(targetId).then((onValue) {
        setState(() {
          this.user = onValue;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    bool isSelected = selectedMessageIds.contains(message.messageId);
    icon = SelectIcon(isSelected);
  }

  void _refreshUI(prefix.Message msg) {
    // setState(() {
    this.message = msg;
    // 撤回消息的时候因为是替换之前的消息 UI ，需要整个刷新 item
    if (msg.content is prefix.RecallNotificationMessage) {
      setState(() {});
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: <Widget>[
          this.showTime
              ? WidgetUtil.buildMessageTimeWidget(message.sentTime)
              : WidgetUtil.buildEmptyWidget(),
          showMessage()
        ],
      ),
    );
  }

  Widget showMessage() {
    //属于通知类型的消息
    if (message.content is prefix.RecallNotificationMessage) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Color(RCColor.MessageTimeBgColor),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              RCString.ConRecallMessageSuccess,
              style: TextStyle(
                  color: Colors.white, fontSize: RCFont.MessageNotifiFont),
            ),
          ),
        ],
      );
    } else {
      if (multiSelect == true) {
        return GestureDetector(
          child: Row(
            children: <Widget>[mutiSelectContent(), subContent()],
          ),
          onTap: () {
            __onTapedItem();
          },
        );
      } else {
        return GestureDetector(
          child: Row(
            children: <Widget>[subContent()],
          ),
        );
      }
    }
  }

  Widget subContent() {
    if (message.messageDirection == prefix.RCMessageDirection.Send) {
      return _sendMsg();
    } else if (message.messageDirection == prefix.RCMessageDirection.Receive) {
      return _recivedMsg();
    } else {
      return WidgetUtil.buildEmptyWidget();
    }
  }

  _sendMsg() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Column(
                children: <Widget>[
                  buildMessageWidget(),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                __onTapedUserPortrait();
              },
              child: WidgetUtil.buildUserPortrait(
                  _friendInfo == null ? '' : _friendInfo.avatar),
            ),
          ],
        ),
      ),
    );
  }

  _recivedMsg() {
    // bool _sendSide = message.messageDirection == prefix.RCMessageDirection.Send;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          right: 40,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                __onTapedUserPortrait();
              },
              onLongPress: () {
                __onLongPressUserPortrait(this.tapPos);
              },
              child: WidgetUtil.buildUserPortrait(
                  _friendInfo == null ? '' : _friendInfo.avatar),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _friendInfo == null ? '--' : _friendInfo.nickName,
                      style: TextStyle(
                          color: Color(RCColor.MessageNameBgColor),
                          fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  buildMessageWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mutiSelectContent() {
    // 消息是否添加
    // final alreadySaved = _saved.contains(message);
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: icon,
    );
  }

  void __onTapedItem() {
    if (delegate != null) {
      delegate.didTapItem(message);
      bool isSelected = selectedMessageIds.contains(message.messageId);
      icon.updateUI(isSelected);
    } else {
      developer.log("没有实现 ConversationItemDelegate", name: pageName);
    }
  }

  void __onTapedMesssage() {
    if (multiSelect == false) {
      prefix.RongIMClient.messageBeginDestruct(message);
    }
    // return;
    if (delegate != null) {
      if (multiSelect == true) {
        //多选模式下修改为didTapItem处理
        delegate.didTapItem(message);
        bool isSelected = selectedMessageIds.contains(message.messageId);
        icon.updateUI(isSelected);
      } else {
        if (!needShowMessage) {
          needShowMessage = true;
          setState(() {});
        }
        delegate.didTapMessageItem(message);
      }
    } else {
      developer.log("没有实现 ConversationItemDelegate", name: pageName);
    }
  }

  void __onTapedReadRequest() {
    if (delegate != null) {
      if (message.readReceiptInfo != null &&
          message.readReceiptInfo.isReceiptRequestMessage) {
        delegate.didTapMessageReadInfo(message);
      } else {
        delegate.didSendMessageRequest(message);
      }
    } else {
      developer.log("没有实现 ConversationItemDelegate", name: pageName);
    }
  }

  void __onLongPressMessage(Offset tapPos) {
    if (delegate != null) {
      delegate.didLongPressMessageItem(message, tapPos);
    } else {
      developer.log("没有实现 ConversationItemDelegate", name: pageName);
    }
  }

  void __onTapedUserPortrait() {}

  void __onLongPressUserPortrait(Offset tapPos) {
    if (delegate != null) {
      delegate.didLongPressUserPortrait(this.user.id, tapPos);
    } else {
      developer.log("没有实现 ConversationItemDelegate", name: pageName);
    }
  }

  Widget buildMessageWidget() {
    bool _msgSendSide =
        message.messageDirection == prefix.RCMessageDirection.Send;
    return _messageBodyRow(_msgSendSide);
    // return Row(
    //   children: <Widget>[
    //     Expanded(
    //       child: Container(
    //         // padding: EdgeInsets.fromLTRB(16, _msgSendSide ? 10 : 0, 16, 0),
    //         alignment:
    //             _msgSendSide ? Alignment.centerRight : Alignment.centerLeft,
    //         child: _messageBodyRow(_msgSendSide),
    //       ),
    //     )
    //   ],
    // );
  }

  _messageBodyRow(bool isSendSide) {
    bool _sendSide = message.messageDirection == prefix.RCMessageDirection.Send;
    return Row(
      mainAxisAlignment:
          _sendSide ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        !_sendSide
            ? Container()
            : Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (TapDownDetails details) {
                    this.tapPos = details.globalPosition;
                  },
                  onTap: () {
                    __onTapedReadRequest();
                  },
                  child: message.content != null &&
                          message.content.destructDuration != null &&
                          message.content.destructDuration > 0
                      ? Text("")
                      : buildReadInfo(),
                ),
              ),
        _sendSide &&
                message.content != null &&
                message.content.destructDuration != null &&
                message.content.destructDuration > 0
            ? ValueListenableBuilder(
                builder: (BuildContext context, int value, Widget child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(value > 0 ? '$value ' : '',
                          style: TextStyle(color: Colors.red)),
                    ],
                  );
                },
                valueListenable: time,
              )
            : Container(),
        // sentStatus = 20 为发送失败
        _sendSide && message.sentStatus == 20
            ? Container(
                padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
                child: GestureDetector(
                    onTap: () {
                      if (delegate != null) {
                        if (multiSelect == true) {
                          //多选模式下修改为didTapItem处理
                          delegate.didTapItem(message);
                          bool isSelected =
                              selectedMessageIds.contains(message.messageId);
                          icon.updateUI(isSelected);
                        } else {
                          delegate.didTapReSendMessage(message);
                        }
                      }
                    },
                    child: Image.asset(
                      "assets/images/rc_ic_warning.png",
                      width: RCLayout.MessageErrorHeight,
                      height: RCLayout.MessageErrorHeight,
                    )))
            : WidgetUtil.buildEmptyWidget(),
        Flexible(
          child: Container(
            padding: EdgeInsets.only(
              right: _sendSide ? 0 : 12,
              left: _sendSide ? 12 : 0,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (TapDownDetails details) {
                this.tapPos = details.globalPosition;
              },
              onTap: () {
                __onTapedMesssage();
              },
              onLongPress: () {
                __onLongPressMessage(this.tapPos);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(RCColor.MessageRadius),
                  bottomRight: Radius.circular(
                    message.messageDirection == prefix.RCMessageDirection.Send
                        ? 0
                        : RCColor.MessageRadius,
                  ),
                  topLeft: Radius.circular(
                    message.messageDirection == prefix.RCMessageDirection.Send
                        ? RCColor.MessageRadius
                        : 0,
                  ),
                  bottomLeft: Radius.circular(RCColor.MessageRadius),
                ),
                child: MessageItemFactory(
                    message: message, needShow: needShowMessage),
              ),
            ),
          ),
        ),
        message.messageDirection == prefix.RCMessageDirection.Receive &&
                message.content != null &&
                message.content.destructDuration != null &&
                message.content.destructDuration > 0
            ? ValueListenableBuilder(
                builder: (BuildContext context, int value, Widget child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      value > 0
                          ? Text(
                              " $value",
                              style: TextStyle(color: Colors.red),
                            )
                          : Text("")
                    ],
                  );
                },
                valueListenable: time,
              )
            : Text(""),
      ],
    );
  }

  buildReadInfo() {
    if (message.conversationType == prefix.RCConversationType.Private) {
      return Text(
        message.sentStatus == 50 ? '已读' : '',
        style: AppText.xsGreyText,
      );
    } else if (message.conversationType == prefix.RCConversationType.Group) {
      if (message.readReceiptInfo != null &&
          message.readReceiptInfo.isReceiptRequestMessage) {
        return Text(
          message.readReceiptInfo.userIdList != null
              ? '${message.readReceiptInfo.userIdList.length}人已读'
              : '0人已读',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        );
      } else {
        return Text(canSendMessageReqdRequest() ? '√' : '');
      }
    }
  }

  bool canSendMessageReqdRequest() {
    DateTime time = DateTime.now();
    int nowTime = time.millisecondsSinceEpoch;
    if (nowTime - message.sentTime < 120 * 1000) {
      return true;
    }
    return false;
  }
}

abstract class ConversationItemDelegate {
  //点击 item
  void didTapItem(prefix.Message message);
  //点击消息
  void didTapMessageItem(prefix.Message message);
  //长按消息
  void didLongPressMessageItem(prefix.Message message, Offset tapPos);
  //点击用户头像
  void didTapUserPortrait(String userId);
  //长按用户头像
  void didLongPressUserPortrait(String userId, Offset tapPos);
  //发送消息已读回执请求
  void didSendMessageRequest(prefix.Message message);
  //点击消息已读人数
  void didTapMessageReadInfo(prefix.Message message);
  //点击消息已读人数
  void didTapReSendMessage(prefix.Message message);
}

// 多选模式下 cell 显示的 Icon
class SelectIcon extends StatefulWidget {
  bool isSelected;
  _SelectIconState state;

  SelectIcon(bool isSelected) {
    this.isSelected = isSelected;
  }

  @override
  _SelectIconState createState() => state = _SelectIconState(isSelected);

  void updateUI(bool isSelected) {
    this.state.refreshUI(isSelected);
  }
}

class _SelectIconState extends State<SelectIcon> {
  bool isSelected;

  _SelectIconState(bool isSelected) {
    this.isSelected = isSelected;
  }

  void refreshUI(bool isSelected) {
    setState(() {
      this.isSelected = isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      size: 20,
    );
  }
}
