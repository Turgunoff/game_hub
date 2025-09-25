import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCachedUser();
  Future<bool> isLoggedIn();
  Future<void> setLoggedIn(bool value);
}

@Singleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String cachedUserKey = 'CACHED_USER';
  static const String isLoggedInKey = 'IS_LOGGED_IN';

  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = _sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await _sharedPreferences.setString(
      cachedUserKey,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> clearCachedUser() async {
    await _sharedPreferences.remove(cachedUserKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    return _sharedPreferences.getBool(isLoggedInKey) ?? false;
  }

  @override
  Future<void> setLoggedIn(bool value) async {
    await _sharedPreferences.setBool(isLoggedInKey, value);
  }
}