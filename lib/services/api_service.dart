import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Local testing URL
  static const String baseUrl = 'http://127.0.0.1:5000';

  // For Render deployment (when ready):
  // static const String baseUrl = 'https://your-backend.onrender.com';

  static Future<Map<String, dynamic>> getRecommendation({
    required double rainfall,
    required double temperature,
    required String soilType,
    required String cropType,
    required double area,
  }) async {
    try {
      print('🌱 Connecting to: $baseUrl/recommend');

      final response = await http.post(
        Uri.parse('$baseUrl/recommend'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'rainfall': rainfall,
          'temperature': temperature,
          'soil_type': soilType,
          'crop_type': cropType,
          'area': area,
        }),
      );

      print('✅ Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Connection error: $e');
      throw Exception('Failed to connect: $e');
    }
  }
}