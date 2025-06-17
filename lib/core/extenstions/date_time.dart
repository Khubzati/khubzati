import 'package:intl/intl.dart';

import '../utils/app_date.dart';
import 'string.dart';

extension DateTimeExtensions on DateTime {
  String toStr(String newFormat) {
    return DateFormat(newFormat).format(this);
  }

  int diffInYears(DateTime date) {
    return year - date.year;
  }

  DateTime toDateOnly() {
    final String stringDateOnly = DateFormat(AppDate.yyyyMMdd).format(this);
    return stringDateOnly.toDate(AppDate.yyyyMMdd);
  }
}
