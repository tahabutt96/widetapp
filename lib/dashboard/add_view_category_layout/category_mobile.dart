import 'package:appwidgetflutter/dashboard/add_category_screen.dart';
import 'package:appwidgetflutter/dashboard/get_all_categories.dart';
import 'package:flutter/material.dart';

class CategoryWidgetMobile extends StatelessWidget {
  const CategoryWidgetMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        AddCategory(),
        SizedBox(
          height: 10,
        ),
        Expanded(child: GetAllCategoryScreen()),
      ],
    );
  }
}