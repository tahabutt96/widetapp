import 'package:appwidgetflutter/dashboard/models/add_category_model.dart';

class GetAllCategories {
  final bool success;
  final String message;
  final List<AddCategoryModel> result;
  GetAllCategories({required this.success, required this.result,this.message=""});
}