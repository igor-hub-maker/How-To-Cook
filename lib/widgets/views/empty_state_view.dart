import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:how_to_cook/common/emojis.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(Emojis.getRandomEmoji,
              style: TextStyle(
                fontSize: 50,
                color: Theme.of(context).colorScheme.primary,
              )),
          Text(
            message ?? LocaleKeys.NoDataAvailable.tr(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
