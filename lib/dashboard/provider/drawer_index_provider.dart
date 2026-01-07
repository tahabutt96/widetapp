

import 'package:flutter/material.dart';

class DrawerIndexProvider extends ChangeNotifier {

  int selectedIndex = 0;
  bool isShowDrawer = true;

  int get getSelectedIndex => selectedIndex;
  bool get getIsShowDrawer => isShowDrawer;

  setSelectedIndex(index) {
    selectedIndex = index;
    notifyListeners();
  }

  setIsShowDrawer() {
    isShowDrawer=!isShowDrawer;
    notifyListeners();
  }
}