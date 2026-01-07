import 'package:freezed_annotation/freezed_annotation.dart';
part 'add_category_model.g.dart';
part 'add_category_model.freezed.dart';

@freezed
class AddCategoryModel with _$AddCategoryModel{
  const AddCategoryModel._();
  
  const factory AddCategoryModel({
    required String id,
    required String category,
    required String image,
    required String date,
    required int key,
  })=_AddCategoryModel;

  factory AddCategoryModel.fromJson(Map<String, dynamic> json)=>_$AddCategoryModelFromJson(json);
}