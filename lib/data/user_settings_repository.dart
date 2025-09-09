import 'dart:convert';

import 'package:favorite_sports/model/sports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsRepository {
  static const _key = 'last_viewed_sport';

  Future<Sport?> getLastViewedSport() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Sport.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLastViewedSport(Sport sport) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(sport.toJson()));
  }

  Future<void> clearLastViewedSport() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}