import 'package:barcode_scan/barcode_scan.dart';
import 'package:mengda/common/entitys/common.dart';
import 'package:mengda/common/apis/im.dart';
import 'package:mengda/common/widgets/widgets.dart';
import 'package:mengda/global.dart';
import 'package:mengda/common/apis/apis.dart';
import 'package:mengda/common/entitys/entitys.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  static Controller get to => Get.find();

  UserInfoEntity userInfo;
  List<People> friendList;
  ResponseInfo qrcode;
  var count = 0.obs;
  // List<String> _selectedList = List<String>();

  ///我的
  void getUserInfo() async {
    userInfo = await UserAPI.getUserInfo(token: Global.profile?.accessToken);
    update();
  }

  void getQrcode() async {
    qrcode = await UserAPI.getQrCode();
    update();
  }

  ///IM
  void getContacts() async {
    friendList = await ImAPI.getFriendList(token: Global.profile?.accessToken);
    update();
  }

  void scanCode() async {
    ScanOptions options = ScanOptions(
      strings: {
        'cancel': '取消',
        "flash_on": '闪光灯开',
        "flash_off": '闪光灯关',
      },
      android: AndroidOptions(useAutoFocus: true, aspectTolerance: 1),
    );
    ScanResult barcode = await BarcodeScanner.scan(options: options);

    ResponseInfo friendInfo = await ImAPI.addFriend(
      token: Global.profile.accessToken,
      userName: barcode.rawContent,
    );
    if (friendInfo.code == 0) {
      msg(msg: '添加成功');
    } else {
      msg(msg: friendInfo.msg);
    }
  }

  Future<bool> createGroup(groupName, userIds) async {
    ResponseInfo result = await ImAPI.createGroup(
      groupName: groupName,
      userIds: userIds,
    );
    return result.code == 0;
  }

  void changeSelected() {
    update();
  }
}
