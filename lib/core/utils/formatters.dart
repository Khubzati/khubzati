import 'package:easy_localization/easy_localization.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

class AppFormatters {
  static String formatCurrencyJOD(num? value, {String? locale}) {
    final number = (value ?? 0).toDouble();
    final nf = NumberFormat.currency(
      locale: locale,
      symbol: tr(LocaleKeys.app_order_sheet_currency_jod),
      decimalDigits: 2,
    );
    return nf.format(number);
  }

  static String formatDate(String? isoOrAppDate) {
    if (isoOrAppDate == null || isoOrAppDate.isEmpty) return '-';
    // Try common formats; fallback to raw string
    try {
      DateTime dt;
      if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(isoOrAppDate)) {
        dt = DateTime.parse(isoOrAppDate);
      } else {
        // Expect dd/MM/yyyy
        dt = DateFormat('dd/MM/yyyy').parse(isoOrAppDate);
      }
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return isoOrAppDate;
    }
  }
}
