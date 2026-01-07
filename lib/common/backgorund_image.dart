import 'package:appwidgetflutter/utills/images_sources.dart';
import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final Widget child;
  final String? image;
  const BackgroundImage({super.key, required this.child, this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
            fit: BoxFit.cover,
            color: Colors.grey[400],
            opacity: AlwaysStoppedAnimation(0.1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            image??Images.background_img,
          ),
          child,
      ],
    );
  }
}