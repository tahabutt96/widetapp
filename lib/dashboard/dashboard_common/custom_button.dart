import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final double height;
  final double? width;
  final VoidCallback onPressed;
  final bool disabled;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final Gradient? gradient;
  final double borderRadius;
  final Widget child;

  const CustomTextButton({
    Key? key,
    double? height,
    double? borderRadius,
    this.width,
    bool? disabled,
    this.gradient,
    this.border,
    this.color,
    this.padding,
    required this.child,
    required this.onPressed,
  })  : borderRadius = borderRadius ?? 7,
        height = height ?? 55,
        disabled = disabled ?? false,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: disabled ? () {} : onPressed,
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
          color: color,
        ),
        child: child,
      ),
    );
  }
}
