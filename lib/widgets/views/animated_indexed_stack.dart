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
  late final PageController pageController = PageController(initialPage: widget.index);

  // late int _index;

  bool isAnimatingOut = false;
  bool isAnimatingForward = true;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
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
        isAnimatingForward = widget.index > oldWidget.index;
      });

      animationController.forward(from: 0).then((_) {
        setState(() {
          isAnimatingOut = false;
        });

        animationController.forward(from: 0);
        pageController.jumpToPage(widget.index);
        super.didUpdateWidget(oldWidget);
      });
      return;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: isAnimatingOut
            ? const Offset(0, 0)
            : isAnimatingForward
                ? const Offset(0.6, 0)
                : const Offset(-0.6, 0),
        end: isAnimatingOut
            ? isAnimatingForward
                ? const Offset(-0.6, 0)
                : const Offset(0.6, 0)
            : const Offset(0, 0),
      ).animate(animation),
      child: FadeTransition(
        opacity: Tween(begin: isAnimatingOut ? 0.8 : 0.0, end: isAnimatingOut ? 0.0 : 1.0)
            .animate(animation),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: widget.children,
        ),
      ),
    );
  }
}
