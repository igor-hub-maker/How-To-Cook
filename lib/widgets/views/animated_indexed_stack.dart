import 'package:flutter/material.dart';

class AnimatedIndexedStack extends StatefulWidget {
  AnimatedIndexedStack({super.key, required this.children, required this.index});

  List<Widget> children;
  int index;

  @override
  State<StatefulWidget> createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;
  bool isAnimatingOut = false;
  late int _index;

  @override
  void initState() {
    _index = widget.index;

    animationController = AnimationController(
      duration: const Duration(milliseconds: 60),
      vsync: this,
    );
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeOutQuad);

    super.initState();
    animationController.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedIndexedStack oldWidget) {
    if (oldWidget.index != widget.index) {
      setState(() {
        isAnimatingOut = true;
      });

      animationController.forward(from: 0).then((_) {
        setState(() {
          isAnimatingOut = false;
        });

        animationController.forward(from: 0);
        _index = widget.index;
        super.didUpdateWidget(oldWidget);
      });
      return;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: isAnimatingOut ? 1.0 : 0.9, end: isAnimatingOut ? 1.1 : 1.0)
          .animate(animation),
      child: FadeTransition(
        opacity: Tween(begin: isAnimatingOut ? 0.8 : 0.0, end: isAnimatingOut ? 0.0 : 1.0)
            .animate(animation),
        child: IndexedStack(
          index: _index,
          children: widget.children,
        ),
      ),
    );
  }
}
