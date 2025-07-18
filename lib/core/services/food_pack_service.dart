import 'package:logger/logger.dart';
import 'package:triple_prime_mobile/core/utils/network_service.dart';
import 'package:triple_prime_mobile/shared/models/food_pack_models.dart';

class FoodPackService {
  static final FoodPackService _instance = FoodPackService._internal();
  factory FoodPackService() => _instance;

  final NetworkService _networkService = NetworkService();
  final _logger = Logger();

  FoodPackService._internal();

  /// Get all food packs
  Future<ApiResponse<FoodPackResponse>> getFoodPacks() async {
    try {
      _logger.i('🔄 Fetching food packs from API');

      final response = await _networkService.get<FoodPackResponse>(
        '/FoodPack',
        fromJson: (json) {
          _logger.d('🔍 Parsing food packs response JSON: $json');
          try {
            return FoodPackResponse.fromJson(json);
          } catch (e) {
            _logger.e('💥 Failed to parse FoodPackResponse: $e');
            rethrow;
          }
        },
      );

      if (response.success && response.data != null) {
        _logger.i(
            '✅ Successfully fetched ${response.data!.data.length} food packs');
      } else {
        _logger.e('❌ Failed to fetch food packs - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Food packs fetch error: $e');
      return ApiResponse.error(
        message: 'Failed to fetch food packs. Please try again.',
        statusCode: 500,
      );
    }
  }
}
