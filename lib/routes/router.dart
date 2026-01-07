import 'package:appwidgetflutter/dashboard/dashboard_layout/dashboard_layout.dart';
import 'package:appwidgetflutter/new_firebase/category_manager.dart';
import 'package:flutter/material.dart';

@immutable
class AppRouter {
  const AppRouter._();
  static const String initialRoute = 'home';
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static Future<dynamic> pushNamed(routeName, {dynamic routeArguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: routeArguments);
  }

  static Future<dynamic> pushNamedAndRemoveAllStack(routeName,
      {dynamic routeArguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: routeArguments,
    );
  }

  static void pop() {
    return navigatorKey.currentState!.pop();
  }

  static Route<dynamic>? generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case 'CategoriesGallery':
        return moveMaterialPageRoute(
          pageClass: CategoryManager(category: 'fa'),
          pageName: 'CategoriesGallery',
        );
      case 'dashboard':
        return moveMaterialPageRoute(
          pageClass: HomePage(),
          pageName: 'dashboard',
        );
    }
    return null;
  }
}

MaterialPageRoute moveMaterialPageRoute(
    {required Widget pageClass, required String pageName,arguments}) {
  return MaterialPageRoute(
    builder: (_) => pageClass,
    settings: RouteSettings(name: pageName,arguments:arguments),
  );
}
