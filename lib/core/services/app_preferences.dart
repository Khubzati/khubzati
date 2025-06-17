import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'localization_service.dart';

enum PreferencesKey {
  lang,
  token,
  tempToken,
  email,
  password,
  role,
  userId,
  userInfo,
  adminConfig,
  lookUpData
}

@lazySingleton
class AppPreferences {
  final StreamingSharedPreferences preferences;
  AppPreferences(this.preferences);

  // UserInfoResponse getUserCachedResponse() {
  //   final userResponseString = preferences
  //       .getString(PreferencesKey.userInfo.name, defaultValue: '')
  //       .getValue();
  //   return UserInfoResponse.fromJson(jsonDecode(userResponseString));
  // }

  void storeLang(String value) =>
      preferences.setString(PreferencesKey.lang.name, value);

  String get getLang => preferences
      .getString(PreferencesKey.lang.name, defaultValue: 'en')
      .getValue();

  void deleteLang() => preferences.remove(PreferencesKey.lang.name);

  bool get isAr =>
      preferences
          .getString(PreferencesKey.lang.name,
              defaultValue: SupportedL10N.ar.name)
          .getValue() ==
      SupportedL10N.ar.name;

  void setAccessToken(String? value) {
    preferences.setString(PreferencesKey.token.name, value ?? '');
  }

  String get accessToken => preferences
      .getString(PreferencesKey.token.name, defaultValue: '')
      .getValue();

  void deleteAccessToken() {
    preferences.remove(PreferencesKey.token.name);
  }

  void setTempAccessToken(String? value) {
    preferences.setString(PreferencesKey.tempToken.name, value ?? '');
  }

  String get tempAccessToken => preferences
      .getString(PreferencesKey.tempToken.name, defaultValue: '')
      .getValue();

  void deleteTempAccessToken() {
    preferences.remove(PreferencesKey.tempToken.name);
  }

  bool isLoggedIn() {
    final accessToken = preferences
        .getString(PreferencesKey.token.name, defaultValue: '')
        .getValue();

    return accessToken.isNotEmpty && !JwtDecoder.isExpired(accessToken);
  }

  void setUserCredential(String email, String password) {
    preferences.setString(PreferencesKey.email.name, email);
    preferences.setString(PreferencesKey.password.name, password);
  }

  Map<String, String> get userCredential => {
        PreferencesKey.email.name: preferences
            .getString(PreferencesKey.email.name, defaultValue: '')
            .getValue(),
        PreferencesKey.password.name: preferences
            .getString(PreferencesKey.password.name, defaultValue: '')
            .getValue(),
      };

  // User token methods
  Future<String?> getUserToken() async {
    return preferences
        .getString(PreferencesKey.token.name, defaultValue: '')
        .getValue();
  }

  Future<void> setUserToken(String token) async {
    await preferences.setString(PreferencesKey.token.name, token);
  }

  // User ID methods
  Future<String?> getUserId() async {
    return preferences
        .getString(PreferencesKey.userId.name, defaultValue: '')
        .getValue();
  }

  Future<void> setUserId(String userId) async {
    await preferences.setString(PreferencesKey.userId.name, userId);
  }

  // User role methods
  Future<String?> getUserRole() async {
    return preferences
        .getString(PreferencesKey.role.name, defaultValue: '')
        .getValue();
  }

  Future<void> setUserRole(String role) async {
    await preferences.setString(PreferencesKey.role.name, role);
  }

  // Clear session
  Future<void> clearUserSession() async {
    await preferences.remove(PreferencesKey.token.name);
    await preferences.remove(PreferencesKey.userId.name);
    await preferences.remove(PreferencesKey.role.name);
    await preferences.remove(PreferencesKey.email.name);
    await preferences.remove(PreferencesKey.password.name);
  }
}
