import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:khubzati/core/services/app_preferences.dart';
import 'package:khubzati/core/services/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final AppPreferences appPreferences;
  final LocalizationService localizationService;
  static const String _notificationsKey = 'notifications_enabled';

  SettingsCubit({
    required this.appPreferences,
    required this.localizationService,
  }) : super(const SettingsInitial());

  Future<void> loadSettings() async {
    emit(const SettingsLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final isNotificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      final currentLanguage = appPreferences.isAr ? 'ar' : 'en';

      emit(SettingsLoaded(
        isNotificationsEnabled: isNotificationsEnabled,
        currentLanguage: currentLanguage,
      ));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> toggleNotifications(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsKey, value);

      if (state is SettingsLoaded) {
        emit((state as SettingsLoaded).copyWith(isNotificationsEnabled: value));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> changeLanguage(String languageCode, BuildContext context) async {
    try {
      localizationService.setLocale(context, languageCode);
      appPreferences.storeLang(languageCode);

      if (state is SettingsLoaded) {
        emit((state as SettingsLoaded).copyWith(currentLanguage: languageCode));
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
