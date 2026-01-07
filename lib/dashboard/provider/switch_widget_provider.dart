// import 'package:flutter/material.dart';
// import 'package:home_widget/home_widget.dart';

// class SwitchWidgetProvider extends ChangeNotifier {
//   bool switchValue = false;

//   bool get getSwitchValue  => switchValue;

//   getSwitchValuE() async {
//     switchValue = await HomeWidget.getWidgetData('view');
//     notifyListeners();
//    }

//    setSwitchValue() async {
//     switchValue = !getSwitchValue;
//     await HomeWidget.saveWidgetData('view', !getSwitchValue);
//     await HomeWidget.updateWidget( name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
//     notifyListeners();  
//    }
// }