import 'package:flutter/material.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/fonts.dart';

class ListItemComponent extends StatelessWidget {
  const ListItemComponent({
    super.key,
    required this.title,
    this.description,
    this.type,
  });

  final String title;
  final String? description;
  final String? type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        elevation: 14,
        color: AppColors.colorScheme.onSecondary,
        shadowColor: AppColors.colorScheme.onSecondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: Fonts.Comfortaa,
                  fontSize: 16,
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
                        style: TextStyle(
                          fontFamily: Fonts.Comfortaa,
                          fontSize: 14,
                          color: AppColors.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
