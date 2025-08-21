// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:triple_prime_mobile/core/utils/app_utils.dart';
import 'package:triple_prime_mobile/features/savings/notifiers/savings_plan_notifier.dart';
import 'package:triple_prime_mobile/features/savings/presentation/pages/make_payment_page.dart';
import 'package:triple_prime_mobile/shared/models/savings_plan_models.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Consumer<SavingsPlanNotifier>(
            builder: (context, savingsPlanNotifier, child) {
              return RefreshIndicator(
                onRefresh: () => savingsPlanNotifier.refreshSavingsPlans(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Welcome Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryColor.withValues(alpha: 0.1),
                                AppTheme.primaryColor.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  AppTheme.primaryColor.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.savings,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome back!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Keep up the great work with your savings',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Colors.black54,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Active Plans Section
                        Text(
                          'Active Plans',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                        ),
                        const SizedBox(height: 16),

                        // Food Pack Cards (dynamic)
                        if (savingsPlanNotifier.activePlans.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Text(
                                'No active plans found.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 400, // Adjust height as needed
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: savingsPlanNotifier.activePlans.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final plan =
                                    savingsPlanNotifier.activePlans[index];
                                return _buildPlanCard(
                                    context, plan, savingsPlanNotifier);
                              },
                            ),
                          ),
                        // const SizedBox(height: 24),

                        // Quick Stats
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                'Total Saved',
                                savingsPlanNotifier.totalSavedAmount > 0
                                    ? AppUtils.formatAmount(
                                        savingsPlanNotifier.totalSavedAmount)
                                    : '₦0',
                                Icons.savings,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                'Active Plans',
                                savingsPlanNotifier.activePlansCount.toString(),
                                Icons.list_alt,
                                AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ), // Padding
                ), // SingleChildScrollView
              );
            }, // Consumer builder
          ), // SafeArea
        )); // Scaffold
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, SavingsPlan plan,
      SavingsPlanNotifier savingsPlanNotifier) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
              Text(
                plan.foodPackName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: plan.isActive
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  plan.status,
                  style: TextStyle(
                    color: plan.isActive
                        ? Colors.green.shade700
                        : Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress Section
          Text(
            'Progress',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: plan.progressPercentage,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green.shade600,
                    ),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                plan.progressText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Financial Details
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppUtils.formatAmount(plan.totalAmount),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount Paid',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppUtils.formatAmount(plan.amountPaid),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.paymentFrequency.toLowerCase() == 'daily'
                          ? 'Daily Payment'
                          : 'Monthly Payment',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.paymentFrequency.toLowerCase() == 'daily'
                          ? AppUtils.formatAmount(
                              plan.paymentSchedules.isNotEmpty
                                  ? plan.paymentSchedules.first.amount
                                  : 1000)
                          : AppUtils.formatAmount(plan.monthlyAmount),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Duration',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.paymentFrequency,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle payment
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MakePaymentPage(savingsPlan: plan),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    plan.paymentFrequency.toLowerCase() == 'daily'
                        ? 'Pay ${AppUtils.formatAmount(plan.paymentSchedules.isNotEmpty ? plan.paymentSchedules.first.amount : plan.monthlyAmount / 30)}'
                        : 'Pay ${AppUtils.formatAmount(plan.monthlyAmount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: savingsPlanNotifier.isReminderLoading(plan.id)
                      ? null
                      : () async {
                          // Toggle reminders
                          final success =
                              await savingsPlanNotifier.toggleReminders(
                            plan.id,
                            !plan.remindersEnabled,
                          );

                          if (success) {
                            // Show success message
                            if (mounted) {}
                          } else {
                            // Show error message
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    savingsPlanNotifier.error.isNotEmpty
                                        ? savingsPlanNotifier.error
                                        : 'Failed to update reminders',
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        },
                  icon: savingsPlanNotifier.isReminderLoading(plan.id)
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              plan.remindersEnabled
                                  ? Colors.red.shade600
                                  : Colors.green.shade600,
                            ),
                          ),
                        )
                      : Icon(
                          plan.remindersEnabled
                              ? Icons.notifications_off
                              : Icons.notifications_active,
                          size: 18,
                        ),
                  label: Text(
                    savingsPlanNotifier.isReminderLoading(plan.id)
                        ? 'Updating...'
                        : plan.remindersEnabled
                            ? 'Disable Reminders'
                            : 'Enable Reminders',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: plan.remindersEnabled
                        ? Colors.red.shade600
                        : Colors.green.shade600,
                    side: BorderSide(
                      color: plan.remindersEnabled
                          ? Colors.red.shade300
                          : Colors.green.shade300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
