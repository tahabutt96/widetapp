import 'package:appwidgetflutter/utills/colors_resources.dart';
import 'package:flutter/material.dart';

class LightCircleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  const LightCircleButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 40.0,
        width: 40.0,
        
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10.0,
          ),
        ]
      ),
      child: Center(
        child: Icon(icon,
        size: 22.0,
         color: ColorResources.BOTTOM_BAR_SELECTED,
        ),
      ),
     ),
    );
  }
}