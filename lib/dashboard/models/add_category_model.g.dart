// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AddCategoryModel _$$_AddCategoryModelFromJson(Map<String, dynamic> json) =>
    _$_AddCategoryModel(
      id: json['id'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      date: json['date'] as String,
      key: json['key'] as int,
    );

Map<String, dynamic> _$$_AddCategoryModelToJson(_$_AddCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'image': instance.image,
      'date': instance.date,
      'key': instance.key,
    };
