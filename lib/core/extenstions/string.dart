import 'package:easy_localization/easy_localization.dart';

import '../utils/app_date.dart';
import 'date_time.dart';

extension StringExtensions on String {
  String toCapitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  DateTime toDate(String newFormat) {
    return DateFormat(newFormat).parse(this);
  }

  String toHHMMAFormat(String oldFormat) {
    DateTime date = toDate(oldFormat);
    return DateFormat(AppDate.hhmma).format(date); // [E.g. 09:00 PM]
  }

  String add(String oldFormat, Duration duration) {
    final newDate = toDate(oldFormat).add(duration);
    return newDate.toStr(oldFormat);
  }

  String formatDate(String oldFormat, String newFormat) {
    DateTime date = toDate(oldFormat);
    return date.toStr(newFormat);
  }
}
