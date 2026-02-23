import 'package:triple_prime_mobile/shared/models/auth_models.dart';
import 'package:triple_prime_mobile/shared/models/food_pack_models.dart';
import 'package:triple_prime_mobile/core/utils/app_utils.dart';

class SavingsPlanResponse {
  final bool success;
  final String message;
  final List<SavingsPlan> data;
  final int totalCount;
  final int pageNumber;
  final int pageSize;

  SavingsPlanResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  factory SavingsPlanResponse.fromJson(Map<String, dynamic> json) {
    return SavingsPlanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => SavingsPlan.fromJson(item))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }
}

class SavingsPlan {
  final int id;
  final String userId;
  final int foodPackId;
  final double totalAmount;
  final double monthlyAmount;
  final double amountPaid;
  final int duration;
  final String status;
  final DateTime startDate;
  final DateTime? lastPaymentDate;
  final String paymentPreference;
  final String paymentFrequency;
  final String? paymentMethodId;
  final String planCode;
  final String subscriptionCode;
  final bool remindersEnabled;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final String updatedBy;
  final UserData? user;
  final FoodPack? foodPack;
  final dynamic paymentMethod;
  final List<PaymentSchedule> paymentSchedules;

  SavingsPlan({
    required this.id,
    required this.userId,
    required this.foodPackId,
    required this.totalAmount,
    required this.monthlyAmount,
    required this.amountPaid,
    required this.duration,
    required this.status,
    required this.startDate,
    this.lastPaymentDate,
    required this.paymentPreference,
    required this.paymentFrequency,
    this.paymentMethodId,
    required this.planCode,
    required this.subscriptionCode,
    required this.remindersEnabled,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    this.user,
    this.foodPack,
    this.paymentMethod,
    required this.paymentSchedules,
  });

  factory SavingsPlan.fromJson(Map<String, dynamic> json) {
    return SavingsPlan(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      foodPackId: json['foodPackId'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      monthlyAmount: (json['monthlyAmount'] ?? 0).toDouble(),
      amountPaid: (json['amountPaid'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      status: json['status'] ?? '',
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      lastPaymentDate: json['lastPaymentDate'] != null
          ? DateTime.tryParse(json['lastPaymentDate'].toString())
          : null,
      paymentPreference: json['paymentPreference'] ?? '',
      paymentFrequency: json['paymentFrequency'] ?? '',
      paymentMethodId: json['paymentMethodId'],
      planCode: json['planCode'] ?? '',
      subscriptionCode: json['subscriptionCode'] ?? '',
      remindersEnabled: json['remindersEnabled'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      user: json['user'] != null
          ? UserData.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      foodPack: json['foodPack'] != null
          ? FoodPack.fromJson(json['foodPack'] as Map<String, dynamic>)
          : null,
      paymentMethod: json['paymentMethod'],
      paymentSchedules: (json['paymentSchedules'] as List<dynamic>?)
              ?.map((item) => PaymentSchedule.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'foodPackId': foodPackId,
      'totalAmount': totalAmount,
      'monthlyAmount': monthlyAmount,
      'amountPaid': amountPaid,
      'duration': duration,
      'status': status,
      'startDate': startDate.toIso8601String(),
      if (lastPaymentDate != null)
        'lastPaymentDate': lastPaymentDate!.toIso8601String(),
      'paymentPreference': paymentPreference,
      'paymentFrequency': paymentFrequency,
      if (paymentMethodId != null) 'paymentMethodId': paymentMethodId,
      'planCode': planCode,
      'subscriptionCode': subscriptionCode,
      'remindersEnabled': remindersEnabled,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      if (user != null) 'user': user!.toJson(),
      if (foodPack != null) 'foodPack': foodPack!.toJson(),
      'paymentMethod': paymentMethod,
      'paymentSchedules':
          paymentSchedules.map((item) => item.toJson()).toList(),
    };
  }

  // Helper methods
  double get progressPercentage =>
      totalAmount > 0 ? (amountPaid / totalAmount) : 0;
  double get remainingAmount => totalAmount - amountPaid;
  bool get isActive => status.toLowerCase() == 'active';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  String get formattedTotalAmount => AppUtils.formatAmount(totalAmount);
  String get formattedAmountPaid => AppUtils.formatAmount(amountPaid);
  String get formattedMonthlyAmount => AppUtils.formatAmount(monthlyAmount);
  String get formattedRemainingAmount => AppUtils.formatAmount(remainingAmount);
  String get progressText =>
      '${(progressPercentage * 100).toStringAsFixed(0)}%';

  // Get food pack name from nested object or fallback
  String get foodPackName => foodPack?.name ?? 'Unknown Food Pack';
}

class Payment {
  final int id;
  final int savingsPlanId;
  final double amount;
  final String status;
  final String paymentMethod;
  final String? transactionReference;
  final DateTime paymentDate;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.savingsPlanId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    this.transactionReference,
    required this.paymentDate,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? 0,
      savingsPlanId: json['savingsPlanId'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      transactionReference: json['transactionReference'],
      paymentDate: DateTime.parse(
          json['paymentDate'] ?? DateTime.now().toIso8601String()),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'savingsPlanId': savingsPlanId,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      if (transactionReference != null)
        'transactionReference': transactionReference,
      'paymentDate': paymentDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper methods
  bool get isSuccessful => status.toLowerCase() == 'successful';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isFailed => status.toLowerCase() == 'failed';
  String get formattedAmount => AppUtils.formatAmount(amount);
}

class PaymentSchedule {
  final int id;
  final int savingsPlanId;
  final DateTime dueDate;
  final double amount;
  final double accruedInterest;
  final double totalDue;
  final String status;
  final String paymentReference;
  final DateTime? paidAt;
  final bool isOverdue;
  final int daysOverdue;
  final DateTime? interestAccrualStartDate;
  final String createdBy;
  final DateTime createdAt;
  final String updatedBy;
  final DateTime updatedAt;

  PaymentSchedule({
    required this.id,
    required this.savingsPlanId,
    required this.dueDate,
    required this.amount,
    this.accruedInterest = 0.0,
    double? totalDue,
    required this.status,
    required this.paymentReference,
    this.paidAt,
    this.isOverdue = false,
    this.daysOverdue = 0,
    this.interestAccrualStartDate,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  }) : totalDue = totalDue ?? (amount + accruedInterest);

  factory PaymentSchedule.fromJson(Map<String, dynamic> json) {
    return PaymentSchedule(
      id: json['id'] ?? 0,
      savingsPlanId: json['savingsPlanId'] ?? 0,
      dueDate: DateTime.tryParse(json['dueDate']?.toString() ?? '') ??
          DateTime.now(),
      amount: (json['amount'] ?? 0).toDouble(),
      accruedInterest: (json['accruedInterest'] ?? 0).toDouble(),
      totalDue: (json['totalDue'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      paymentReference: json['paymentReference'] ?? '',
      paidAt: json['paidAt'] != null
          ? DateTime.tryParse(json['paidAt'].toString())
          : null,
      isOverdue: json['isOverdue'] ?? false,
      daysOverdue: json['daysOverdue'] ?? 0,
      interestAccrualStartDate: json['interestAccrualStartDate'] != null
          ? DateTime.tryParse(json['interestAccrualStartDate'].toString())
          : null,
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedBy: json['updatedBy'] ?? '',
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'savingsPlanId': savingsPlanId,
      'dueDate': dueDate.toIso8601String(),
      'amount': amount,
      'accruedInterest': accruedInterest,
      'totalDue': totalDue,
      'status': status,
      'paymentReference': paymentReference,
      if (paidAt != null) 'paidAt': paidAt!.toIso8601String(),
      'isOverdue': isOverdue,
      'daysOverdue': daysOverdue,
      if (interestAccrualStartDate != null)
        'interestAccrualStartDate': interestAccrualStartDate!.toIso8601String(),
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper methods
  bool get isPaid => status.toLowerCase() == 'paid';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get hasInterest => accruedInterest > 0;
  String get formattedAmount => AppUtils.formatAmount(amount);
  String get formattedAccruedInterest => AppUtils.formatAmount(accruedInterest);
  String get formattedTotalDue => AppUtils.formatAmount(totalDue);
  String get formattedDueDate =>
      '${dueDate.day}/${dueDate.month}/${dueDate.year}';
}
