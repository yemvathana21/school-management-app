import 'dart:convert';
import 'package:hive/hive.dart';

class LocalCacheService {
  static const String _boxName = 'app_cache';

  static Future<Box> get _box async => await Hive.openBox(_boxName);

  static Future<void> cacheData(String key, dynamic data) async {
    final box = await _box;
    await box.put(key, jsonEncode(data));
  }

  static Future<dynamic> getData(String key) async {
    final box = await _box;
    final raw = box.get(key);
    if (raw == null) return null;
    return jsonDecode(raw as String);
  }

  static Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }

  static Future<void> remove(String key) async {
    final box = await _box;
    await box.delete(key);
  }

  static const String schedulesKey = 'schedules';
  static const String announcementsKey = 'announcements';
  static const String gradesKey = 'grades';
  static const String classesKey = 'classes';
  static const String assignmentsKey = 'assignments';
  static const String attendancesKey = 'attendances';
}
