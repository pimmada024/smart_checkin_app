import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/checkin_model.dart';

class LocalStorageService {
  static const String _checkInKey = 'checkins';
  static const String _finishClassKey = 'finish_classes';

  Future<void> saveCheckIn(CheckInModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_checkInKey) ?? <String>[];
    current.add(jsonEncode(model.toMap()));
    await prefs.setStringList(_checkInKey, current);
  }

  Future<void> saveFinishClass(FinishClassModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_finishClassKey) ?? <String>[];
    current.add(jsonEncode(model.toMap()));
    await prefs.setStringList(_finishClassKey, current);
  }
}
