import 'package:appwidgetflutter/dashboard/add_view_category_layout/category_mobile.dart';
import 'package:appwidgetflutter/dashboard/add_view_category_layout/category_web_layout.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CategoryLayout extends StatelessWidget {
  const CategoryLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return Expanded(
      flex: 8,
      child: ScreenTypeLayout(
        mobile: const CategoryWidgetMobile(),
        desktop: const CategoryWidgetWeb(),
        tablet: const CategoryWidgetWeb(),
      ),
    );
  }
}
