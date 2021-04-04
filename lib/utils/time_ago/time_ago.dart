import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class TimeAgo {
  static String parse(DateTime dateTime, {String locale = "en"}) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(dateTime);
    print(locale);
    if (locale == "vi") {
      int year = diff.inDays ~/ 365.25;
      if (year > 0) {
        return "$year năm trước";
      } else {
        int month = diff.inDays ~/ 30;
        if (month > 0)
          return "$month tháng trước";
        else {
          if (diff.inDays > 0) {
            return "${diff.inDays} ngày trước";
          } else {
            if (diff.inHours > 0) {
              return "${diff.inHours} giờ trước";
            } else {
              if (diff.inMinutes > 0) {
                return "${diff.inMinutes} phút trước";
              } else {
                if (diff.inSeconds > 0) {
                  return "${diff.inSeconds} giây trước";
                }
              }
            }
          }
        }
      }
    }
    return timeAgo.format(now.subtract(diff), locale: locale);
  }
}
