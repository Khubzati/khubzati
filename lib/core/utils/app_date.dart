import '../extenstions/string.dart';

abstract class AppDate {
  static const ddMMyyyy = 'dd/MM/yyyy'; // FrontEnd
  static const yyyyMMdd = 'yyyy-MM-dd'; // Backend
  static const MMddyyyy = 'MM/dd/yyyy'; // Facebook
  static const MMMMddyyyy = "MMMM dd, yyyy";

  static const HHmmss = 'HH:mm:ss'; // Backend
  static const HHmm = 'HH:mm'; // FrontEnd
  static const hhmma = 'hh:mm a';

  // BE/be => Backend
  static String appToBEDate(String date) {
    return date.formatDate(AppDate.ddMMyyyy, AppDate.yyyyMMdd);
  }

  static String beToAppDate(String date) {
    return date.formatDate(AppDate.yyyyMMdd, AppDate.ddMMyyyy);
  }

  static String beToAppTime(String date) {
    return date.toHHMMAFormat(AppDate.HHmmss);
  }

  static String getSessionEndTime(String sessionTimeInhhmmaFormat) {
    return sessionTimeInhhmmaFormat.add(
      AppDate.hhmma,
      const Duration(hours: 1),
    );
  }
}
