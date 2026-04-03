import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/countdown_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_services.dart';

class CountdownStorage {
  static const String key = 'countdown_items';

  static Future<void> saveItems(List<CountdownItem> items) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = items.map((e) => e.toJson()).toList();
    await prefs.setString(key, jsonEncode(jsonList));

    try {
      final res = await ApiService.saveItems(jsonList);
      if (kDebugMode) {
        print("Server response: $res");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving items to server: $e");
      }
    }
  }

  static Future<List<CountdownItem>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(key);
    if (str == null) return [];
    final list = jsonDecode(str) as List;
    return list.map((e) => CountdownItem.fromJson(e)).toList();
  }
}