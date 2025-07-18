import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  static final EnvService _instance = EnvService._internal();
  factory EnvService() => _instance;

  EnvService._internal();

  /// Initialize environment variables
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  /// Get Paystack secret key from environment
  static String get paystackSecretKey {
    return dotenv.env['PAYSTACK_SECRET_KEY'] ?? '';
  }

  /// Get Paystack public key from environment
  static String get paystackPublicKey {
    return dotenv.env['PAYSTACK_PUBLIC_KEY'] ?? '';
  }

  /// Get Paystack callback URL from environment
  static String get paystackCallbackUrl {
    return dotenv.env['PAYSTACK_CALLBACK_URL'] ?? '';
  }

  /// Get API base URL from environment
  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? '';
  }

  /// Get API version from environment
  static String get apiVersion {
    return dotenv.env['API_VERSION'] ?? '';
  }

  /// Check if environment is properly loaded
  static bool get isLoaded {
    return dotenv.env.isNotEmpty;
  }

  /// Get all environment variables (for debugging)
  static Map<String, String> get all {
    return dotenv.env;
  }
}
