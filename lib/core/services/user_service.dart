import 'package:logger/logger.dart';
import 'package:triple_prime_mobile/core/constants/app_constants.dart';
import 'package:triple_prime_mobile/core/services/storage_service.dart';
import 'package:triple_prime_mobile/core/utils/network_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  final NetworkService _networkService = NetworkService();
  final StorageService _storageService = StorageService();
  final _logger = Logger();

  UserService._internal();

  Future<ApiResponse<Map<String, dynamic>>> updateDeviceToken({
    required String deviceToken,
  }) async {
    try {
      _logger.i('🔄 Starting device token update process');

      final userData = await _storageService.getUserData();
      if (userData == null) {
        _logger.e('❌ User data not found, cannot update device token');
        return ApiResponse.error(
          message: 'User not authenticated. Please login again.',
          statusCode: 401,
        );
      }

      _logger.d('📤 Device token update request for user: ${userData.id}');

      final response = await _networkService.put<Map<String, dynamic>>(
        '${AppConstants.userDeviceToken}/${userData.id}',
        data: {
          'deviceToken': deviceToken,
        },
        fromJson: (json) {
          _logger.d('🔍 Parsing device token update response JSON: $json');
          try {
            return json as Map<String, dynamic>;
          } catch (e) {
            _logger.e('💥 Failed to parse device token update response: $e');
            rethrow;
          }
        },
      );

      if (response.success) {
        _logger
            .i('✅ Device token updated successfully for user: ${userData.id}');
      } else {
        _logger.e(
            '❌ Device token update failed for user: ${userData.id} - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Device token update error: $e');
      return ApiResponse.error(
        message: 'Failed to update device token. Please try again.',
        statusCode: 500,
      );
    }
  }
}
