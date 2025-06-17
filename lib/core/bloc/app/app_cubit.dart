import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../services/app_preferences.dart';
import '../../services/localization_service.dart';
import '../../utils/utils.dart';

part 'app_cubit.freezed.dart';
part 'app_state.dart';

@lazySingleton
class AppCubit extends Cubit<AppState> {
  final LocalizationService localizationService;
  final AppPreferences appPreferences;
  AppCubit(this.localizationService, this.appPreferences)
      : super(const AppState());

  final scrollController = ScrollController(keepScrollOffset: false);

  Future<void> storeLang(BuildContext context, String langCode,
      [bool resetRouterStack = true]) async {
    localizationService.setLocale(context, langCode);
    appPreferences.storeLang(langCode);
    // BlocProvider.of<LookupCubit>(context).getLookUpsData();
    if (resetRouterStack) {
      navigateToHomePage(context);
    }
  }

  void scrollTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(0);
    });
  }
}
