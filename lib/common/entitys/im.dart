// 用户
class People {
  People({
    this.userName,
    this.nickName,
    this.avatar,
  });

  String userName;
  String nickName;
  String avatar;

  factory People.fromJson(Map<String, dynamic> json) => People(
        userName: json["UserName"],
        nickName: json["NickName"],
        avatar: json["Avatar"],
      );

  Map<String, dynamic> toJson() => {
        "UserName": userName,
        "NickName": nickName,
        "Avatar": avatar,
      };
}

// 群组
class GroupEntity {
  GroupEntity({
    this.groupId,
    this.groupName,
    this.members,
  });

  String groupId;
  String groupName;
  List<People> members;

  factory GroupEntity.fromJson(Map<String, dynamic> json) => GroupEntity(
        groupId: json["GroupId"],
        groupName: json["GroupName"],
        members:
            List<People>.from(json["Members"].map((x) => People.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "GroupId": groupId,
        "GroupName": groupName,
        "Members": members,
      };
}
