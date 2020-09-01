import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mengda/common/values/values.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mengda/im/pages/item/widget_util.dart';
import 'package:mengda/im/widget/cachImage/cached_image_widget.dart';

import '../../util/media_util.dart';
import '../../util/style.dart';
import 'package:rongcloud_im_plugin/rongcloud_im_plugin.dart';
import '../../util/user_info_datesource.dart' as example;
import 'dart:developer' as developer;

class BottomInputBar extends StatefulWidget {
  BottomInputBarDelegate delegate;
  _BottomInputBarState state;
  BottomInputBar(BottomInputBarDelegate delegate) {
    this.delegate = delegate;
  }
  @override
  _BottomInputBarState createState() =>
      state = _BottomInputBarState(this.delegate);

  void setTextContent(String textContent) {
    this.state.setText(textContent);
  }

  void refreshUI() {
    this.state._refreshUI();
  }

  void makeReferenceMessage(Message message) {
    this.state.makeReferenceMessage(message);
  }

  ReferenceMessage getReferenceMessage() {
    return this.state.referenceMessage;
  }

  void clearReferenceMessage() {
    this.state.clearReferenceMessage();
  }
}

class _BottomInputBarState extends State<BottomInputBar> {
  String pageName = "example.BottomInputBar";
  BottomInputBarDelegate delegate;
  TextField textField;
  FocusNode focusNode = FocusNode();
  InputBarStatus inputBarStatus;
  TextEditingController textEditingController;
  Message message;
  ReferenceMessage referenceMessage;
  example.UserInfo referenceUserInfo;
  bool _showSentBtn = false;
  bool _inputFocus = false;

  _BottomInputBarState(BottomInputBarDelegate delegate) {
    this.delegate = delegate;
    this.inputBarStatus = InputBarStatus.Normal;
    this.textEditingController = TextEditingController();

    this.textField = TextField(
      textInputAction: TextInputAction.send,
      controller: textEditingController,
      focusNode: focusNode,
      onSubmitted: _clickSendMessage,
      autofocus: _inputFocus,
      maxLines: 5,
      minLines: 1,
      onChanged: (value) {
        print(textEditingController.text);
        setState(() {
          _showSentBtn = value != '';
        });
      },
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        fillColor: Colors.transparent,
        filled: true,
        hintText: RCString.BottomInputTextHint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: InputBorder.none,
        // border: OutlineInputBorder(
        //   borderSide: BorderSide.none,
        //   borderRadius: Radii.k4pxRadius,
        // ),
      ),
    );
  }

  void setText(String textContent) {
    if (textContent == null) {
      textContent = '';
    }
    this.textEditingController.text =
        this.textEditingController.text + textContent;
    this.textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
    _refreshUI();
  }

  void _refreshUI() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      //获取输入的值
      delegate.onTextChange(textEditingController.text);
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _notifyInputStatusChanged(InputBarStatus.Normal);
      }
    });
  }

  void _clickSendMessage(String messageStr) {
    if (messageStr == null || messageStr.length <= 0) {
      developer.log("clickSendMessage MessageStr 不能为空", name: pageName);
      return;
    }

    if (this.delegate != null) {
      this.delegate.willSendText(messageStr);
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }
    this.textField.controller.text = '';
  }

  switchPhrases() {
    developer.log("switchPhrases", name: pageName);
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    InputBarStatus status = InputBarStatus.Normal;
    if (this.inputBarStatus != InputBarStatus.Phrases) {
      status = InputBarStatus.Phrases;
    }
    _notifyInputStatusChanged(status);
  }

  switchVoice() {
    developer.log("switchVoice", name: pageName);
    InputBarStatus status = InputBarStatus.Normal;
    if (this.inputBarStatus != InputBarStatus.Voice) {
      status = InputBarStatus.Voice;
    }
    _notifyInputStatusChanged(status);
  }

  switchEmoji() {
    developer.log("switchEmoji", name: pageName);
    InputBarStatus status = InputBarStatus.Normal;
    if (this.inputBarStatus != InputBarStatus.Emoji) {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
      status = InputBarStatus.Emoji;
    }
    _notifyInputStatusChanged(status);
  }

  switchExtention() {
    developer.log("switchExtention", name: pageName);
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    InputBarStatus status = InputBarStatus.Normal;
    if (this.inputBarStatus != InputBarStatus.Extention) {
      status = InputBarStatus.Extention;
    }
    if (this.delegate != null) {
      this.delegate.didTapExtentionButton();
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }
    _notifyInputStatusChanged(status);
  }

  _onVoiceGesLongPress() {
    developer.log("_onVoiceGesLongPress", name: pageName);
    MediaUtil.instance.startRecordAudio();
    if (this.delegate != null) {
      this.delegate.willStartRecordVoice();
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }
  }

  _onVoiceGesLongPressEnd() {
    developer.log("_onVoiceGesLongPressEnd", name: pageName);

    if (this.delegate != null) {
      this.delegate.willStopRecordVoice();
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }

    MediaUtil.instance.stopRecordAudio((String path, int duration) {
      if (this.delegate != null && path.length > 0) {
        this.delegate.willSendVoice(path, duration);
      } else {
        developer.log("没有实现 BottomInputBarDelegate || 录音路径为空", name: pageName);
      }
    });
  }

  Widget _getMainInputField() {
    Widget _inputBox = this.textField;
    Widget _voiceBox = Container(
      height: 40,
      alignment: Alignment.center,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Text(
          RCString.BottomTapSpeak,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.grey[700]),
        ),
        onLongPress: () {
          _onVoiceGesLongPress();
        },
        onLongPressEnd: (LongPressEndDetails details) {
          _onVoiceGesLongPressEnd();
        },
      ),
    );

    return Container(
      // height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        // border: new Border.all(color: Colors.black12, width: 0.5),
        borderRadius: Radii.k4pxRadius,
      ),
      child:
          this.inputBarStatus == InputBarStatus.Voice ? _voiceBox : _inputBox,
    );
  }

  void _notifyInputStatusChanged(InputBarStatus status) {
    this.inputBarStatus = status;
    if (this.delegate != null) {
      this.delegate.inputStatusDidChange(status);
    } else {
      developer.log("没有实现 BottomInputBarDelegate", name: pageName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppColors.appBarBgColor,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: this.inputBarStatus != InputBarStatus.Voice
                ? Icon(
                    Icons.mic,
                    color: AppColors.primaryDark.withOpacity(.8),
                  )
                : Icon(
                    Icons.keyboard,
                    color: AppColors.primaryDark.withOpacity(.8),
                  ),
            iconSize: 28,
            onPressed: () {
              switchVoice();
            },
          ),
          SizedBox(width: 2),
          Expanded(child: _getMainInputField()),
          SizedBox(width: 3),
          IconButton(
            icon: Icon(
              Icons.mood,
              color: AppColors.primaryDark.withOpacity(.8),
            ), // sentiment_ver
            iconSize: 28,
            onPressed: () {
              switchEmoji();
            },
          ),
          Container(
            child: !_showSentBtn
                ? IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primaryDark.withOpacity(.8),
                    ),
                    iconSize: 28,
                    onPressed: () {
                      switchExtention();
                    },
                  )
                : flatButton(
                    height: 38,
                    title: '发送',
                    width: 60,
                    fontSize: 14,
                    bgColor: Colors.green,
                    onPressed: () {
                      _clickSendMessage(textEditingController.text);
                      setState(() {
                        _inputFocus = false;
                      });
                    }),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceWidget() {
    return IntrinsicHeight(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        VerticalDivider(
          color: Colors.grey,
          thickness: 3,
        ),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 4, bottom: 2),
                  child: Text(
                      referenceUserInfo == null ? "" : referenceUserInfo.id,
                      style: TextStyle(
                          fontSize: RCFont.BottomReferenceNameSize,
                          color: Color(RCColor.BottomReferenceNameColor)))),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 60.0,
                ),
                child: new SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    child: GestureDetector(
                      child: _buildReferenceContent(),
                      onTap: () {
                        _clickContent();
                      },
                    )),
              )
            ])),
        Container(
            margin: EdgeInsets.only(right: 10),
            height: 30,
            width: 30,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                clearReferenceMessage();
              },
            ))
      ],
    ));
  }

  void _clickContent() {
    if (referenceMessage.referMsg is ImageMessage) {
      // 引用的消息为图片时的点击事件
      Message tempMsg = message;
      tempMsg.content = referenceMessage.referMsg;
      Navigator.pushNamed(context, "/image_preview", arguments: tempMsg);
    } else if (referenceMessage.referMsg is FileMessage) {
      // 引用的消息为文件时的点击事件
      Message tempMsg = message;
      tempMsg.content = referenceMessage.referMsg;
      Navigator.pushNamed(context, "/file_preview", arguments: tempMsg);
    } else if (referenceMessage.referMsg is RichContentMessage) {
      // 引用的消息为图文时的点击事件
      RichContentMessage richContentMessage = referenceMessage.referMsg;
      Map param = {
        "url": richContentMessage.url,
        "title": richContentMessage.title
      };
      Navigator.pushNamed(context, "/webview", arguments: param);
    } else {
      // 引用的消息为文本时的点击事件
    }
  }

  Widget _buildReferenceContent() {
    Widget widget = WidgetUtil.buildEmptyWidget();
    MessageContent messageContent = referenceMessage.referMsg;
    if (messageContent is TextMessage) {
      TextMessage textMessage = messageContent;
      widget = Text(textMessage.content,
          style: TextStyle(
              fontSize: RCFont.BottomReferenceContentSize,
              color: Color(RCColor.BottomReferenceContentColor)));
    } else if (messageContent is ImageMessage) {
      ImageMessage imageMessage = messageContent;
      Widget imageWidget;
      if (imageMessage.content != null && imageMessage.content.length > 0) {
        Uint8List bytes = base64.decode(imageMessage.content);
        imageWidget = Image.memory(bytes);
      } else {
        if (imageMessage.localPath != null) {
          String path =
              MediaUtil.instance.getCorrectedLocalPath(imageMessage.localPath);
          File file = File(path);
          if (file != null && file.existsSync()) {
            imageWidget = Image.file(file);
          } else {
            imageWidget = CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) =>
                  CircularProgressIndicator(
                value: progress.progress,
              ),
              imageUrl: imageMessage.imageUri,
            );
          }
        } else {
          imageWidget = CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) =>
                CircularProgressIndicator(
              value: progress.progress,
            ),
            imageUrl: imageMessage.imageUri,
          );
        }
      }
      widget = Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 150,
        ),
        child: imageWidget,
      );
    } else if (messageContent is FileMessage) {
      FileMessage fileMessage = messageContent;
      widget = Text("[文件] ${fileMessage.mName}",
          style: TextStyle(
              fontSize: RCFont.BottomReferenceContentSize,
              color: Color(RCColor.BottomReferenceContentColorFile)));
    } else if (messageContent is RichContentMessage) {
      RichContentMessage richContentMessage = messageContent;
      widget = Text("[图文] ${richContentMessage.title}",
          style: TextStyle(
              fontSize: RCFont.BottomReferenceContentSize,
              color: Color(RCColor.BottomReferenceContentColorFile)));
    } else if (messageContent is ReferenceMessage) {
      ReferenceMessage referenceMessage = messageContent;
      widget = Text(referenceMessage.content,
          style: TextStyle(
              fontSize: RCFont.BottomReferenceContentSize,
              color: Color(RCColor.BottomReferenceContentColorFile)));
    }
    return widget;
  }

  void setInfo(String userId) {
    example.UserInfo userInfo =
        example.UserInfoDataSource.cachedUserMap[userId];
    if (userInfo != null) {
      this.referenceUserInfo = userInfo;
    } else {
      example.UserInfoDataSource.getUserInfo(userId).then((onValue) {
        setState(() {
          this.referenceUserInfo = onValue;
        });
      });
    }
  }

  void makeReferenceMessage(Message message) {
    if (message != null) {
      this.message = message;
      referenceMessage = ReferenceMessage();
      referenceMessage.referMsgUserId = message.senderUserId;
      if (message.content is ReferenceMessage) {
        ReferenceMessage content = message.content;
        TextMessage textMessage = TextMessage.obtain(content.content);
        referenceMessage.referMsg = textMessage;
      } else {
        referenceMessage.referMsg = message.content;
      }
      setInfo(referenceMessage.referMsgUserId);
    } else {
      referenceMessage = null;
    }
    _refreshUI();
  }

  ReferenceMessage getReferenceMessage() {
    return referenceMessage;
  }

  void clearReferenceMessage() {
    referenceMessage = null;
    message = null;
    _refreshUI();
  }
}

enum InputBarStatus {
  Normal, //正常
  Voice, //语音输入
  Extention, //扩展栏
  Phrases, //快捷回复
  Emoji, // emoji输入
}

abstract class BottomInputBarDelegate {
  ///输入工具栏状态发生变更
  void inputStatusDidChange(InputBarStatus status);

  ///即将发送消息
  void willSendText(String text);

  ///即将发送语音
  void willSendVoice(String path, int duration);

  ///即将开始录音
  void willStartRecordVoice();

  ///即将停止录音
  void willStopRecordVoice();

  ///点击了加号按钮
  void didTapExtentionButton();

  ///输入框内容变化监听
  void onTextChange(String text);
}
