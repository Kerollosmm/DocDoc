import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:csms/core/config/hive_boxes_config.dart';
import 'package:csms/features/auth/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

@LazySingleton(as: AuthLocalDataSource)
class HiveAuthDataSource implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  HiveAuthDataSource(this._secureStorage);

  Box? _box;

  Future<Box> get box async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox(HiveBoxesConfig.authBox);
    return _box!;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final b = await box;
    await b.put('user', jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getUser() async {
    final b = await box;
    final jsonString = b.get('user');
    if (jsonString != null) {
      return UserModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    final b = await box;
    await b.delete('user');
  }

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  @override
  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}
