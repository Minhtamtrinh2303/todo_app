import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String accessTokenKey = 'accessToken';
  static const String avatarKey = 'avatarPath';

  static late SharedPreferences _prefs;

  static Future<dynamic> initialise() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? get token {
    return _prefs.getString(accessTokenKey);
  }

  static set token(String? token) =>
      _prefs.setString(accessTokenKey, token ?? '');

  bool get isLogin => _prefs.getString(accessTokenKey)?.isNotEmpty ?? false;

  static String? get avatar => _prefs.getString(avatarKey);

  static set avatar(String? avatar) =>
      _prefs.setString(avatarKey, avatar ?? '');

  static removeSeason() {
    _prefs.remove(accessTokenKey);
  }
}
