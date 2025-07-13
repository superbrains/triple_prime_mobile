import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_pack.freezed.dart';
part 'food_pack.g.dart';

@freezed
class FoodPack with _$FoodPack {
  const factory FoodPack({
    required String id,
    required String name,
    required String description,
    required double price,
    required double dailyAmount,
    required int durationInMonths,
    required List<FoodPackItem> items,
    String? imageUrl,
    String? category,
    bool? isFeatured,
    @Default(false) bool isPopular,
  }) = _FoodPack;

  factory FoodPack.fromJson(Map<String, dynamic> json) =>
      _$FoodPackFromJson(json);
}

@freezed
class FoodPackItem with _$FoodPackItem {
  const factory FoodPackItem({
    required String name,
    required String quantity,
    String? description,
    String? imageUrl,
  }) = _FoodPackItem;

  factory FoodPackItem.fromJson(Map<String, dynamic> json) =>
      _$FoodPackItemFromJson(json);
} 