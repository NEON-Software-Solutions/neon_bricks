import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalCacheDataSource {
  static const _kCacheName = 'cachedStrings';
  static const _myInfoKey = 'foo-bar';
  Box? hive;

  Future<void> initializeDatabase() async {
    hive ??= await Hive.openBox(_kCacheName);
  }

  Future<void> openHive() async {
    if (hive != null && !hive!.isOpen) {
      hive = await Hive.openBox(_kCacheName);
    }
  }

  Future<void> closeHive() async {
    if (hive != null && hive!.isOpen) {
      Hive.close();
    }
  }

  Future<String?> getCachedString(String key) async {
    try {
      await initializeDatabase();
      dynamic jsonString = hive!.get(key);
      return jsonString;
    } catch (e) {
      return null;
    }
  }

  Future<bool> hasRecordForKey(String key) async {
    await initializeDatabase();
    return hive!.containsKey(key);
  }

  Future<void> setCachedString(String key, String jsonString) async {
    await initializeDatabase();
    return hive!.put(key, jsonString);
  }

  Future<void> removeCachedEntry(String key) async {
    await initializeDatabase();
    return hive!.delete(key);
  }

  //TODO: set this up
  Future<String?> getMyInfo() async {
    return await getCachedString(_myInfoKey);
  }

  Future<void> setMyInfo(String newInfo) async {
    await setCachedString(_myInfoKey, newInfo);
  }

  Future<void> deleteMyInfo() async {
    await removeCachedEntry(_myInfoKey);
  }
}
