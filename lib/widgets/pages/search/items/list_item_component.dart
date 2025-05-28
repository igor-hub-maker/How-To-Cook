import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/fonts.dart';

class ListItemComponent extends StatelessWidget {
  const ListItemComponent(
      {super.key,
      required this.title,
      this.description,
      this.type,
      this.image,
      required this.openBuilder});

  final String title;
  final String? description;
  final String? type;
  final String? image;
  final Widget Function(BuildContext context, VoidCallback action) openBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: OpenContainer(
        openBuilder: openBuilder,
        closedElevation: 2,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        closedColor: AppColors.colorScheme.onSecondary,
        closedBuilder: (context, action) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: image == null
                ? null
                : DecorationImage(
                    image: NetworkImage(image!),
                    fit: BoxFit.cover,
                  ),
            border: Border.all(
              color: AppColors.colorScheme.primary,
              width: 5,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: image == null
                  ? null
                  : LinearGradient(
                      colors: [
                        AppColors.colorScheme.primary.withOpacity(0.8),
                        Colors.transparent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
              color: image == null ? AppColors.colorScheme.primary.withOpacity(0.8) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: Fonts.Comfortaa,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (description != null)
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: Fonts.Comfortaa,
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
