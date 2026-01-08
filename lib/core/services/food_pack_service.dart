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

  /// Get food pack with pricing tiers
  Future<ApiResponse<FoodPackWithPricing>> getFoodPackWithPricing(int foodPackId) async {
    try {
      _logger.i('🔄 Fetching food pack $foodPackId with pricing from API');

      final response = await _networkService.get<FoodPackWithPricing>(
        '/FoodPack/$foodPackId/with-pricing',
        fromJson: (json) {
          _logger.d('🔍 Parsing food pack with pricing response JSON: $json');
          try {
            // Extract data from nested response structure
            final data = json['data'] ?? json;
            return FoodPackWithPricing.fromJson(data);
          } catch (e) {
            _logger.e('💥 Failed to parse FoodPackWithPricing: $e');
            rethrow;
          }
        },
      );

      if (response.success && response.data != null) {
        _logger.i(
            '✅ Successfully fetched food pack with ${response.data!.pricings.length} pricing tiers');
      } else {
        _logger.e('❌ Failed to fetch food pack pricing - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Food pack pricing fetch error: $e');
      return ApiResponse.error(
        message: 'Failed to fetch food pack pricing. Please try again.',
        statusCode: 500,
      );
    }
  }

  /// Get pricing for specific duration
  Future<ApiResponse<FoodPackPricing>> getFoodPackPricingByDuration(
      int foodPackId, int durationMonths) async {
    try {
      _logger.i('🔄 Fetching food pack $foodPackId pricing for $durationMonths months');

      final response = await _networkService.get<FoodPackPricing>(
        '/FoodPack/$foodPackId/pricing/$durationMonths',
        fromJson: (json) {
          _logger.d('🔍 Parsing pricing response JSON: $json');
          try {
            // Extract data from nested response structure
            final data = json['data'] ?? json;
            return FoodPackPricing.fromJson(data);
          } catch (e) {
            _logger.e('💥 Failed to parse FoodPackPricing: $e');
            rethrow;
          }
        },
      );

      if (response.success && response.data != null) {
        _logger.i('✅ Successfully fetched pricing for $durationMonths months');
      } else {
        _logger.e('❌ Failed to fetch pricing - ${response.message}');
      }

      return response;
    } catch (e) {
      _logger.e('💥 Pricing fetch error: $e');
      return ApiResponse.error(
        message: 'Failed to fetch pricing. Please try again.',
        statusCode: 500,
      );
    }
  }
}
