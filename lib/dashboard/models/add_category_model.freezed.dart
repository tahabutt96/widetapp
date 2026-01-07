// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AddCategoryModel _$AddCategoryModelFromJson(Map<String, dynamic> json) {
  return _AddCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$AddCategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  int get key => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddCategoryModelCopyWith<AddCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddCategoryModelCopyWith<$Res> {
  factory $AddCategoryModelCopyWith(
          AddCategoryModel value, $Res Function(AddCategoryModel) then) =
      _$AddCategoryModelCopyWithImpl<$Res, AddCategoryModel>;
  @useResult
  $Res call({String id, String category, String image, String date, int key});
}

/// @nodoc
class _$AddCategoryModelCopyWithImpl<$Res, $Val extends AddCategoryModel>
    implements $AddCategoryModelCopyWith<$Res> {
  _$AddCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? image = null,
    Object? date = null,
    Object? key = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AddCategoryModelCopyWith<$Res>
    implements $AddCategoryModelCopyWith<$Res> {
  factory _$$_AddCategoryModelCopyWith(
          _$_AddCategoryModel value, $Res Function(_$_AddCategoryModel) then) =
      __$$_AddCategoryModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String category, String image, String date, int key});
}

/// @nodoc
class __$$_AddCategoryModelCopyWithImpl<$Res>
    extends _$AddCategoryModelCopyWithImpl<$Res, _$_AddCategoryModel>
    implements _$$_AddCategoryModelCopyWith<$Res> {
  __$$_AddCategoryModelCopyWithImpl(
      _$_AddCategoryModel _value, $Res Function(_$_AddCategoryModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? category = null,
    Object? image = null,
    Object? date = null,
    Object? key = null,
  }) {
    return _then(_$_AddCategoryModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AddCategoryModel extends _AddCategoryModel {
  const _$_AddCategoryModel(
      {required this.id,
      required this.category,
      required this.image,
      required this.date,
      required this.key})
      : super._();

  factory _$_AddCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$$_AddCategoryModelFromJson(json);

  @override
  final String id;
  @override
  final String category;
  @override
  final String image;
  @override
  final String date;
  @override
  final int key;

  @override
  String toString() {
    return 'AddCategoryModel(id: $id, category: $category, image: $image, date: $date, key: $key)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AddCategoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.key, key) || other.key == key));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, category, image, date, key);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AddCategoryModelCopyWith<_$_AddCategoryModel> get copyWith =>
      __$$_AddCategoryModelCopyWithImpl<_$_AddCategoryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AddCategoryModelToJson(
      this,
    );
  }
}

abstract class _AddCategoryModel extends AddCategoryModel {
  const factory _AddCategoryModel(
      {required final String id,
      required final String category,
      required final String image,
      required final String date,
      required final int key}) = _$_AddCategoryModel;
  const _AddCategoryModel._() : super._();

  factory _AddCategoryModel.fromJson(Map<String, dynamic> json) =
      _$_AddCategoryModel.fromJson;

  @override
  String get id;
  @override
  String get category;
  @override
  String get image;
  @override
  String get date;
  @override
  int get key;
  @override
  @JsonKey(ignore: true)
  _$$_AddCategoryModelCopyWith<_$_AddCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}
