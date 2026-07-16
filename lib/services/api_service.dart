import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/recommendation_result.dart';

class ApiService {
  /// BEFORE: hardcoded 'http://127.0.0.1:5000'. Now delegates to AppConfig,
  /// which picks the right host per platform (see app_config.dart for why
  /// this matters on Android emulators and physical devices).
  static String get baseUrl => AppConfig.baseUrl;

  /// BEFORE: no timeout at all - a hung backend or bad network would leave
  /// the UI stuck on the loading spinner forever with no way out.
  static const _timeout = Duration(seconds: 15);

  static Future<RecommendationResult> getRecommendation({
    required double rainfall,
    required double temperature,
    required String soilType,
    required String cropType,
    required double area,
    double? budget,
  }) async {
    final requestBody = <String, dynamic>{
      'rainfall': rainfall,
      'temperature': temperature,
      'soil_type': soilType,
      'crop_type': cropType,
      'area': area,
      if (budget != null) 'budget': budget,
    };

    _log('Connecting to: $baseUrl/recommend');

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/recommend'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(_timeout);

      _log('Response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw ApiException(
          'Server error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == 'error') {
        throw ApiException(data['error']?.toString() ?? 'Unknown server error');
      }

      return RecommendationResult.fromJson(data);
    } on http.ClientException catch (e) {
      _log('Connection error: $e');
      throw ApiException(
        'Could not reach the server. Check that the backend is running at $baseUrl',
      );
    } on FormatException catch (e) {
      _log('Response parsing error: $e');
      throw ApiException('The server returned an unexpected response format.');
    } on ApiException {
      rethrow;
    } catch (e) {
      _log('Unexpected error: $e');
      throw ApiException('Failed to get recommendation: $e');
    }
  }

  static Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/'), headers: {'Accept': 'application/json'})
          .timeout(_timeout);
      final ok = response.statusCode == 200;
      _log(ok ? 'API is reachable' : 'API returned status: ${response.statusCode}');
      return ok;
    } catch (e) {
      _log('Cannot reach API: $e');
      return false;
    }
  }

  /// BEFORE: raw print() calls left in production code, which is noisy,
  /// leaks internal details in release builds, and can't be filtered by
  /// log level. kDebugMode gate ensures this is a no-op in release builds.
  static void _log(String message) {
    if (kDebugMode) {
      debugPrint('[ApiService] $message');
    }
  }
}

/// Dedicated exception type instead of throwing/catching generic
/// Exception(String) and doing fragile `.replaceAll('Exception: ', '')`
/// string surgery on the message at the call site (as the old code did).
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
