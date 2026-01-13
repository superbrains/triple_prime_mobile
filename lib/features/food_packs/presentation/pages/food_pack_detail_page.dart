// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:triple_prime_mobile/core/utils/app_utils.dart';
import 'package:triple_prime_mobile/shared/models/food_pack_models.dart';
import 'package:triple_prime_mobile/features/food_packs/notifiers/food_pack_notifier.dart';

import 'package:triple_prime_mobile/core/services/env_service.dart';

class FoodPackDetailPage extends StatefulWidget {
  final FoodPack foodPack;

  const FoodPackDetailPage({
    super.key,
    required this.foodPack,
  });

  @override
  State<FoodPackDetailPage> createState() => _FoodPackDetailPageState();
}

class _FoodPackDetailPageState extends State<FoodPackDetailPage> {
  @override
  void initState() {
    super.initState();
    // Load pricing tiers when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = Provider.of<FoodPackNotifier>(context, listen: false);
      notifier.fetchPricingTiers(widget.foodPack.id, widget.foodPack.price);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodPackNotifier>(
      builder: (context, notifier, child) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          body: Column(
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
                      _buildFoodPackDetailsCard(notifier),
                      const SizedBox(height: 20),
                      _buildFoodPackContentsCard(),
                      const SizedBox(height: 20),
                      _buildDurationSelectionCard(notifier),
                      const SizedBox(height: 20),
                      _buildPaymentScheduleCard(notifier),
                      const SizedBox(height: 20),
                      _buildPaymentPreferenceCard(notifier),
                      const SizedBox(height: 16),
                      _buildImportantNote(notifier),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              _buildActionButtons(notifier),
            ],
          ),
        );
      },
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Food Pack Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 20,
                    ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'See what\'s included and set up your savings plan',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodPackDetailsCard(FoodPackNotifier notifier) {
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.foodPack.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.foodPack.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.primaryColor.withValues(alpha: 0.1),
                                  AppTheme.primaryColor.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.restaurant,
                              color: AppTheme.primaryColor,
                              size: 32,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.primaryColor.withValues(alpha: 0.1),
                                  AppTheme.primaryColor.withValues(alpha: 0.05),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.restaurant,
                              color: AppTheme.primaryColor,
                              size: 32,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryColor.withValues(alpha: 0.1),
                                AppTheme.primaryColor.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.restaurant,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.foodPack.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.foodPack.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Amount',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.foodPack.formattedPrice,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 16,
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
                                'Duration',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.foodPack.durationText,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 16,
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
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Frequency',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: notifier.selectedPaymentFrequency,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: AppTheme.primaryColor),
                    items: notifier.paymentFrequencies.map((String frequency) {
                      return DropdownMenuItem<String>(
                        value: frequency,
                        child: Text(
                          frequency,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        notifier.setPaymentFrequency(newValue);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Amount per ${notifier.selectedPaymentFrequency.toLowerCase()}: ${notifier.calculatePaymentAmount(widget.foodPack)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodPackContentsCard() {
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
            children: [
              Text(
                'Food Pack Contents',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.foodPack.items.length} items',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3.5,
            ),
            itemCount: widget.foodPack.items.length,
            itemBuilder: (context, index) {
              final item = widget.foodPack.items[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.item,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentScheduleCard(FoodPackNotifier notifier) {
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
          ...notifier
              .generatePaymentSchedule(widget.foodPack)
              .map((payment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            payment['date']!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                          ),
                        ),
                        Text(
                          payment['amount']!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPaymentPreferenceCard(FoodPackNotifier notifier) {
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
                'Your card will be charged automatically on the due date. No manual action required.',
            value: 'Automatic Payment',
            groupValue: notifier.selectedPaymentMethod,
            onChanged: (value) {
              notifier.setPaymentMethod(value!);
            },
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(
            title: 'Manual Payment',
            description:
                'You\'ll need to make the payment manually each month. We\'ll send you reminders.',
            value: 'Manual Payment',
            groupValue: notifier.selectedPaymentMethod,
            onChanged: (value) {
              notifier.setPaymentMethod(value!);
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontSize: 14,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImportantNote(FoodPackNotifier notifier) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.primaryColor,
            size: 20,
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
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  notifier.selectedPaymentMethod == 'Manual Payment'
                      ? 'You\'ll need to make the payment manually each month. We\'ll send you reminders before each due date.'
                      : 'Your card will be charged automatically on the due date. No manual action required.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(FoodPackNotifier notifier) {
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
              child: Text(
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
              onPressed: () => _handlePayment(notifier),
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

  /// Build duration selection card
  Widget _buildDurationSelectionCard(FoodPackNotifier notifier) {
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
            'Select Payment Duration',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: 12),
          notifier.isLoadingPricing
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                )
              : notifier.hasPricingTiers
                  ? Column(
                      children: notifier.pricingTiers.map((pricing) {
                        final isSelected = notifier.selectedDuration == pricing.durationMonths;
                        return GestureDetector(
                          onTap: () => notifier.setSelectedDuration(pricing.durationMonths),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? AppTheme.primaryColor : Colors.grey[400]!,
                                      width: 2,
                                    ),
                                    color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? Icon(Icons.check, size: 12, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            pricing.durationText,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: isSelected ? AppTheme.primaryColor : Colors.black87,
                                            ),
                                          ),
                                          if (pricing.interestRate > 0) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.orange[50],
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                '+${pricing.interestRatePercentage}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.orange[800],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${pricing.formattedDailyPayment}/day (${pricing.totalDays} days)',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      pricing.formattedTotalPrice,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isSelected ? AppTheme.primaryColor : Colors.black87,
                                      ),
                                    ),
                                    if (pricing.interestRate > 0)
                                      Text(
                                        'Base: ${AppUtils.formatAmount(widget.foodPack.price)}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber[800], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Using base price of ${widget.foodPack.formattedPrice} for ${widget.foodPack.duration} months',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.amber[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          if (notifier.hasPricingTiers && notifier.selectedPricing != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Base Price:', AppUtils.formatAmount(widget.foodPack.price)),
                  if (notifier.getInterestRate() > 0) ...[
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Interest (${(notifier.getInterestRate() * 100).toStringAsFixed(2)}%):',
                      '+${AppUtils.formatAmount(notifier.getTotalPrice(widget.foodPack.price) - widget.foodPack.price)}',
                      isHighlighted: true,
                    ),
                  ],
                  const Divider(height: 16),
                  _buildSummaryRow(
                    'Total Price:',
                    AppUtils.formatAmount(notifier.getTotalPrice(widget.foodPack.price)),
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: isHighlighted ? Colors.orange[800] : (isBold ? Colors.black87 : Colors.grey[700]),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Handle payment processing
  void _handlePayment(FoodPackNotifier notifier) {
    // Process payment directly using user's email from storage
    notifier.processPayment(
      context: context,
      foodPack: widget.foodPack,
      secretKey: EnvService.paystackSecretKey,
    );
  }
}
