import 'package:flutter/material.dart';
import 'package:triple_prime_mobile/core/services/savings_plan_service.dart';
import 'package:triple_prime_mobile/shared/models/savings_plan_models.dart';

class SavingsPlanNotifier extends ChangeNotifier {
  final SavingsPlanService _savingsPlanService = SavingsPlanService();

  List<SavingsPlan> _savingsPlans = [];
  List<SavingsPlan> _filteredPlans = [];
  bool _isLoading = false;
  String _error = '';
  String _selectedStatus = 'All Status';
  String _searchQuery = '';
  final Map<int, bool> _reminderLoadingStates =
      {}; // Track loading state for each plan

  // Getters
  List<SavingsPlan> get savingsPlans => _savingsPlans;
  List<SavingsPlan> get filteredPlans => _filteredPlans;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;

  // Check if a specific plan's reminders are being updated
  bool isReminderLoading(int planId) => _reminderLoadingStates[planId] ?? false;

  // Status options
  List<String> get statusOptions {
    final statuses = _savingsPlans.map((plan) => plan.status).toSet().toList();
    statuses.sort();
    return ['All Status', ...statuses];
  }

  // Active plans
  List<SavingsPlan> get activePlans {
    return _savingsPlans.where((plan) => plan.isActive).toList();
  }

  // Completed plans
  List<SavingsPlan> get completedPlans {
    return _savingsPlans.where((plan) => plan.isCompleted).toList();
  }

  // Total saved amount
  double get totalSavedAmount {
    return _savingsPlans.fold(0.0, (sum, plan) => sum + plan.amountPaid);
  }

  // Total active plans count
  int get activePlansCount {
    return activePlans.length;
  }

  /// Fetch savings plans from API
  Future<void> fetchSavingsPlans() async {
    _setLoading(true);
    _setError('');

    try {
      final response = await _savingsPlanService.getSavingsPlans();

      if (response.success && response.data != null) {
        _savingsPlans = response.data!;
        _applyFilters();
        notifyListeners();
      } else {
        _setError(response.message ?? 'Failed to fetch savings plans');
      }
    } catch (e) {
      _setError('Failed to fetch savings plans. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  /// Set selected status and apply filters
  void setSelectedStatus(String status) {
    _selectedStatus = status;
    _applyFilters();
    notifyListeners();
  }

  /// Set search query and apply filters
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Apply filters based on selected status and search query
  void _applyFilters() {
    _filteredPlans = _savingsPlans.where((plan) {
      // Status filter
      final matchesStatus = _selectedStatus == 'All Status' ||
          plan.status.toLowerCase() == _selectedStatus.toLowerCase();

      // Search filter
      final matchesSearch = _searchQuery.isEmpty ||
          plan.foodPackName.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesStatus && matchesSearch;
    }).toList();
  }

  /// Refresh savings plans (pull to refresh)
  Future<void> refreshSavingsPlans() async {
    await fetchSavingsPlans();
  }

  /// Clear filters
  void clearFilters() {
    _selectedStatus = 'All Status';
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  /// Get savings plan by ID
  SavingsPlan? getSavingsPlanById(int id) {
    try {
      return _savingsPlans.firstWhere((plan) => plan.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get savings plans by status
  List<SavingsPlan> getSavingsPlansByStatus(String status) {
    if (status == 'All Status') {
      return _savingsPlans;
    }
    return _savingsPlans
        .where((plan) => plan.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  /// Get savings plans by food pack ID
  List<SavingsPlan> getSavingsPlansByFoodPackId(int foodPackId) {
    return _savingsPlans
        .where((plan) => plan.foodPackId == foodPackId)
        .toList();
  }

  /// Toggle reminders for a savings plan
  Future<bool> toggleReminders(int planId, bool enabled) async {
    _reminderLoadingStates[planId] = true;
    notifyListeners();

    try {
      final response =
          await _savingsPlanService.updateReminders(planId, enabled);

      if (response.success) {
        // Refresh the savings plans to get updated data
        await fetchSavingsPlans();
        return true;
      } else {
        _setError(response.message ?? 'Failed to update reminders');
        return false;
      }
    } catch (e) {
      _setError('Failed to update reminders. Please try again.');
      return false;
    } finally {
      _reminderLoadingStates[planId] = false;
      notifyListeners();
    }
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
}
