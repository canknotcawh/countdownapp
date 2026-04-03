import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://confinedly-sematic-darwin.ngrok-free.dev";

  static Future<String> saveItems(List<Map<String, dynamic>> items) async {
    final url = Uri.parse("$baseUrl/saveItems");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(items), // list JSON
    );

    return response.body;
  }
}