import 'package:flutter/cupertino.dart';
import 'package:secondhand_sharing/generated/l10n.dart';

class TimeRemainder {
  static String parse(DateTime dateTime, BuildContext context) {
    DateTime now = DateTime.now();
    if (dateTime.compareTo(now) <= 0) return null;
    var duration = dateTime.difference(now);
    if (duration.inDays ~/ 365.25 > 0) {
      return "${duration.inDays ~/ 365.25} ${S.of(context).year}";
    }
    if (duration.inDays ~/ 30 > 0) {
      return "${duration.inDays ~/ 30} ${S.of(context).month}";
    }
    if (duration.inDays ~/ 7 > 0) {
      return "${duration.inDays ~/ 7} ${S.of(context).week}";
    }
    if (duration.inDays > 0) {
      return "${duration.inDays} ${S.of(context).day}";
    }
    if (duration.inHours > 0) {
      return "${duration.inHours} ${S.of(context).hour}";
    }
    if (duration.inMinutes > 0) {
      return "${duration.inMinutes} ${S.of(context).minute}";
    }
    if (duration.inSeconds > 0) {
      return "${duration.inSeconds} ${S.of(context).second}";
    }
  }
}
