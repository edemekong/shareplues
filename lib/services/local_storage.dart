import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shareplues/models/user.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService(ref);
});

class LocalStorageService {
  final Ref reference;
  late SharedPreferences _sharedPreferences;

  LocalStorageService(this.reference) {
    _initialisePreference();
  }

  Future<SharedPreferences> _initialisePreference() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
  }

  Future<bool> storedData<T>(String key, T data) async {
    try {
      final value = await (() {
        if (data is String) {
          return _sharedPreferences.setString(key, data);
        } else if (data is int) {
          return _sharedPreferences.setInt(key, data);
        } else if (data is bool) {
          return _sharedPreferences.setBool(key, data);
        } else if (data is User) {
          final value = jsonEncode(data.toMap());
          return _sharedPreferences.setString(key, value);
        } else if (data is Map) {
          final value = jsonEncode(data);
          return _sharedPreferences.setString(key, value);
        } else if (data is List<String>) {
          return _sharedPreferences.setStringList(key, data);
        }
      })();
      return value ?? false;
    } catch (_) {}
    return false;
  }

  Future<T?> getLocalStoredData<T>(String key) async {
    try {
      final value = _sharedPreferences.get(key) as T;
      return value;
    } catch (_) {}
    return null;
  }

  Future<bool> deleteLocalStoredData(String key) async {
    try {
      final value = await _sharedPreferences.remove(key);
      return value;
    } catch (_) {}
    return false;
  }
}
