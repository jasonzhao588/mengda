class ResponseInfo {
  ResponseInfo({
    this.code,
    this.data,
    this.msg,
  });

  int code;
  dynamic data;
  String msg;

  factory ResponseInfo.fromJson(Map<String, dynamic> json) => ResponseInfo(
        code: json["code"],
        data: json["data"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data,
        "msg": msg,
      };
}
