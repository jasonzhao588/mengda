import 'package:mengda/common/apis/im.dart';
import 'package:mengda/common/entitys/im.dart';
import 'package:mengda/global.dart';
import 'package:flutter/material.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';

import 'widget_util.dart';

import '../../util/style.dart';
import '../../util/time.dart';
import '../../util/user_info_datesource.dart' as example;
import 'dart:developer' as developer;

class ConversationListItem extends StatefulWidget {
  final Conversation conversation;
  final ConversationListItemDelegate delegate;
  final People friend;
  const ConversationListItem({
    Key key,
    this.delegate,
    this.conversation,
    this.friend,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ConversationListItemState(this.delegate, this.conversation);
  }
}

class _ConversationListItemState extends State<ConversationListItem> {
  String pageName = "example.ConversationListItem";
  Conversation conversation;
  ConversationListItemDelegate delegate;
  example.BaseInfo info;
  Offset tapPos;
  People _friendInfo;
  GroupEntity _groupInfo;
  bool _isGroup;
  String _avatarUrl;
  String _itemTitle;

  @override
  void initState() {
    super.initState();
    setItemInfo();
  }

  _ConversationListItemState(
    ConversationListItemDelegate delegate,
    Conversation con,
  ) {
    this.delegate = delegate;
    this.conversation = con;
    // setInfo();
  }

  void _onTaped() {
    if (this.delegate != null) {
      this.delegate.didTapConversation(this.conversation);
    } else {
      developer.log("没有实现 ConversationListItemDelegate", name: pageName);
    }
  }

  void _onLongPressed() {
    if (this.delegate != null) {
      this.delegate.didLongPressConversation(this.conversation, this.tapPos);
    } else {
      developer.log("没有实现 ConversationListItemDelegate", name: pageName);
    }
  }

  Widget _buildPortrait() {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 16,
            ),
            WidgetUtil.buildUserPortrait(_avatarUrl == null ? '' : _avatarUrl),
          ],
        ),
        Positioned(
          right: -3.0,
          top: -3.0,
          child: _buildUnreadCount(conversation.unreadMessageCount),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Container(
        height: RCLayout.ConListItemHeight,
        margin: EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Color(RCColor.ConListBorderColor),
            ),
          ),
        ),
        child: Row(
          children: <Widget>[_buildTitle()],
        ),
      ),
    );
  }

  Widget _buildTime() {
    String time = TimeUtil.convertTime(conversation.sentTime);

    return Container(
      margin: EdgeInsets.only(left: 8, right: 16),
      child: Text(
        time,
        style: TextStyle(
          fontSize: RCFont.ConListTimeFont,
          color: Color(RCColor.ConListTimeColor),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    //是否群聊
    _isGroup = conversation.conversationType != RCConversationType.Private;

    String title =
        (_isGroup ? '[群聊]' : '') + (_itemTitle == null ? '' : _itemTitle);
    // (this.info == null || this.info.id == null ? "" : this.info.id);

    String digest = "";
    if (conversation.latestMessageContent != null) {
      if (conversation.latestMessageContent.destructDuration != null &&
          conversation.latestMessageContent.destructDuration > 0) {
        digest = "[阅后即焚]";
      } else {
        digest = conversation.latestMessageContent.conversationDigest();
      }
    } else {
      digest = "无法识别消息 " + conversation.objectName;
    }
    if (digest == null) {
      digest = "";
    }
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: RCFont.ConListTitleFont,
                      color: Color(RCColor.ConListTitleColor),
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildTime()
            ],
          ),
          SizedBox(
            height: 6,
          ),
          _buildDigest(digest)
        ],
      ),
    );
  }

  Widget _buildDigest(String digest) {
    bool showError = false;
    if (conversation.mentionedCount > 0) {
      digest = RCString.ConHaveMentioned + digest;
    } else if (conversation.draft != null && conversation.draft.isNotEmpty) {
      digest = RCString.ConDraft + conversation.draft;
    } else if (conversation.sentStatus == RCSentStatus.Failed) {
      showError = true;
    }
    double screenWidth = MediaQuery.of(context).size.width;
    if (showError) {
      return Row(children: <Widget>[
        // conversation.sentStatus == RCSentStatus.Failed ?
        Icon(
          Icons.error,
          size: 15,
          color: Colors.red,
        ),
        Container(
          width: screenWidth - 170,
          child: Text(
            digest,
            style: TextStyle(
                fontSize: RCFont.ConListDigestFont,
                color: Color(RCColor.ConListDigestColor)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ]);
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Text(
          digest,
          style: TextStyle(
            fontSize: RCFont.ConListDigestFont,
            color: Color(RCColor.ConListDigestColor),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

  Widget _buildUnreadCount(int count) {
    if (count <= 0 || count == null) {
      return WidgetUtil.buildEmptyWidget();
    }
    double width = count > 100 ? 25 : RCLayout.ConListUnreadSize;
    return Container(
        width: width,
        height: RCLayout.ConListUnreadSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width / 2.0),
            color: Color(RCColor.ConListUnreadColor)),
        child: Text(count.toString(),
            style: TextStyle(
                fontSize: RCFont.ConListUnreadFont,
                color: Color(RCColor.ConListUnreadTextColor))));
  }

  void setItemInfo() async {
    String targetId = conversation.targetId;

    if (conversation.conversationType == RCConversationType.Private) {
      _friendInfo = await ImAPI.getFriend(userName: targetId);

      if (_friendInfo != null) {
        setState(() {
          _itemTitle = _friendInfo?.nickName;
          _avatarUrl = _friendInfo?.avatar;
        });
      }
    } else {
      _groupInfo = await ImAPI.getGroup(id: targetId);
      if (_groupInfo != null) {
        print(_groupInfo.groupName);
        setState(() {
          _itemTitle = _groupInfo.groupName == null ? '' : _groupInfo.groupName;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Color(RCColor.ConListItemBgColor),
      child: InkWell(
        onTapDown: (TapDownDetails details) {
          tapPos = details.globalPosition;
        },
        onTap: () {
          _onTaped();
        },
        onLongPress: () {
          _onLongPressed();
        },
        child: Container(
          height: RCLayout.ConListItemHeight,
          color: conversation.isTop
              ? Color(RCColor.ConListTopBgColor)
              : Color(RCColor.ConListItemBgColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[_buildPortrait(), _buildContent()],
          ),
        ),
      ),
    );
  }
}

abstract class ConversationListItemDelegate {
  ///点击了会话 item
  void didTapConversation(Conversation conversation);

  ///长按了会话 item
  void didLongPressConversation(Conversation conversation, Offset tapPos);
}
