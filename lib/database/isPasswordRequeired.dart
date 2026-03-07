import "package:flutter_secure_storage/flutter_secure_storage.dart";

class IsPasswordRequired {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _key = "is_password_required";

  Future<void> setIsPasswordRequired(bool value) async {
    await _storage.write(
      key: _key,
      value: value.toString(),
    );
  }

  Future<bool> isPasswordRequired() async {
    String? value = await _storage.read(key: _key);
    if (value == null) return false;
    return value == "true";
  }

  Future<void> deleteIsPasswordRequired() async {
    await _storage.delete(key: _key);
  }
}