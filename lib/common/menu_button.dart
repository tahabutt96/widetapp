import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final VoidCallback onTap;
  const MenuButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 55.0,
        height: 55.0,
        child: Card(
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Image.asset(Images.drawer_img)),
        ),
      ),
    );
  }
}