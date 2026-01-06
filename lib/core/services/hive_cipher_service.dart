import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class HiveCipherService {
  final FlutterSecureStorage _secureStorage;

  HiveCipherService(this._secureStorage);

  Future<HiveCipher?> getEncryptionCipher() async {
    try {
      const keyName = 'hive_encryption_key';
      String? keyString = await _secureStorage.read(key: keyName);

      if (keyString == null) {
        final key = Hive.generateSecureKey();
        keyString = base64UrlEncode(key);
        await _secureStorage.write(key: keyName, value: keyString);
      }

      final key = base64Url.decode(keyString);
      return HiveAesCipher(key);
    } catch (e) {
      // Fallback or rethrow depending on strictness
      // If secure storage fails, we might not be able to open encrypted boxes.
      return null;
    }
  }
}
