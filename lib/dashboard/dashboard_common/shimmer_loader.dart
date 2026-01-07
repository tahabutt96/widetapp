import 'package:flutter/material.dart';

class ShimmerLoader extends StatefulWidget {
  final Widget child;

  const ShimmerLoader({required this.child});

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader> with SingleTickerProviderStateMixin{

    late final _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      lowerBound: 0.5,
      vsync: this,
    );

    useEffect() {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
      _controller.forward();
      return null;
    }
  @override
  void initState() {
    useEffect();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: widget.child,
    );
  }
}
