import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:how_to_cook/common/app_colors.dart';
import 'package:how_to_cook/common/fonts.dart';
import 'package:how_to_cook/extensions/context_extension.dart';
import 'package:how_to_cook/generated/locale_keys.g.dart';
import 'package:how_to_cook/widgets/views/empty_state_view.dart';

class ExpandableSearchButton extends StatefulWidget {
  const ExpandableSearchButton({super.key, required this.onChanged});

  final void Function(String value) onChanged;

  @override
  State<ExpandableSearchButton> createState() => _ExpandableSearchButtonState();
}

class _ExpandableSearchButtonState extends State<ExpandableSearchButton> {
  final searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool isSearchExpanded = false;

  @override
  void dispose() {
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      width: isSearchExpanded ? context.screenWidth - 40 : 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            focusNode: _searchFocusNode,
            controller: searchController,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              filled: true,
              contentPadding: const EdgeInsets.only(left: 16),
              constraints: const BoxConstraints(maxHeight: 48),
              hintText: LocaleKeys.Search.tr(),
              hintStyle: const TextStyle(
                fontFamily: Fonts.Comfortaa,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                  color: AppColors.colorScheme.onSecondary,
                  width: 1,
                ),
              ),
            ),
          ),
          IconButton.filled(
            onPressed: () {
              setState(() {
                isSearchExpanded = !isSearchExpanded;
              });

              if (isSearchExpanded) {
                FocusScope.of(context).requestFocus(_searchFocusNode);
                return;
              }

              searchController.clear();
              widget.onChanged("");
              FocusScope.of(context).unfocus();
            },
            icon: AnimatedSwitcher(
              duration: Durations.short4,
              child: Icon(
                isSearchExpanded ? Icons.close : Icons.search,
                key: ValueKey(isSearchExpanded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
