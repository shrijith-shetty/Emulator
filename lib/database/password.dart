import "package:flutter_secure_storage/flutter_secure_storage.dart";

class PasswordStorage
{
    final FlutterSecureStorage _storage = const FlutterSecureStorage();
    final String _key = "app_password";

    /// Save Password
    Future<void> setPassword(String password) async
    {
        await _storage.write(
            key: _key,
            value: password
        );
    }

    /// Check if password exists
    Future<bool> isPasswordSet() async
    {
        return await _storage.containsKey(key: _key);
    }

    /// Verify entered password
    Future<bool> verifyPassword(String enteredPassword) async
    {
        String? storedPassword = await _storage.read(key: _key);

        if (storedPassword == null) 
        {
            return false;
        }

        return enteredPassword == storedPassword;
    }

    /// Delete password (when switch disabled)
    Future<void> deletePassword() async
    {
        await _storage.delete(key: _key);
    }
}