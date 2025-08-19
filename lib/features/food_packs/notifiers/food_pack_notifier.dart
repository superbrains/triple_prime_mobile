// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:triple_prime_mobile/core/services/food_pack_service.dart';
import 'package:triple_prime_mobile/core/utils/app_utils.dart';
import 'package:triple_prime_mobile/shared/models/food_pack_models.dart';
import 'package:triple_prime_mobile/core/utils/custom_snackbar.dart';
import 'package:triple_prime_mobile/core/services/storage_service.dart';
import 'package:triple_prime_mobile/core/services/env_service.dart';

class FoodPackNotifier extends ChangeNotifier {
  final FoodPackService _foodPackService = FoodPackService();
  final StorageService _storageService = StorageService();

  List<FoodPack> _foodPacks = [];
  List<FoodPack> _filteredPacks = [];
  bool _isLoading = false;
  String _error = '';
  String _selectedCategory = 'All Categories';
  String _searchQuery = '';

  String _selectedPaymentFrequency = 'Weekly';
  String _selectedPaymentMethod = 'Manual Payment';
  final List<String> _paymentFrequencies = ['Daily', 'Weekly', 'Monthly'];

  // Getters
  List<FoodPack> get foodPacks => _foodPacks;
  List<FoodPack> get filteredPacks => _filteredPacks;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get selectedPaymentFrequency => _selectedPaymentFrequency;
  String get selectedPaymentMethod => _selectedPaymentMethod;
  List<String> get paymentFrequencies => _paymentFrequencies;

  // Categories from API data
  List<String> get categories {
    final categories = _foodPacks.map((pack) => pack.category).toSet().toList();
    categories.sort();
    return ['All Categories', ...categories];
  }

  /// Fetch food packs from API
  Future<void> fetchFoodPacks() async {
    _setLoading(true);
    _setError('');

    try {
      final response = await _foodPackService.getFoodPacks();

      if (response.success && response.data != null) {
        _foodPacks = response.data!.data;
        _applyFilters();
        notifyListeners();
      } else {
        _setError(response.message ?? 'Failed to fetch food packs');
      }
    } catch (e) {
      _setError('Failed to fetch food packs. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  /// Set selected category and apply filters
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Set search query and apply filters
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Apply filters based on selected category and search query
  void _applyFilters() {
    _filteredPacks = _foodPacks.where((pack) {
      // Category filter
      final matchesCategory = _selectedCategory == 'All Categories' ||
          pack.category.toLowerCase() == _selectedCategory.toLowerCase();

      // Search filter
      final matchesSearch = _searchQuery.isEmpty ||
          pack.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pack.description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  /// Refresh food packs (pull to refresh)
  Future<void> refreshFoodPacks() async {
    await fetchFoodPacks();
  }

  /// Clear filters
  void clearFilters() {
    _selectedCategory = 'All Categories';
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  /// Get food pack by ID
  FoodPack? getFoodPackById(int id) {
    try {
      return _foodPacks.firstWhere((pack) => pack.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get featured food packs
  List<FoodPack> get featuredPacks {
    return _foodPacks.where((pack) => pack.featured).toList();
  }

  /// Get food packs by category
  List<FoodPack> getFoodPacksByCategory(String category) {
    if (category == 'All Categories') {
      return _foodPacks;
    }
    return _foodPacks
        .where((pack) => pack.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void setPaymentFrequency(String frequency) {
    _selectedPaymentFrequency = frequency;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  String calculatePaymentAmount(FoodPack foodPack) {
    double totalAmount = foodPack.price;
    int durationInMonths = foodPack.duration;

    switch (_selectedPaymentFrequency) {
      case 'Daily':
        int totalDays = _calculateTotalDays(durationInMonths);
        return AppUtils.formatAmount(totalAmount / totalDays);
      case 'Weekly':
        int totalWeeks = _calculateTotalWeeks(durationInMonths);
        return AppUtils.formatAmount(totalAmount / totalWeeks);
      case 'Monthly':
        return AppUtils.formatAmount(totalAmount / durationInMonths);
      default:
        return AppUtils.formatAmount(totalAmount / durationInMonths);
    }
  }

  double calculatePaymentAmountRaw(FoodPack foodPack) {
    double totalAmount = foodPack.price;
    int durationInMonths = foodPack.duration;

    switch (_selectedPaymentFrequency) {
      case 'Daily':
        int totalDays = _calculateTotalDays(durationInMonths);
        return totalAmount / totalDays;
      case 'Weekly':
        int totalWeeks = _calculateTotalWeeks(durationInMonths);
        return totalAmount / totalWeeks;
      case 'Monthly':
        return totalAmount / durationInMonths;
      default:
        return totalAmount / durationInMonths;
    }
  }

  int _calculateTotalDays(int months) {
    DateTime startDate = DateTime.now();
    DateTime endDate =
        DateTime(startDate.year, startDate.month + months, startDate.day);
    return endDate.difference(startDate).inDays;
  }

  int _calculateTotalWeeks(int months) {
    DateTime startDate = DateTime.now();
    DateTime endDate =
        DateTime(startDate.year, startDate.month + months, startDate.day);
    int totalDays = endDate.difference(startDate).inDays;
    return (totalDays / 7).ceil();
  }

  List<Map<String, String>> generatePaymentSchedule(FoodPack foodPack) {
    List<Map<String, String>> schedule = [];
    DateTime startDate = DateTime.now();
    double paymentAmount = calculatePaymentAmountRaw(foodPack);

    int numberOfPayments = _getNumberOfPayments(foodPack.duration);
    int maxDisplayPayments = _selectedPaymentFrequency == 'Daily'
        ? 10
        : _selectedPaymentFrequency == 'Weekly'
            ? 12
            : 6;

    for (int i = 1; i <= numberOfPayments && i <= maxDisplayPayments; i++) {
      DateTime paymentDate;

      if (_selectedPaymentFrequency == 'Monthly') {
        paymentDate =
            DateTime(startDate.year, startDate.month + i, startDate.day);
        if (paymentDate.day != startDate.day) {
          paymentDate = DateTime(startDate.year, startDate.month + i, 1);
          paymentDate = paymentDate.add(Duration(days: startDate.day - 1));
        }
      } else {
        int intervalDays = _getPaymentIntervalDays();
        paymentDate = startDate.add(Duration(days: i * intervalDays));
      }

      schedule.add({
        'date':
            '${_getMonthName(paymentDate.month)} ${paymentDate.day}, ${paymentDate.year}',
        'amount': AppUtils.formatAmount(paymentAmount),
      });
    }

    return schedule;
  }

  int _getNumberOfPayments(int durationInMonths) {
    switch (_selectedPaymentFrequency) {
      case 'Daily':
        return _calculateTotalDays(durationInMonths);
      case 'Weekly':
        return _calculateTotalWeeks(durationInMonths);
      case 'Monthly':
        return durationInMonths;
      default:
        return durationInMonths;
    }
  }

  int _getPaymentIntervalDays() {
    switch (_selectedPaymentFrequency) {
      case 'Daily':
        return 1;
      case 'Weekly':
        return 7;
      case 'Monthly':
        return 30;
      default:
        return 7;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  /// Process payment using Paystack
  Future<void> processPayment({
    required BuildContext context,
    required FoodPack foodPack,
    String? secretKey,
  }) async {
    try {
      // Get user data from storage
      final userData = await _storageService.getUserData();
      if (userData == null) {
        CustomSnackBar.showError(
            context, 'User not authenticated. Please login again.');
        return;
      }

      // Generate unique transaction reference
      final uniqueTransRef = PayWithPayStack().generateUuidV4();

      // Calculate payment amount
      double paymentAmount = calculatePaymentAmountRaw(foodPack);

      // Prepare metadata
      final metadata = {
        "custom_fields": [
          {
            "display_name": "Food Pack",
            "variable_name": "food_pack",
            "value": foodPack.id.toString()
          },
          {
            "display_name": "Payment Type",
            "variable_name": "payment_type",
            "value": _selectedPaymentMethod
          },
          {
            "display_name": "Payment Frequency",
            "variable_name": "payment_frequency",
            "value": _selectedPaymentFrequency
          },
          {
            "display_name": "Is Automatic",
            "variable_name": "is_automatic",
            "value": _selectedPaymentMethod == 'Automatic Payment'
          },
          {
            "display_name": "Food Pack Name",
            "variable_name": "food_pack_name",
            "value": foodPack.name
          },
          {
            "display_name": "Duration",
            "variable_name": "duration",
            "value": foodPack.duration.toString()
          },
          {
            "display_name": "User ID",
            "variable_name": "user_id",
            "value": userData.id
          },
          {
            "display_name": "User Name",
            "variable_name": "user_name",
            "value": "${userData.firstName} ${userData.lastName}"
          }
        ]
      };

      // Show loading message
      CustomSnackBar.showLoading(context, 'Processing payment...');

      // Initialize Paystack payment
      PayWithPayStack().now(
        context: context,
        secretKey: secretKey ?? EnvService.paystackSecretKey,
        customerEmail: userData.email,
        reference: uniqueTransRef,
        currency: "NGN",
        amount: paymentAmount,
        callbackUrl: EnvService.paystackCallbackUrl,
        metaData: metadata,
        transactionCompleted: (paymentData) {
          // Dismiss loading
          Navigator.of(context).pop();

          // Show success message
          CustomSnackBar.showSuccess(context,
              'Payment successful! Your savings plan has been activated.');

          // Navigate back to previous screen
          Navigator.of(context).pop();

          debugPrint('Payment completed: ${paymentData.toString()}');
        },
        transactionNotCompleted: (reason) {
          // Dismiss loading
          // Navigator.of(context).pop();

          // // Show error message
          // CustomSnackBar.showError(context, 'Payment failed: $reason');

          debugPrint("Transaction failed: $reason");
        },
      );
    } catch (e) {
      // Dismiss loading
      // Navigator.of(context).pop();

      // Show error message
      // CustomSnackBar.showError(
      //     context, 'Payment processing failed. Please try again.');

      debugPrint('Payment error: $e');
    }
  }

  /// Get payment amount for Paystack
  double getPaymentAmount(FoodPack foodPack) {
    return calculatePaymentAmountRaw(foodPack);
  }
}
