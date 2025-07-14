import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:triple_prime_mobile/core/constants/app_constants.dart';
import 'package:triple_prime_mobile/core/utils/custom_snackbar.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  late Dio _dio;
  final _storage = const FlutterSecureStorage();
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  NetworkService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${AppConstants.baseUrl}/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json-patch+json',
        },
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _storage.read(key: AppConstants.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Log request for debugging
          _logger.i('🌐 REQUEST: ${options.method} ${options.path}');
          _logger.d('📤 Headers: ${options.headers}');
          if (options.data != null) {
            _logger.d('📤 Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response for debugging
          _logger.i(
              '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
          _logger.d('📥 Data: ${response.data}');

          // Log additional info for error responses
          if (response.data is Map<String, dynamic> &&
              response.data.containsKey('success') &&
              response.data['success'] == false) {
            _logger.w('⚠️ API returned success: false');
            _logger.w('📝 Error message: ${response.data['message']}');
            _logger.w('🚫 Errors: ${response.data['errors']}');
            _logger.w('🔍 Full error data: ${response.data}');
          }

          return handler.next(response);
        },
        onError: (error, handler) async {
          // Log error for debugging
          _logger.e(
              '❌ ERROR: ${error.response?.statusCode} ${error.requestOptions.path}');
          _logger.e('📥 Error Data: ${error.response?.data}');

          // Handle specific error cases
          if (error.response?.statusCode == 401) {
            // Clear token and redirect to login
            await _storage.delete(key: AppConstants.tokenKey);
            _logger.w('🔐 Token cleared due to 401 error');
            // You can add navigation logic here if needed
          }

          return handler.next(error);
        },
      ),
    );
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  // PATCH request
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _handleError<T>(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'Unexpected error occurred',
        statusCode: 500,
      );
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    final statusCode = response.statusCode ?? 0;

    // Handle different status codes
    switch (statusCode) {
      case 200:
      case 201:
        // Check if the response contains a success field
        if (response.data is Map<String, dynamic> &&
            response.data.containsKey('success')) {
          final success = response.data['success'] as bool;

          if (!success) {
            // Handle API-level error response
            final message = _extractErrorMessage(response.data);
            return ApiResponse.error(
              message: message,
              statusCode: statusCode,
              errors: _extractErrors(response.data),
            );
          }
        }

        try {
          final data =
              fromJson != null ? fromJson(response.data) : response.data;
          return ApiResponse.success(data: data, statusCode: statusCode);
        } catch (e) {
          return ApiResponse.error(
            message: 'Failed to parse response data',
            statusCode: statusCode,
          );
        }

      case 400:
        final message = _extractErrorMessage(response.data);
        return ApiResponse.error(
          message: message,
          statusCode: statusCode,
          errors: _extractErrors(response.data),
        );

      case 401:
        return ApiResponse.error(
          message: 'Unauthorized. Please login again.',
          statusCode: statusCode,
        );

      case 403:
        return ApiResponse.error(
          message:
              'Access forbidden. You don\'t have permission to perform this action.',
          statusCode: statusCode,
        );

      case 404:
        return ApiResponse.error(
          message: 'Resource not found.',
          statusCode: statusCode,
        );

      case 422:
        final message = _extractErrorMessage(response.data);
        return ApiResponse.error(
          message: message,
          statusCode: statusCode,
          errors: _extractErrors(response.data),
        );

      case 429:
        return ApiResponse.error(
          message: 'Too many requests. Please try again later.',
          statusCode: statusCode,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ApiResponse.error(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
        );

      default:
        return ApiResponse.error(
          message: 'An unexpected error occurred.',
          statusCode: statusCode,
        );
    }
  }

  ApiResponse<T> _handleError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResponse.error(
          message:
              'Request timed out. Please check your connection and try again.',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        return _handleResponse<T>(error.response!, null);

      case DioExceptionType.cancel:
        return ApiResponse.error(
          message: 'Request was cancelled.',
          statusCode: 499,
        );

      case DioExceptionType.connectionError:
        return ApiResponse.error(
          message:
              'No internet connection. Please check your network and try again.',
          statusCode: 0,
        );

      case DioExceptionType.badCertificate:
        return ApiResponse.error(
          message: 'SSL certificate error. Please try again later.',
          statusCode: 495,
        );

      case DioExceptionType.unknown:
      default:
        return ApiResponse.error(
          message: 'Network error occurred. Please try again.',
          statusCode: 0,
        );
    }
  }

  String _extractErrorMessage(dynamic data) {
    _logger.d(
        '🔍 Extracting error message from: $data (type: ${data.runtimeType})');

    // Handle different data types
    if (data is String) {
      _logger.d('📝 Found string error: $data');
      return data;
    }

    if (data is List) {
      _logger.d('📋 Found list error with ${data.length} items');
      if (data.isNotEmpty) {
        final firstItem = data.first;
        if (firstItem is String) {
          _logger.d('📝 Found string in list: $firstItem');
          return firstItem;
        } else if (firstItem is Map<String, dynamic>) {
          return _extractErrorMessageFromMap(firstItem);
        }
      }
      return 'An error occurred';
    }

    if (data is Map<String, dynamic>) {
      _logger.d('🗺️ Found map error with keys: ${data.keys.toList()}');
      return _extractErrorMessageFromMap(data);
    }

    // For any other type, try to convert to string
    final result = data?.toString() ?? 'An error occurred';
    _logger.d('🔄 Converted to string: $result');
    return result;
  }

  String _extractErrorMessageFromMap(Map<String, dynamic> data) {
    _logger.d('🗺️ Extracting from map with keys: ${data.keys.toList()}');

    // Try to get the most specific error message
    String? message = _extractStringValue(data['message']);
    _logger.d('📝 Message from "message" field: $message');

    // If no message or generic message, try to get more specific errors
    if (message == null ||
        message.contains('An error occurred') ||
        message.contains('Please try again')) {
      // Check for validation errors
      final errors = data['errors'];
      if (errors != null) {
        _logger.d('🚫 Found errors field: $errors');
        final extractedError = _extractErrorMessage(errors);
        if (extractedError != 'An error occurred') {
          message = extractedError;
          _logger.d('📝 Using extracted error: $message');
        }
      }

      // Check for other common error fields
      if (message == null || message.contains('An error occurred')) {
        final errorFields = [
          'error',
          'detail',
          'reason',
          'description',
          'title',
          'text'
        ];
        for (final field in errorFields) {
          final value = _extractStringValue(data[field]);
          if (value != null && !value.contains('An error occurred')) {
            message = value;
            _logger.d('📝 Using error from "$field" field: $message');
            break;
          }
        }

        if (message == null || message.contains('An error occurred')) {
          message = 'An error occurred. Please try again.';
          _logger.d('📝 Using fallback message: $message');
        }
      }
    }

    _logger.d('✅ Final extracted message: $message');
    return message ?? 'An error occurred';
  }

  String? _extractStringValue(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is bool) return value.toString();
    if (value is List) {
      if (value.isNotEmpty) {
        final firstItem = value.first;
        if (firstItem is String) return firstItem;
        if (firstItem is Map<String, dynamic>) {
          return _extractErrorMessageFromMap(firstItem);
        }
      }
    }
    if (value is Map<String, dynamic>) {
      return _extractErrorMessageFromMap(value);
    }
    return value.toString();
  }

  List<String> _extractErrors(dynamic data) {
    final errors = <String>[];

    if (data is Map<String, dynamic>) {
      final errorsField = data['errors'];
      if (errorsField != null) {
        errors.addAll(_extractErrorsFromValue(errorsField));
      }

      // Also check other common error fields
      final errorFields = [
        'error',
        'detail',
        'reason',
        'description',
        'title',
        'text'
      ];
      for (final field in errorFields) {
        final value = data[field];
        if (value != null) {
          final extracted = _extractErrorsFromValue(value);
          if (extracted.isNotEmpty) {
            errors.addAll(extracted);
          }
        }
      }
    } else if (data is List) {
      errors.addAll(_extractErrorsFromValue(data));
    } else if (data is String) {
      errors.add(data);
    }

    return errors;
  }

  List<String> _extractErrorsFromValue(dynamic value) {
    final errors = <String>[];

    if (value is String) {
      errors.add(value);
    } else if (value is List) {
      for (final item in value) {
        if (item is String) {
          errors.add(item);
        } else if (item is Map<String, dynamic>) {
          // Handle field-specific errors like {"email": ["Email already exists"]}
          for (final fieldErrors in item.values) {
            if (fieldErrors is List) {
              for (final fieldError in fieldErrors) {
                if (fieldError is String) {
                  errors.add(fieldError);
                } else if (fieldError is Map<String, dynamic>) {
                  // Recursively extract errors from nested objects
                  errors.addAll(_extractErrorsFromValue(fieldError));
                }
              }
            } else if (fieldErrors is String) {
              errors.add(fieldErrors);
            } else if (fieldErrors is Map<String, dynamic>) {
              // Recursively extract errors from nested objects
              errors.addAll(_extractErrorsFromValue(fieldErrors));
            }
          }
        }
      }
    } else if (value is Map<String, dynamic>) {
      // Handle nested error objects
      for (final entry in value.entries) {
        if (entry.value is String) {
          errors.add('${entry.key}: ${entry.value}');
        } else if (entry.value is List) {
          for (final item in entry.value) {
            if (item is String) {
              errors.add('${entry.key}: $item');
            }
          }
        } else if (entry.value is Map<String, dynamic>) {
          errors.addAll(_extractErrorsFromValue(entry.value));
        }
      }
    }

    return errors;
  }

  // Helper method to save auth token
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  // Helper method to clear auth token
  Future<void> clearAuthToken() async {
    await _storage.delete(key: AppConstants.tokenKey);
  }

  // Helper method to get auth token
  Future<String?> getAuthToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }
}

// Generic API Response class
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final List<String>? errors;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.success({
    required T data,
    int? statusCode,
  }) {
    return ApiResponse<T>(
      success: true,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    required String message,
    int? statusCode,
    List<String>? errors,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }

  // Helper method to show appropriate snackbar
  void showSnackBar(BuildContext context) {
    if (success) {
      CustomSnackBar.showSuccess(context, message ?? 'Operation successful');
    } else {
      CustomSnackBar.showError(context, message ?? 'An error occurred');
    }
  }
}
