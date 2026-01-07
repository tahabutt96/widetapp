// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_aya_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AddAyaModel _$AddAyaModelFromJson(Map<String, dynamic> json) {
  return _AddAyaModel.fromJson(json);
}

/// @nodoc
mixin _$AddAyaModel {
  @HiveField(0)
  String? get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get catId => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get aya => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get date => throw _privateConstructorUsedError;
  @HiveField(4)
  int? get key => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddAyaModelCopyWith<AddAyaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddAyaModelCopyWith<$Res> {
  factory $AddAyaModelCopyWith(
          AddAyaModel value, $Res Function(AddAyaModel) then) =
      _$AddAyaModelCopyWithImpl<$Res, AddAyaModel>;
  @useResult
  $Res call(
      {@HiveField(0) String? id,
      @HiveField(1) String? catId,
      @HiveField(2) String? aya,
      @HiveField(3) String? date,
      @HiveField(4) int? key});
}

/// @nodoc
class _$AddAyaModelCopyWithImpl<$Res, $Val extends AddAyaModel>
    implements $AddAyaModelCopyWith<$Res> {
  _$AddAyaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? catId = freezed,
    Object? aya = freezed,
    Object? date = freezed,
    Object? key = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      catId: freezed == catId
          ? _value.catId
          : catId // ignore: cast_nullable_to_non_nullable
              as String?,
      aya: freezed == aya
          ? _value.aya
          : aya // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AddAyaModelCopyWith<$Res>
    implements $AddAyaModelCopyWith<$Res> {
  factory _$$_AddAyaModelCopyWith(
          _$_AddAyaModel value, $Res Function(_$_AddAyaModel) then) =
      __$$_AddAyaModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? id,
      @HiveField(1) String? catId,
      @HiveField(2) String? aya,
      @HiveField(3) String? date,
      @HiveField(4) int? key});
}

/// @nodoc
class __$$_AddAyaModelCopyWithImpl<$Res>
    extends _$AddAyaModelCopyWithImpl<$Res, _$_AddAyaModel>
    implements _$$_AddAyaModelCopyWith<$Res> {
  __$$_AddAyaModelCopyWithImpl(
      _$_AddAyaModel _value, $Res Function(_$_AddAyaModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? catId = freezed,
    Object? aya = freezed,
    Object? date = freezed,
    Object? key = freezed,
  }) {
    return _then(_$_AddAyaModel(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      catId: freezed == catId
          ? _value.catId
          : catId // ignore: cast_nullable_to_non_nullable
              as String?,
      aya: freezed == aya
          ? _value.aya
          : aya // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 0, adapterName: 'AddAyaAdaptor')
class _$_AddAyaModel implements _AddAyaModel {
  const _$_AddAyaModel(
      {@HiveField(0) this.id,
      @HiveField(1) this.catId,
      @HiveField(2) this.aya,
      @HiveField(3) this.date,
      @HiveField(4) this.key});

  factory _$_AddAyaModel.fromJson(Map<String, dynamic> json) =>
      _$$_AddAyaModelFromJson(json);

  @override
  @HiveField(0)
  final String? id;
  @override
  @HiveField(1)
  final String? catId;
  @override
  @HiveField(2)
  final String? aya;
  @override
  @HiveField(3)
  final String? date;
  @override
  @HiveField(4)
  final int? key;

  @override
  String toString() {
    return 'AddAyaModel(id: $id, catId: $catId, aya: $aya, date: $date, key: $key)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AddAyaModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.catId, catId) || other.catId == catId) &&
            (identical(other.aya, aya) || other.aya == aya) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.key, key) || other.key == key));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, catId, aya, date, key);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AddAyaModelCopyWith<_$_AddAyaModel> get copyWith =>
      __$$_AddAyaModelCopyWithImpl<_$_AddAyaModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AddAyaModelToJson(
      this,
    );
  }
}

abstract class _AddAyaModel implements AddAyaModel {
  const factory _AddAyaModel(
      {@HiveField(0) final String? id,
      @HiveField(1) final String? catId,
      @HiveField(2) final String? aya,
      @HiveField(3) final String? date,
      @HiveField(4) final int? key}) = _$_AddAyaModel;

  factory _AddAyaModel.fromJson(Map<String, dynamic> json) =
      _$_AddAyaModel.fromJson;

  @override
  @HiveField(0)
  String? get id;
  @override
  @HiveField(1)
  String? get catId;
  @override
  @HiveField(2)
  String? get aya;
  @override
  @HiveField(3)
  String? get date;
  @override
  @HiveField(4)
  int? get key;
  @override
  @JsonKey(ignore: true)
  _$$_AddAyaModelCopyWith<_$_AddAyaModel> get copyWith =>
      throw _privateConstructorUsedError;
}
