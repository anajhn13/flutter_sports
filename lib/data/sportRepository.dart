import 'dart:convert';

import 'package:favorite_sports/model/sports.dart';
import 'package:flutter/services.dart';

class SportsRepository {
  final String assetPath;

  SportsRepository({this.assetPath = 'assets/data/sports.json'});

  Future<List<Sport>> loadSports() async {
    final jsonStr = await rootBundle.loadString(assetPath);
    final list = jsonDecode(jsonStr) as List;
    return list
        .map((e) => Sport.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}