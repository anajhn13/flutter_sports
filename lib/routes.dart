
import 'dart:convert';

import 'package:favorite_sports/model/sports.dart';
import 'package:favorite_sports/screens/sportDetailScreen.dart';
import 'package:favorite_sports/screens/sportListScreen.dart';
import 'package:flutter/material.dart';


class Routes {
  static const String list = '/';
  static const String details = '/details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case list:
        return MaterialPageRoute(builder: (_) => SportListScreen());
      case details:
      final Sport sport = settings.arguments as Sport;
        return MaterialPageRoute(
          builder: (_) => SportDetailScreen(sport: sport),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(body: Center(child: Text('Rota não encontrada'))),
        );
    }
  }
}
