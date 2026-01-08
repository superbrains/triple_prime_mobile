import 'package:triple_prime_mobile/core/utils/app_utils.dart';

class FoodPackResponse {
  final bool success;
  final String message;
  final List<FoodPack> data;
  final List<String> errors;
  final String timestamp;

  FoodPackResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.errors,
    required this.timestamp,
  });

  factory FoodPackResponse.fromJson(Map<String, dynamic> json) {
    return FoodPackResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => FoodPack.fromJson(item))
              .toList() ??
          [],
      errors: (json['errors'] as List<dynamic>?)
              ?.map((error) => error.toString())
              .toList() ??
          [],
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class FoodPack {
  final int id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final double savings;
  final bool available;
  final bool featured;
  final String imageUrl;
  final int inventory;
  final int duration;
  final String category;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;
  final List<FoodPackItem> items;

  FoodPack({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.savings,
    required this.available,
    required this.featured,
    required this.imageUrl,
    required this.inventory,
    required this.duration,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.items,
  });

  factory FoodPack.fromJson(Map<String, dynamic> json) {
    return FoodPack(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      savings: (json['savings'] ?? 0).toDouble(),
      available: json['available'] ?? false,
      featured: json['featured'] ?? false,
      imageUrl: json['imageUrl'] ?? '',
      inventory: json['inventory'] ?? 0,
      duration: json['duration'] ?? 0,
      category: json['category'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => FoodPackItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'savings': savings,
      'available': available,
      'featured': featured,
      'imageUrl': imageUrl,
      'inventory': inventory,
      'duration': duration,
      'category': category,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // Helper methods
  String get formattedPrice => AppUtils.formatAmount(price);
  String get formattedOriginalPrice => AppUtils.formatAmount(originalPrice);
  String get formattedSavings => AppUtils.formatAmount(savings);
  String get dailyPayment => AppUtils.formatAmount(price / (duration * 30));
  String get durationText => '$duration months';
}

class FoodPackItem {
  final int id;
  final int foodPackId;
  final String item;
  final String createdAt;

  FoodPackItem({
    required this.id,
    required this.foodPackId,
    required this.item,
    required this.createdAt,
  });

  factory FoodPackItem.fromJson(Map<String, dynamic> json) {
    return FoodPackItem(
      id: json['id'] ?? 0,
      foodPackId: json['foodPackId'] ?? 0,
      item: json['item'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodPackId': foodPackId,
      'item': item,
      'createdAt': createdAt,
    };
  }
}

class FoodPackPricing {
  final int id;
  final int foodPackId;
  final int durationMonths;
  final double interestRate;
  final double totalPrice;
  final double dailyPaymentAmount;
  final String createdAt;
  final String? updatedAt;

  FoodPackPricing({
    required this.id,
    required this.foodPackId,
    required this.durationMonths,
    required this.interestRate,
    required this.totalPrice,
    required this.dailyPaymentAmount,
    required this.createdAt,
    this.updatedAt,
  });

  factory FoodPackPricing.fromJson(Map<String, dynamic> json) {
    return FoodPackPricing(
      id: json['id'] ?? 0,
      foodPackId: json['foodPackId'] ?? 0,
      durationMonths: json['durationMonths'] ?? 0,
      interestRate: (json['interestRate'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      dailyPaymentAmount: (json['dailyPaymentAmount'] ?? 0).toDouble(),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodPackId': foodPackId,
      'durationMonths': durationMonths,
      'interestRate': interestRate,
      'totalPrice': totalPrice,
      'dailyPaymentAmount': dailyPaymentAmount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Helper methods
  String get formattedTotalPrice => AppUtils.formatAmount(totalPrice);
  String get formattedDailyPayment => AppUtils.formatAmount(dailyPaymentAmount);
  String get interestRatePercentage => '${(interestRate * 100).toStringAsFixed(2)}%';
  String get durationText => '$durationMonths ${durationMonths == 1 ? "Month" : "Months"}';
  int get totalDays => durationMonths * 30;
}

class FoodPackWithPricing {
  final int id;
  final String name;
  final String description;
  final double basePrice;
  final double originalPrice;
  final double savings;
  final bool available;
  final bool featured;
  final String imageUrl;
  final int inventory;
  final String category;
  final List<FoodPackPricing> pricings;

  FoodPackWithPricing({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.originalPrice,
    required this.savings,
    required this.available,
    required this.featured,
    required this.imageUrl,
    required this.inventory,
    required this.category,
    required this.pricings,
  });

  factory FoodPackWithPricing.fromJson(Map<String, dynamic> json) {
    return FoodPackWithPricing(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      savings: (json['savings'] ?? 0).toDouble(),
      available: json['available'] ?? false,
      featured: json['featured'] ?? false,
      imageUrl: json['imageUrl'] ?? '',
      inventory: json['inventory'] ?? 0,
      category: json['category'] ?? '',
      pricings: (json['pricings'] as List<dynamic>?)
              ?.map((item) => FoodPackPricing.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'originalPrice': originalPrice,
      'savings': savings,
      'available': available,
      'featured': featured,
      'imageUrl': imageUrl,
      'inventory': inventory,
      'category': category,
      'pricings': pricings.map((p) => p.toJson()).toList(),
    };
  }

  // Helper methods
  String get formattedBasePrice => AppUtils.formatAmount(basePrice);
  String get formattedOriginalPrice => AppUtils.formatAmount(originalPrice);
  String get formattedSavings => AppUtils.formatAmount(savings);
}
