
import 'package:appwidgetflutter/dashboard/provider/drawer_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerFunction {
  DrawerFunction._();

  static onTapMobile(GlobalKey<ScaffoldState> key) {
    return key.currentState!.openDrawer();
  }
  static onTapWeb(context) {
    final isShowDrawer = Provider.of<DrawerIndexProvider>(context,listen: false);
    isShowDrawer.setIsShowDrawer();
  }
}