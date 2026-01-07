import 'package:appwidgetflutter/dashboard/dashboard_constants.dart';

extension StringExt on String {
  bool get isValidEmail => Constants.emailRegex.hasMatch(this);
  bool get isValidContact => Constants.contactRegex.hasMatch(this);
}
