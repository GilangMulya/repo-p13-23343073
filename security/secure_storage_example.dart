import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Contoh implementasi penyimpanan data sensitif (seperti token sesi) 
/// menggunakan Android Keystore / iOS Keychain.
class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveSensitiveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readSensitiveData(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }
}
