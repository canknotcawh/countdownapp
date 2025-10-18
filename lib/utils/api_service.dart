import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/countdown_item.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.xxx:3000";

  // Fetch
  static Future<List<CountdownItem>> fetchCountdowns() async {
    final res = await http.get(Uri.parse("$baseUrl/countdowns"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => CountdownItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch countdowns');
    }
  }

  // Add
  static Future<void> addCountdown(CountdownItem item) async {
    final res = await http.post(
      Uri.parse("$baseUrl/countdowns"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to add countdown');
    }
  }

  // Delete
  static Future<void> deleteCountdown(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/countdowns/$id"));
    if (res.statusCode != 200) {
      throw Exception('Failed to delete countdown');
    }
  }

  // Update
  static Future<void> updateCountdown(CountdownItem item) async {
    final res = await http.put(
      Uri.parse("$baseUrl/countdowns/${item.id}"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update countdown');
    }
  }
}
