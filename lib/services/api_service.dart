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
    double? budget,  // Added optional budget parameter
  }) async {
    try {
      print('🌱 Connecting to: $baseUrl/recommend');

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'rainfall': rainfall,
        'temperature': temperature,
        'soil_type': soilType,
        'crop_type': cropType,
        'area': area,
      };

      // Add budget if provided
      if (budget != null) {
        requestBody['budget'] = budget;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/recommend'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('✅ Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Check if the response contains an error
        if (data['status'] == 'error') {
          throw Exception(data['error'] ?? 'Unknown error from server');
        }

        return data;
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Connection error: $e');
      throw Exception('Failed to connect: $e');
    }
  }

  // Test connection to API
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('✅ API is reachable');
        return true;
      } else {
        print('❌ API returned status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Cannot reach API: $e');
      return false;
    }
  }
}