import 'package:flutter/material.dart';

class SizeConfig {
  SizeConfig._();
  static double widthForCatWidet(context) {
    final width = MediaQuery.of(context).size.width.floorToDouble();
    double resultWidth = (width/3) - 15;
    return resultWidth;
  }
}