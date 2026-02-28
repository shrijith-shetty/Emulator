import "package:flutter_secure_storage/flutter_secure_storage.dart";

class Ispasswordrequeired
{
    final FlutterSecureStorage _storage = const FlutterSecureStorage();
    final String _key = "app_password";
    final bool _isPasswordRequired = true;

    Future<void> setIsPasswordRequired(bool password) async
    {
        await _storage.write(
            key: _key,
            value: password.toString(),
        );
    }
    Future<bool> isPasswordRequired() async
    {
        return await _storage.containsKey(key: _key);
    }

    Future<bool> verifyIsPasswordRequired(String enteredPassword) async
    {
        String? storedPassword = await _storage.read(key: _key);

        if (storedPassword == null || storedPassword== "false")
        {
            return false;
        }
        return "true" == storedPassword;
    }

    Future<void> deleteIsPasswordRequired() async
    {
        await _storage.delete(key: _key);
    }
}