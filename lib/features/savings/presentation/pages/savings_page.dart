import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildSavingsOverview(context),
              const SizedBox(height: 24),
              _buildPaymentSchedule(context),
            ],
          ),
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

  Widget _buildSavingsOverview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Food Pack #1',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Active',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildProgressIndicator(context),
            const SizedBox(height: 24),
            _buildSavingsStats(context),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: 0.4,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₦48,000 saved',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            Text(
              '₦120,000 goal',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavingsStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            'Monthly Payment',
            '₦30,000',
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
            '4 Months',
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

  Widget _buildPaymentSchedule(BuildContext context) {
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
          itemCount: 5,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final isPaid = index < 2;
            final isNext = index == 2;
            return _buildPaymentItem(context, isPaid, isNext);
          },
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildPaymentItem(BuildContext context, bool isPaid, bool isNext) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isPaid
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
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
          'June ${isPaid ? (1 + isPaid.hashCode) : (15 + isPaid.hashCode)}, 2024',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              ),
        ),
        trailing: Text(
          '₦1,000',
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