import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Central place for environment-dependent configuration.
///
/// BEFORE: baseUrl was hardcoded to 'http://127.0.0.1:5000' in api_service.dart.
/// This only works when running on the exact same machine as the Flask
/// server (e.g. Chrome/web on your dev laptop). It silently fails on:
///   - Android emulator (needs 10.0.2.2, which maps to the host's localhost)
///   - a physical phone/tablet (needs your machine's real LAN IP)
///   - any real deployment (needs the production URL)
///
/// AFTER: pick the right default per platform automatically, with a single
/// override point (`prodBaseUrl`) for when you deploy the backend for real.
class AppConfig {
  AppConfig._();

  /// Set this once you deploy the Flask backend (e.g. to Render), and set
  /// [useProd] to true. Until then, the app auto-detects a sensible local
  /// development URL based on the platform it's running on.
  static const String prodBaseUrl = 'https://your-backend.onrender.com';
  static const bool useProd = false;

  /// If you're testing on a physical device on the same Wi-Fi as your
  /// dev machine, put your machine's LAN IP here (e.g. '192.168.1.42') and it
  /// will be used automatically instead of the emulator loopback address.
  static const String? lanOverrideIp = null;

  static String get baseUrl {
    if (useProd) return prodBaseUrl;

    if (lanOverrideIp != null) {
      return 'http://$lanOverrideIp:5000';
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:5000';
    }

    // Platform.isAndroid/isIOS throw on web, hence the kIsWeb check above.
    if (Platform.isAndroid) {
      // Android emulator's alias for the host machine's localhost.
      return 'http://10.0.2.2:5000';
    }

    // iOS simulator, desktop (macOS/Linux/Windows) can all reach the host
    // machine directly via localhost.
    return 'http://127.0.0.1:5000';
  }
}
