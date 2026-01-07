import 'package:appwidgetflutter/dashboard/dashboard_common/dashboard_drawer.dart';
import 'package:appwidgetflutter/dashboard/home_page_dashboard.dart';
import 'package:appwidgetflutter/dashboard/provider/drawer_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildHomeWidgetWeb extends StatelessWidget {
  const BuildHomeWidgetWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawerProvider = Provider.of<DrawerIndexProvider>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        drawerProvider.getIsShowDrawer ? const Expanded(flex: 2, child: DrawerWidget())
        : Container(),
        const HomeDashboardScreen(),
      ],
    );
  }
}