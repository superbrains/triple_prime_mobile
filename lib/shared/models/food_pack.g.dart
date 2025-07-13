// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodPackImpl _$$FoodPackImplFromJson(Map<String, dynamic> json) =>
    _$FoodPackImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      dailyAmount: (json['dailyAmount'] as num).toDouble(),
      durationInMonths: (json['durationInMonths'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => FoodPackItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
      isFeatured: json['isFeatured'] as bool?,
      isPopular: json['isPopular'] as bool? ?? false,
    );

Map<String, dynamic> _$$FoodPackImplToJson(_$FoodPackImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'dailyAmount': instance.dailyAmount,
      'durationInMonths': instance.durationInMonths,
      'items': instance.items,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
      'isFeatured': instance.isFeatured,
      'isPopular': instance.isPopular,
    };

_$FoodPackItemImpl _$$FoodPackItemImplFromJson(Map<String, dynamic> json) =>
    _$FoodPackItemImpl(
      name: json['name'] as String,
      quantity: json['quantity'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$FoodPackItemImplToJson(_$FoodPackItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
    };
