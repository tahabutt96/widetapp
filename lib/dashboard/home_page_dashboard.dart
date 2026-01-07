import 'package:appwidgetflutter/dashboard/add_view_category_layout/category_layout.dart';
import 'package:appwidgetflutter/dashboard/all_aya_by_category.dart';
import 'package:appwidgetflutter/dashboard/dashboard_common/custom_app_bar.dart';
import 'package:appwidgetflutter/dashboard/provider/drawer_index_provider.dart';
import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard_common/dash_card_widget.dart';
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawerProvider = Provider.of<DrawerIndexProvider>(context);
    final imageList = [
      Images.category,
      Images.file,
    ];
    final titles = [
      "Add Category",
      "All Ayas",
    ];
    return  drawerProvider.getSelectedIndex == 0 ? Expanded(
      flex: 8,
      child: CustomAppBar(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: imageList.asMap().map((index, value) => MapEntry(index, CardWidget(
                            image: imageList[index],
                            title: titles[index],
                            onTap: () {
                              drawerProvider.setSelectedIndex(index+1);
                            },
                          ))).values.toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
     )  : drawerProvider.selectedIndex == 1  ?
        const CategoryLayout()
      : drawerProvider.selectedIndex == 2  ?
        const AddAya() :
      Container();
  }
}