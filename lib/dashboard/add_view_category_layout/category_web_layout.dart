import 'package:appwidgetflutter/dashboard/add_category_screen.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/custom_app_bar.dart';
import 'package:appwidgetflutter/dashboard/get_all_categories.dart';
import 'package:flutter/material.dart';

class CategoryWidgetWeb extends StatelessWidget {
  const CategoryWidgetWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 7,
            child:AddCategory(),
          ),
          Expanded(
            flex: 3,
            child: GetAllCategoryScreen(),
          ),
        ], 
      ),
    );
  }
}