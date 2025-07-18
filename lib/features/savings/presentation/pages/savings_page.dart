import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:triple_prime_mobile/core/utils/app_utils.dart';
import 'package:triple_prime_mobile/features/savings/notifiers/savings_plan_notifier.dart';
import 'package:triple_prime_mobile/features/savings/presentation/pages/make_payment_page.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  @override
  void initState() {
    super.initState();
    // Fetch savings plans when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavingsPlanNotifier>().fetchSavingsPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Consumer<SavingsPlanNotifier>(
          builder: (context, savingsPlanNotifier, child) {
            if (savingsPlanNotifier.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (savingsPlanNotifier.savingsPlans.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.savings_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No savings plans found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start saving for your food packs!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => savingsPlanNotifier.refreshSavingsPlans(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildSavingsOverview(context, savingsPlanNotifier),
                    const SizedBox(height: 24),
                    _buildPaymentSchedule(context, savingsPlanNotifier),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Your Savings',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildSavingsOverview(
      BuildContext context, SavingsPlanNotifier notifier) {
    final activePlans = notifier.activePlans;
    if (activePlans.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No active savings plans',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
        ),
      );
    }

    final plan = activePlans.first; // Show first active plan
    final progress = plan.progressPercentage;
    final savedAmount = plan.amountPaid;
    final totalAmount = plan.totalAmount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    plan.foodPackName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    plan.status,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildProgressIndicator(
                context, progress, savedAmount, totalAmount),
            const SizedBox(height: 24),
            _buildSavingsStats(context, plan),
            const SizedBox(height: 20),
            _buildPayButton(context, plan),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildProgressIndicator(BuildContext context, double progress,
      double savedAmount, double totalAmount) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppUtils.formatAmount(savedAmount)} saved',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            Text(
              '${AppUtils.formatAmount(totalAmount)} goal',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavingsStats(BuildContext context, dynamic plan) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            'Monthly Payment',
            AppUtils.formatAmount(plan.monthlyAmount),
          ),
        ),
        Container(
          height: 40,
          width: 1,
          color: Colors.grey[300],
        ),
        Expanded(
          child: _buildStatItem(
            context,
            'Plan Duration',
            '${plan.duration} Months',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton(BuildContext context, dynamic plan) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MakePaymentPage(savingsPlan: plan),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          'Make Payment',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
        ),
      ),
    );
  }

  Widget _buildPaymentSchedule(
      BuildContext context, SavingsPlanNotifier notifier) {
    final activePlans = notifier.activePlans;
    if (activePlans.isEmpty) {
      return const SizedBox.shrink();
    }

    final plan = activePlans.first;
    final paymentSchedules =
        plan.paymentSchedules.take(5).toList(); // Show first 5 payments

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Schedule',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
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
            final isNext = !isPaid &&
                index == paymentSchedules.indexWhere((s) => !s.isPaid);
            return _buildPaymentItem(context, schedule, isPaid, isNext);
          },
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildPaymentItem(
      BuildContext context, dynamic schedule, bool isPaid, bool isNext) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isPaid
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPaid ? Icons.check : Icons.schedule,
            color: isPaid
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[600],
          ),
        ),
        title: Text(
          schedule.formattedDueDate,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              ),
        ),
        trailing: Text(
          AppUtils.formatAmount(schedule.amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isPaid
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
