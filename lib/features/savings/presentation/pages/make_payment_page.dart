// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:triple_prime_mobile/core/app_router.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:triple_prime_mobile/core/utils/app_utils.dart';
import 'package:triple_prime_mobile/shared/models/savings_plan_models.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:triple_prime_mobile/core/services/env_service.dart';
import 'package:triple_prime_mobile/core/services/storage_service.dart';
import 'package:triple_prime_mobile/core/services/savings_plan_service.dart';
import 'package:triple_prime_mobile/core/utils/custom_snackbar.dart';
import 'package:triple_prime_mobile/core/constants/app_constants.dart';

class MakePaymentPage extends StatefulWidget {
  final SavingsPlan savingsPlan;

  const MakePaymentPage({
    super.key,
    required this.savingsPlan,
  });

  @override
  State<MakePaymentPage> createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage> {
  String _selectedPaymentPreference = 'Manual Payment';
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              height: 40,
              color: Colors.white,
            ),
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFoodPackSummaryCard(),
                    const SizedBox(height: 20),
                    _buildPaymentScheduleCard(),
                    const SizedBox(height: 20),
                    _buildPaymentPreferenceCard(),
                    const SizedBox(height: 16),
                    _buildImportantNote(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Make Payment',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              shape: const CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodPackSummaryCard() {
    final plan = widget.savingsPlan;
    final dailyAmount = plan.totalAmount / (plan.duration * 30);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Food Pack',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  Text(
                    '#${plan.id}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Daily Payment',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  Text(
                    AppUtils.formatAmount(dailyAmount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Progress',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                ),
                Text(
                  '${AppUtils.formatAmount(plan.amountPaid)} / ${AppUtils.formatAmount(plan.totalAmount)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentScheduleCard() {
    final paymentSchedules =
        widget.savingsPlan.paymentSchedules.take(6).toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Schedule',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: paymentSchedules.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final schedule = paymentSchedules[index];
              final isPaid = schedule.isPaid;
              final hasInterest = schedule.hasInterest;
              final isOverdue = schedule.isOverdue;

              return Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        isPaid
                            ? Icons.check_circle
                            : isOverdue
                                ? Icons.warning_amber
                                : Icons.schedule,
                        color: isPaid
                            ? Colors.grey[400]
                            : isOverdue
                                ? Colors.red
                                : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schedule.formattedDueDate,
                              style:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: isPaid
                                            ? Colors.grey[400]
                                            : Colors.black87,
                                        fontWeight: isPaid
                                            ? FontWeight.normal
                                            : FontWeight.w500,
                                      ),
                            ),
                            if (hasInterest && isOverdue)
                              Text(
                                '${schedule.daysOverdue} days overdue',
                                style:
                                    Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.red,
                                          fontSize: 11,
                                        ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppUtils.formatAmount(schedule.amount),
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: isPaid
                                          ? Colors.grey[400]
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          if (hasInterest)
                            Text(
                              '+${schedule.formattedAccruedInterest}',
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                      ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentPreferenceCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Preference',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(
            title: 'Automatic Payment',
            description:
                'Your card will be charged automatically for future payments.',
            value: 'Automatic Payment',
            groupValue: _selectedPaymentPreference,
            onChanged: (value) {
              setState(() {
                _selectedPaymentPreference = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(
            title: 'Manual Payment',
            description:
                'You\'ll need to make payments manually. We\'ll send reminders.',
            value: 'Manual Payment',
            groupValue: _selectedPaymentPreference,
            onChanged: (value) {
              setState(() {
                _selectedPaymentPreference = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String description,
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    final isSelected = groupValue == value;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppTheme.primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportantNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Note',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You\'ll need to make payments manually when they\'re due.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange[700],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey.shade400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _handlePayment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Proceed to Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle payment processing
  Future<void> _handlePayment() async {
    try {
      // Show loading dialog
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => const Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // );

      // Get user data from storage
      final userData = await _storageService.getUserData();
      if (userData == null) {
        Navigator.of(context).pop(); // Dismiss loading
        CustomSnackBar.showError(
            context, 'User not authenticated. Please login again.');
        return;
      }

      final List<PaymentSchedule> pendingPayments = widget
          .savingsPlan.paymentSchedules
          .where((schedule) => !schedule.isPaid)
          .toList();

      if (pendingPayments.isEmpty) {
        Navigator.of(context).pop(); // Dismiss loading
        CustomSnackBar.showError(context, 'No pending payments found.');
        return;
      }

      final PaymentSchedule nextPayment = pendingPayments.firstWhere(
        (schedule) => schedule.amount > widget.savingsPlan.amountPaid,
        orElse: () => pendingPayments.first,
      );
      final paymentAmount = nextPayment.totalDue;

      // Show confirmation dialog with interest breakdown if applicable
      if (nextPayment.hasInterest) {
        final confirmed = await _showPaymentConfirmationDialog(
          context,
          nextPayment,
        );
        if (!confirmed) {
          return; // User cancelled
        }
      }

      // Generate unique transaction reference
      final uniqueTransRef = PayWithPayStack().generateUuidV4();

      // Prepare metadata - send fields directly for proper Paystack webhook handling
      final metadata = {
        'food_pack': widget.savingsPlan.foodPackId.toString(),
        'payment_type': _selectedPaymentPreference,
        'payment_frequency': widget.savingsPlan.paymentFrequency,
        'is_automatic': (_selectedPaymentPreference == 'automatic').toString(),
        if (nextPayment.id != null) 'schedule_id': nextPayment.id.toString(),
      };

      // Process payment with Paystack
      PayWithPayStack().now(
        context: context,
        secretKey: EnvService.paystackSecretKey,
        customerEmail: userData.email,
        reference: uniqueTransRef,
        currency: AppConstants.currencyCode,
        amount: paymentAmount,
        callbackUrl: EnvService.paystackCallbackUrl,
        metaData: metadata,
        transactionCompleted: (paymentData) async {
          try {
            // Show loading while confirming with backend
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );

            // Extract payment details - use the original reference as fallback
            String paymentReference = uniqueTransRef;
            try {
              // Try to get reference from paymentData if it has a reference property
              if (paymentData != null) {
                final dynamic ref = (paymentData as dynamic)?.reference;
                if (ref != null) {
                  paymentReference = ref.toString();
                }
              }
            } catch (e) {
              // If paymentData doesn't have reference property, use original reference
              debugPrint('Could not extract reference from paymentData: $e');
            }

            // Confirm payment with backend
            final confirmResponse =
                await SavingsPlanService().confirmMobilePayment(
              planId: widget.savingsPlan.id,
              scheduleId: nextPayment.id,
              paymentReference: paymentReference,
              amount: paymentAmount,
              paymentMethod: _selectedPaymentPreference,
            );

            // Dismiss loading dialog
            if (context.mounted) {
              Navigator.of(context).pop();
            }

            if (confirmResponse.success) {
              if (context.mounted) {
                CustomSnackBar.showSuccess(
                    context, 'Payment confirmed successfully!');

                // Navigate to main screen after success
                Future.delayed(const Duration(seconds: 1), () {
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.mainScreen,
                      (route) => false,
                    );
                  }
                });
              }
            } else {
              if (context.mounted) {
                CustomSnackBar.showError(context,
                    'Payment successful but confirmation failed. Please contact support.');
              }
            }

            debugPrint('Payment completed: ${paymentData.toString()}');
          } catch (e) {
            // Dismiss loading dialog if still showing
            if (context.mounted) {
              Navigator.of(context).pop();
              CustomSnackBar.showError(context,
                  'Payment successful but confirmation failed. Please contact support.');
            }
            debugPrint('Payment confirmation error: $e');
          }
        },
        transactionNotCompleted: (reason) {
          debugPrint("Transaction failed: $reason");
        },
      );
    } catch (e) {
      // Dismiss loading
      Navigator.of(context).pop();

      // Show error message
      CustomSnackBar.showError(
          context, 'Payment processing failed. Please try again.');

      debugPrint('Payment error: $e');
    }
  }

  /// Show confirmation dialog with interest breakdown
  Future<bool> _showPaymentConfirmationDialog(
    BuildContext context,
    PaymentSchedule schedule,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Payment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountRow(
                  context,
                  'Principal:',
                  schedule.amount,
                ),
                const SizedBox(height: 8),
                _buildAmountRow(
                  context,
                  'Interest:',
                  schedule.accruedInterest,
                  isInterest: true,
                ),
                if (schedule.daysOverdue > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '(${schedule.daysOverdue} days overdue)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                    ),
                  ),
                const Divider(height: 24),
                _buildAmountRow(
                  context,
                  'Total:',
                  schedule.totalDue,
                  isBold: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Proceed to Payment'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildAmountRow(
    BuildContext context,
    String label,
    double amount, {
    bool isBold = false,
    bool isInterest = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14,
              ),
        ),
        Text(
          AppUtils.formatAmount(amount),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14,
                color: isInterest ? Colors.red : Colors.black87,
              ),
        ),
      ],
    );
  }
}
