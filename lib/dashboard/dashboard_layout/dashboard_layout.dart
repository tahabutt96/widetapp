import 'package:appwidgetflutter/dashboard/dashboard_layout/dahsboard_web.dart';
import 'package:appwidgetflutter/dashboard/dashboard_layout/dashboard_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body: ScreenTypeLayout(
        mobile: const BuildHomeWidgetMobile(),
        desktop: const BuildHomeWidgetWeb(),
        tablet: const BuildHomeWidgetWeb(),
        ),
    );
  }
}






