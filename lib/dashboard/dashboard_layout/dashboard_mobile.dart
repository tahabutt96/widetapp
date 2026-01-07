import 'package:appwidgetflutter/dashboard/home_page_dashboard.dart';
import 'package:flutter/material.dart';

class BuildHomeWidgetMobile extends StatelessWidget {
  const BuildHomeWidgetMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        HomeDashboardScreen(),
      ],
    );
  }
}