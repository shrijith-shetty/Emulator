import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoreCurrentWallPaper
{
    final FlutterSecureStorage _storage = const FlutterSecureStorage();
    final String _key = 'app_password';

    Future<void> setWallpaper(String path) async
    {
        await _storage.write(
            key: _key,
            value: path
        );
    }

    Future<bool> isWallpaperset() async
    {
        return await _storage.containsKey(key: _key);
    }

    Future<bool> verifyWallpaper(String path)
    async
    {
        String? storedPath = await _storage.read(key: _key);
        if (storedPath == null)
        {
            return false;
        }
        return storedPath == path;
    }

    Future<void> deletePath() async
    {
        await _storage.delete(key: _key);
    }
}