import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../gen/translations/locale_keys.g.dart';
import '../constants/constants.dart';

enum SnackBarStatus { error, success }

void showSnackBar(BuildContext context, String message, SnackBarStatus status) {
  Color backgroundColor =
      status == SnackBarStatus.success ? Colors.green : Colors.red;

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ),
  );
}

void showGlobalSnackBar(String message, SnackBarStatus status) {
  Color backgroundColor =
      status == SnackBarStatus.success ? Colors.green : Colors.red;
  scaffoldMessengerKey.currentState?.clearSnackBars();
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      content: Text(message.tr()),
      backgroundColor: backgroundColor,
    ),
  );
}

void showGeneralSnackBarError() {
  showGlobalSnackBar(LocaleKeys.app_apiError_server.tr(), SnackBarStatus.error);
}
