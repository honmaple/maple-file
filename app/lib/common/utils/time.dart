import 'package:intl/intl.dart' as intl;

import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart'
    as pb;

class TimeUtil {
  static String formatDate(DateTime d, String format) {
    return intl.DateFormat(format).format(d);
  }

  static String dateToString(DateTime d) {
    return intl.DateFormat('yyyy-MM-dd').format(d);
  }

  static String timeToString(DateTime d) {
    return intl.DateFormat('HH:mm:ss').format(d);
  }

  static String datetimeToString(DateTime d) {
    return intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(d);
  }

  static DateTime pbToTime(pb.Timestamp t) {
    return DateTime.fromMillisecondsSinceEpoch(t.seconds.toInt() * 1000);
  }

  static String pbToString(pb.Timestamp t, String format) {
    return formatDate(pbToTime(t), format);
  }

  static String timesince(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    // if (diff.inDays >= 7) {
    // return intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(d);
    // }
    // if (diff.inDays > 0) {
    //   return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    // }
    // if (diff.inHours > 0) {
    //   return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    // }
    if (diff.inHours > 0) {
      return intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(d);
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    if (diff.inSeconds > 10) {
      return "${diff.inSeconds} ${diff.inSeconds == 1 ? "second" : "seconds"} ago";
    }
    return "刚刚";
  }
}
