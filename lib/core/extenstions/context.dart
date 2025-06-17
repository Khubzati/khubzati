import 'package:flutter/material.dart';

extension AppBarHeightExtension on BuildContext {
  double get appBarHeight {
    final scaffoldState = Scaffold.maybeOf(this);
    return scaffoldState?.appBarMaxHeight ?? 0.0;
  }
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}
