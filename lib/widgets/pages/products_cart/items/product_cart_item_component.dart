import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/extensions/context_extension.dart';
import 'package:how_to_cook/models/product.dart';

class ProductCartItemComponent extends StatefulWidget {
  ProductCartItemComponent(
      {super.key, required this.product, this.onItemMarked, this.markedValueToShow = false});

  final Product product;
  bool markedValueToShow;

  final void Function(Product product)? onItemMarked;

  @override
  State<StatefulWidget> createState() => _ProductCartItemComponentState();
}

class _ProductCartItemComponentState extends State<ProductCartItemComponent>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: widget.markedValueToShow != widget.product.isMarked ? 1 : 0,
    );

    animation = CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeOutQuad,
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProductCartItemComponent oldWidget) {
    animateWhenNeeded();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    animateWhenNeeded();
  }

  void animateWhenNeeded() {
    if (widget.product.isMarked != widget.markedValueToShow) {
      animationController?.forward();
      return;
    }

    if (widget.product.isMarked == widget.markedValueToShow) {
      animationController?.reverse();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.0),
        end: const Offset(1.0, 0),
      ).animate(animation!),
      child: SizeTransition(
        sizeFactor: ReverseAnimation(animation!),
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 2,
          ),
          decoration: BoxDecoration(
              color: context.isDarkMode ? Colors.grey : Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: context.isDarkMode
                      ? Colors.black.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.4),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontFamily: Fonts.Comfortaa,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.isDarkMode
                          ? Colors.white
                          : widget.product.isMarked
                              ? Colors.grey
                              : Colors.black,
                      decoration: widget.product.isMarked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: context.isDarkMode ? Colors.white : Colors.grey,
                    ),
                  ),
                  Text(
                    "${widget.product.count} ${widget.product.measure}",
                    style: TextStyle(
                      fontFamily: Fonts.Comfortaa,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: context.isDarkMode
                          ? Colors.white
                          : widget.product.isMarked
                              ? Colors.grey
                              : Colors.black,
                      decoration: widget.product.isMarked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: context.isDarkMode ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
              Checkbox(
                value: widget.product.isMarked,
                onChanged: (value) {
                  setState(() {
                    widget.product.isMarked = value ?? false;
                  });
                  widget.onItemMarked?.call(widget.product);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
