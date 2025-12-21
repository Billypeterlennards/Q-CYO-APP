import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000";
  static Future<Map<String, dynamic>> recommend(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/recommend"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }
}
