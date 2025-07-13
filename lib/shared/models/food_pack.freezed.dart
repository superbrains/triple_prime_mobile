// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_pack.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FoodPack _$FoodPackFromJson(Map<String, dynamic> json) {
  return _FoodPack.fromJson(json);
}

/// @nodoc
mixin _$FoodPack {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get dailyAmount => throw _privateConstructorUsedError;
  int get durationInMonths => throw _privateConstructorUsedError;
  List<FoodPackItem> get items => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  bool? get isFeatured => throw _privateConstructorUsedError;
  bool get isPopular => throw _privateConstructorUsedError;

  /// Serializes this FoodPack to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodPack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodPackCopyWith<FoodPack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodPackCopyWith<$Res> {
  factory $FoodPackCopyWith(FoodPack value, $Res Function(FoodPack) then) =
      _$FoodPackCopyWithImpl<$Res, FoodPack>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      double price,
      double dailyAmount,
      int durationInMonths,
      List<FoodPackItem> items,
      String? imageUrl,
      String? category,
      bool? isFeatured,
      bool isPopular});
}

/// @nodoc
class _$FoodPackCopyWithImpl<$Res, $Val extends FoodPack>
    implements $FoodPackCopyWith<$Res> {
  _$FoodPackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodPack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? dailyAmount = null,
    Object? durationInMonths = null,
    Object? items = null,
    Object? imageUrl = freezed,
    Object? category = freezed,
    Object? isFeatured = freezed,
    Object? isPopular = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      dailyAmount: null == dailyAmount
          ? _value.dailyAmount
          : dailyAmount // ignore: cast_nullable_to_non_nullable
              as double,
      durationInMonths: null == durationInMonths
          ? _value.durationInMonths
          : durationInMonths // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FoodPackItem>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: freezed == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool?,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodPackImplCopyWith<$Res>
    implements $FoodPackCopyWith<$Res> {
  factory _$$FoodPackImplCopyWith(
          _$FoodPackImpl value, $Res Function(_$FoodPackImpl) then) =
      __$$FoodPackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      double price,
      double dailyAmount,
      int durationInMonths,
      List<FoodPackItem> items,
      String? imageUrl,
      String? category,
      bool? isFeatured,
      bool isPopular});
}

/// @nodoc
class __$$FoodPackImplCopyWithImpl<$Res>
    extends _$FoodPackCopyWithImpl<$Res, _$FoodPackImpl>
    implements _$$FoodPackImplCopyWith<$Res> {
  __$$FoodPackImplCopyWithImpl(
      _$FoodPackImpl _value, $Res Function(_$FoodPackImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodPack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? price = null,
    Object? dailyAmount = null,
    Object? durationInMonths = null,
    Object? items = null,
    Object? imageUrl = freezed,
    Object? category = freezed,
    Object? isFeatured = freezed,
    Object? isPopular = null,
  }) {
    return _then(_$FoodPackImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      dailyAmount: null == dailyAmount
          ? _value.dailyAmount
          : dailyAmount // ignore: cast_nullable_to_non_nullable
              as double,
      durationInMonths: null == durationInMonths
          ? _value.durationInMonths
          : durationInMonths // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<FoodPackItem>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      isFeatured: freezed == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool?,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodPackImpl implements _FoodPack {
  const _$FoodPackImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.dailyAmount,
      required this.durationInMonths,
      required final List<FoodPackItem> items,
      this.imageUrl,
      this.category,
      this.isFeatured,
      this.isPopular = false})
      : _items = items;

  factory _$FoodPackImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodPackImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final double price;
  @override
  final double dailyAmount;
  @override
  final int durationInMonths;
  final List<FoodPackItem> _items;
  @override
  List<FoodPackItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? imageUrl;
  @override
  final String? category;
  @override
  final bool? isFeatured;
  @override
  @JsonKey()
  final bool isPopular;

  @override
  String toString() {
    return 'FoodPack(id: $id, name: $name, description: $description, price: $price, dailyAmount: $dailyAmount, durationInMonths: $durationInMonths, items: $items, imageUrl: $imageUrl, category: $category, isFeatured: $isFeatured, isPopular: $isPopular)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodPackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.dailyAmount, dailyAmount) ||
                other.dailyAmount == dailyAmount) &&
            (identical(other.durationInMonths, durationInMonths) ||
                other.durationInMonths == durationInMonths) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isPopular, isPopular) ||
                other.isPopular == isPopular));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      price,
      dailyAmount,
      durationInMonths,
      const DeepCollectionEquality().hash(_items),
      imageUrl,
      category,
      isFeatured,
      isPopular);

  /// Create a copy of FoodPack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodPackImplCopyWith<_$FoodPackImpl> get copyWith =>
      __$$FoodPackImplCopyWithImpl<_$FoodPackImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodPackImplToJson(
      this,
    );
  }
}

abstract class _FoodPack implements FoodPack {
  const factory _FoodPack(
      {required final String id,
      required final String name,
      required final String description,
      required final double price,
      required final double dailyAmount,
      required final int durationInMonths,
      required final List<FoodPackItem> items,
      final String? imageUrl,
      final String? category,
      final bool? isFeatured,
      final bool isPopular}) = _$FoodPackImpl;

  factory _FoodPack.fromJson(Map<String, dynamic> json) =
      _$FoodPackImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  double get price;
  @override
  double get dailyAmount;
  @override
  int get durationInMonths;
  @override
  List<FoodPackItem> get items;
  @override
  String? get imageUrl;
  @override
  String? get category;
  @override
  bool? get isFeatured;
  @override
  bool get isPopular;

  /// Create a copy of FoodPack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodPackImplCopyWith<_$FoodPackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodPackItem _$FoodPackItemFromJson(Map<String, dynamic> json) {
  return _FoodPackItem.fromJson(json);
}

/// @nodoc
mixin _$FoodPackItem {
  String get name => throw _privateConstructorUsedError;
  String get quantity => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Serializes this FoodPackItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodPackItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodPackItemCopyWith<FoodPackItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodPackItemCopyWith<$Res> {
  factory $FoodPackItemCopyWith(
          FoodPackItem value, $Res Function(FoodPackItem) then) =
      _$FoodPackItemCopyWithImpl<$Res, FoodPackItem>;
  @useResult
  $Res call(
      {String name, String quantity, String? description, String? imageUrl});
}

/// @nodoc
class _$FoodPackItemCopyWithImpl<$Res, $Val extends FoodPackItem>
    implements $FoodPackItemCopyWith<$Res> {
  _$FoodPackItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodPackItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodPackItemImplCopyWith<$Res>
    implements $FoodPackItemCopyWith<$Res> {
  factory _$$FoodPackItemImplCopyWith(
          _$FoodPackItemImpl value, $Res Function(_$FoodPackItemImpl) then) =
      __$$FoodPackItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, String quantity, String? description, String? imageUrl});
}

/// @nodoc
class __$$FoodPackItemImplCopyWithImpl<$Res>
    extends _$FoodPackItemCopyWithImpl<$Res, _$FoodPackItemImpl>
    implements _$$FoodPackItemImplCopyWith<$Res> {
  __$$FoodPackItemImplCopyWithImpl(
      _$FoodPackItemImpl _value, $Res Function(_$FoodPackItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of FoodPackItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? description = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_$FoodPackItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodPackItemImpl implements _FoodPackItem {
  const _$FoodPackItemImpl(
      {required this.name,
      required this.quantity,
      this.description,
      this.imageUrl});

  factory _$FoodPackItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodPackItemImplFromJson(json);

  @override
  final String name;
  @override
  final String quantity;
  @override
  final String? description;
  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'FoodPackItem(name: $name, quantity: $quantity, description: $description, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodPackItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, quantity, description, imageUrl);

  /// Create a copy of FoodPackItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodPackItemImplCopyWith<_$FoodPackItemImpl> get copyWith =>
      __$$FoodPackItemImplCopyWithImpl<_$FoodPackItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodPackItemImplToJson(
      this,
    );
  }
}

abstract class _FoodPackItem implements FoodPackItem {
  const factory _FoodPackItem(
      {required final String name,
      required final String quantity,
      final String? description,
      final String? imageUrl}) = _$FoodPackItemImpl;

  factory _FoodPackItem.fromJson(Map<String, dynamic> json) =
      _$FoodPackItemImpl.fromJson;

  @override
  String get name;
  @override
  String get quantity;
  @override
  String? get description;
  @override
  String? get imageUrl;

  /// Create a copy of FoodPackItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodPackItemImplCopyWith<_$FoodPackItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
