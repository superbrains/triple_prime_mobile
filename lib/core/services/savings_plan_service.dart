import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:triple_prime_mobile/core/utils/network_service.dart';
import 'package:triple_prime_mobile/shared/models/savings_plan_models.dart';

class SavingsPlanService {
  static final SavingsPlanService _instance = SavingsPlanService._internal();
  factory SavingsPlanService() => _instance;

  final NetworkService _networkService = NetworkService();
  final _logger = Logger();

  SavingsPlanService._internal();

  /// Get all savings plans for the current user
  Future<ApiResponse<List<SavingsPlan>>> getSavingsPlans() async {
    try {
      _logger.i('🔄 Fetching savings plans from API');

      final response = await _networkService.get<List<SavingsPlan>>(
        '/SavingsPlan',
        fromJson: (json) {
          log('🔍 Parsing savings plans response JSON: $json');
          try {
            return (json as List<dynamic>)
                .map((item) =>
                    SavingsPlan.fromJson(item as Map<String, dynamic>))
                .toList();
          } catch (e) {
            _logger.e('💥 Failed to parse SavingsPlan list: $e');
            rethrow;
          }
        },
      );

      if (response.success && response.data != null) {
        _logger.i(
            '✅ Successfully fetched  [32m${response.data!.length} [0m savings plans');
      } else {
        _logger.e('❌ Failed to fetch savings plans - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Savings plans fetch error: $e');
      return ApiResponse.error(
        message: 'Failed to fetch savings plans. Please try again.',
        statusCode: 500,
      );
    }
  }

  /// Get a specific savings plan by ID
  Future<ApiResponse<SavingsPlan>> getSavingsPlanById(int id) async {
    try {
      _logger.i('🔄 Fetching savings plan with ID: $id');

      final response = await _networkService.get<SavingsPlan>(
        '/SavingsPlan/$id',
        fromJson: (json) {
          _logger.d('🔍 Parsing savings plan response JSON: $json');
          try {
            return SavingsPlan.fromJson(json);
          } catch (e) {
            _logger.e('💥 Failed to parse SavingsPlan: $e');
            rethrow;
          }
        },
      );

      if (response.success && response.data != null) {
        _logger.i(
            '✅ Successfully fetched savings plan: ${response.data!.foodPackName}');
      } else {
        _logger.e('❌ Failed to fetch savings plan - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Savings plan fetch error: $e');
      return ApiResponse.error(
        message: 'Failed to fetch savings plan. Please try again.',
        statusCode: 500,
      );
    }
  }

  /// Update reminders for a savings plan
  Future<ApiResponse<bool>> updateReminders(int planId, bool enabled) async {
    try {
      _logger.i(
          '🔄 Updating reminders for savings plan ID: $planId, enabled: $enabled');

      final response = await _networkService.put<bool>(
        '/SavingsPlan/$planId/reminders',
        data: {
          'enabled': enabled,
        },
        fromJson: (json) {
          _logger.d('🔍 Parsing reminder update response JSON: $json');
          return true; // API returns success status
        },
      );

      if (response.success) {
        _logger.i('✅ Successfully updated reminders for plan ID: $planId');
      } else {
        _logger.e('❌ Failed to update reminders - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Reminder update error: $e');
      return ApiResponse.error(
        message: 'Failed to update reminders. Please try again.',
        statusCode: 500,
      );
    }
  }

  /// Confirm mobile payment with backend
  Future<ApiResponse<SavingsPlan>> confirmMobilePayment({
    required int planId,
    required int scheduleId,
    required String paymentReference,
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      _logger.i('🔄 Confirming mobile payment for plan ID: $planId, schedule: $scheduleId');

      final response = await _networkService.post<SavingsPlan>(
        '/SavingsPlan/$planId/confirm-mobile-payment',
        data: {
          'scheduleId': scheduleId,
          'paymentReference': paymentReference,
          'amount': amount,
          'paymentMethod': paymentMethod,
        },
        fromJson: (json) {
          _logger.d('🔍 Parsing payment confirmation response JSON: $json');
          try {
            return SavingsPlan.fromJson(json);
          } catch (e) {
            _logger.e('💥 Failed to parse SavingsPlan: $e');
            rethrow;
          }
        },
      );

      if (response.success && response.data != null) {
        _logger.i('✅ Successfully confirmed payment for plan ID: $planId');
      } else {
        _logger.e('❌ Failed to confirm payment - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Payment confirmation error: $e');
      return ApiResponse.error(
        message: 'Failed to confirm payment. Please try again.',
        statusCode: 500,
      );
    }
  }

  /// Create new savings plan
  Future<ApiResponse<SavingsPlan>> createSavingsPlan({
    required int foodPackId,
    required double totalAmount,
    required double monthlyAmount,
    required int duration,
    required String paymentPreference,
    required String paymentFrequency,
    required String paymentReference,
  }) async {
    try {
      _logger.i('🔄 Creating savings plan for food pack ID: $foodPackId');

      final response = await _networkService.post<SavingsPlan>(
        '/SavingsPlan',
        data: {
          'foodPackId': foodPackId,
          'totalAmount': totalAmount,
          'monthlyAmount': monthlyAmount,
          'duration': duration,
          'startDate': DateTime.now().toIso8601String(),
          'paymentPreference': paymentPreference,
          'paymentFrequency': paymentFrequency,
          'paymentReference': paymentReference,
        },
        fromJson: (json) {
          _logger.d('🔍 Parsing create savings plan response JSON: $json');
          try {
            return SavingsPlan.fromJson(json);
          } catch (e) {
            _logger.e('💥 Failed to parse SavingsPlan: $e');
            rethrow;
          }
        },
      );

      if (response.success && response.data != null) {
        _logger.i('✅ Successfully created savings plan for food pack ID: $foodPackId');
      } else {
        _logger.e('❌ Failed to create savings plan - ${response.message}');
        if (response.errors != null && response.errors!.isNotEmpty) {
          _logger.e('🚫 Specific errors: ${response.errors}');
        }
      }

      return response;
    } catch (e) {
      _logger.e('💥 Create savings plan error: $e');
      return ApiResponse.error(
        message: 'Failed to create savings plan. Please try again.',
        statusCode: 500,
      );
    }
  }
}
