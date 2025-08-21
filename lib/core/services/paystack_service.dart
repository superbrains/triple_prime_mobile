import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_payment_plus/flutter_paystack_payment_plus.dart';
import 'package:triple_prime_mobile/core/services/env_service.dart';
import 'package:triple_prime_mobile/core/constants/app_constants.dart';

class PaystackService {
  static final PaystackService _instance = PaystackService._internal();
  factory PaystackService() => _instance;
  PaystackService._internal();

  late final PaystackPayment plugin;

  /// Initialize the Paystack plugin
  Future<void> initialize() async {
    plugin = PaystackPayment();
    await plugin.initialize(publicKey: EnvService.paystackPublicKey);
  }

  /// Generate a unique UUID v4 for transaction reference
  String generateUuidV4() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));

    // Set version (4) and variant bits
    values[6] = (values[6] & 0x0f) | 0x40;
    values[8] = (values[8] & 0x3f) | 0x80;

    final hex =
        values.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }

  /// Process payment using the checkout method (recommended)
  Future<void> processPayment({
    required BuildContext context,
    required String customerEmail,
    required String reference,
    required double amount,
    required Map<String, dynamic> metadata,
    String currency = AppConstants.currencyCode,
    String? callbackUrl,
    String? accessCode, // Optional access code from backend
    required Function(Map<String, dynamic>) onSuccess,
    required Function(String) onError,
    required Function() onCancelled,
  }) async {
    try {
      // Create charge object
      Charge charge = Charge()
        ..amount =
            (amount * 100).round() // Convert to kobo (smallest currency unit)
        ..email = customerEmail
        ..putCustomField('Charged From', 'Triple Prime Mobile App');

      // Set reference or access code based on what's provided
      if (accessCode != null) {
        charge.accessCode = accessCode;
      } else {
        charge.reference = reference;
      }

      // Add metadata
      metadata.forEach((key, value) {
        charge.putCustomField(key, value.toString());
      });

      // Process checkout
      CheckoutResponse response = await plugin.checkout(
        context,
        charge: charge,
        method: CheckoutMethod.card,
      );

      // Handle response
      if (response.status) {
        // Payment successful
        onSuccess({
          'reference': response.reference,
          'amount': amount,
          'status': 'success',
          'message': 'Payment completed successfully',
        });
      } else {
        // Payment failed or cancelled
        if (response.message.toLowerCase().contains('cancelled') == true) {
          onCancelled();
        } else {
          onError(response.message);
        }
      }
    } catch (e) {
      onError('Payment processing error: $e');
    }
  }

  /// Verify transaction on backend (should be called after successful payment)
  /// This should be implemented on your backend server
  Future<Map<String, dynamic>> verifyTransaction(String reference) async {
    try {
      // This should be implemented on your backend
      // Make a GET request to: https://api.paystack.co/transaction/verify/$reference
      // with your secret key in the Authorization header
      return {
        'status': true,
        'message': 'Verification should be done on backend',
      };
    } catch (e) {
      return {
        'status': false,
        'message': 'Verification failed: $e',
      };
    }
  }

  /// Initialize transaction on backend to get access code
  /// This should be implemented on your backend server
  Future<Map<String, dynamic>> initializeTransaction({
    required String email,
    required double amount,
    required String reference,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // This should be implemented on your backend
      // Make a POST request to: https://api.paystack.co/transaction/initialize
      // with your secret key in the Authorization header
      // Example payload:
      // {
      //   "email": email,
      //   "amount": (amount * 100).round(),
      //   "reference": reference,
      //   "metadata": metadata,
      //   "callback_url": "https://your-domain.com/callback"
      // }

      return {
        'status': true,
        'message': 'Initialization should be done on backend',
        'access_code': null, // This should be returned from your backend
      };
    } catch (e) {
      return {
        'status': false,
        'message': 'Initialization failed: $e',
        'access_code': null,
      };
    }
  }
}

// Legacy class for backward compatibility
class PayWithPayStack {
  static final PaystackService _service = PaystackService();

  static String generateUuidV4() => _service.generateUuidV4();

  static void now({
    required BuildContext context,
    required String secretKey,
    required String customerEmail,
    required String reference,
    required String currency,
    required double amount,
    required String callbackUrl,
    required Map<String, dynamic> metaData,
    String? accessCode, // Optional access code from backend
    required Function(Map<String, dynamic>) transactionCompleted,
    required Function(String) transactionNotCompleted,
  }) {
    _service.processPayment(
      context: context,
      customerEmail: customerEmail,
      reference: reference,
      amount: amount,
      metadata: metaData,
      currency: currency,
      callbackUrl: callbackUrl,
      accessCode: accessCode,
      onSuccess: transactionCompleted,
      onError: transactionNotCompleted,
      onCancelled: () => transactionNotCompleted('Payment cancelled by user'),
    );
  }
}
