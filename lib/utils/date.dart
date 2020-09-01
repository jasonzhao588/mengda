import 'package:intl/intl.dart';

/// 格式化时间
String duTimeLineFormat(DateTime dt) {
  var now = DateTime.now();
  var difference = now.difference(dt);

  // 1分钟内
  if (difference.inSeconds < 60) {
    return "刚刚";
  }

  // 1小时内
  if (difference.inMinutes < 60) {
    return "${difference.inMinutes} 分钟前";
  }

  // 1天内
  if (difference.inHours < 24) {
    return "${difference.inHours} 小时前";
  }
  // 30天内
  else if (difference.inDays < 30) {
    return "${difference.inDays} 天前";
  }
  // MM-dd
  else if (difference.inDays < 365) {
    final dtFormat = new DateFormat('MM-dd');
    return dtFormat.format(dt);
  }
  // yyyy-MM-dd
  else {
    final dtFormat = new DateFormat('yyyy-MM-dd');
    var str = dtFormat.format(dt);
    return str;
  }
}

String formatDate(dt) {
  final dtFormat = new DateFormat('yyyy-MM-dd ');
  if (dt is String) {
    return dtFormat.format(DateTime.parse(dt));
  }
  var str = dtFormat.format(dt);
  return str;
}

String formatDateTime(dt) {
  final dtDate = new DateFormat('yyyy-MM-dd ');
  final dtTime = new DateFormat.Hms();
  return '${dtDate.format(DateTime.parse(dt))}${dtTime.format(DateTime.parse(dt))}';
}

String addZero(dt) {
  if (dt < 10) {
    return '0$dt';
  } else {
    return '$dt';
  }
}

String tranFormatTime(int timestamp) {
  if (timestamp == 0 || timestamp == null) {
    return "";
  }
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  String formatTime =
      '${date.year}-${addZero(date.month)}-${addZero(date.day)} ${addZero(date.hour)}:${addZero(date.minute)}';
  return formatTime;
}

String tranImTime(String time) {
  String duration;
  int minute = 60;
  int hour = minute * 60;
  int day = hour * 24;
  int week = day * 7;
  int month = day * 30;

  var nowTime = DateTime.now().millisecondsSinceEpoch / 1000; //到秒
  var createTime = DateTime.parse(time).millisecondsSinceEpoch / 1000; //到秒
  var leftTime = nowTime - createTime;

  if (leftTime / month > 6) {
    duration = time;
  } else if (leftTime / month >= 1) {
    duration = (leftTime / month).floor().toString() + '月前';
  } else if (leftTime / week >= 1) {
    duration = (leftTime / week).floor().toString() + '周前';
  } else if (leftTime / day >= 1) {
    duration = (leftTime / day).floor().toString() + '天前';
  } else if (leftTime / hour >= 1) {
    duration = (leftTime / hour).floor().toString() + '小时前';
  } else if (leftTime / minute >= 1) {
    duration = (leftTime / minute).floor().toString() + '分钟前';
  } else {
    duration = '刚刚';
  }
  return duration;
}
