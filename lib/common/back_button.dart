import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';
class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          height: 40.0,
          width: 40.0,
        child: Center(
          child: Icon(Icons.arrow_back,
          size: 22.0,
           color: ColorResources.BOTTOM_BAR_SELECTED,
          ),
        ),
       ),
      ),
    );
  }
}