import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/text_chip.dart';

class TripWithChips extends StatelessWidget {
  final List<String> tripWith;
  final Color color;
  final int? maxLength;

  const TripWithChips({
    super.key,
    required this.tripWith,
    this.color = AppColors.primary80,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final bool shouldTruncate =
        maxLength != null && tripWith.length > maxLength!;

    final List<String> itemsToDisplay =
        shouldTruncate ? tripWith.take(maxLength!).toList() : tripWith;

    return Wrap(
      spacing: 4,
      children:
          itemsToDisplay.asMap().entries.map((entry) {
            final int index = entry.key;
            final String value = entry.value;

            final bool isLastItemInDisplayed =
                index == itemsToDisplay.length - 1;
            final bool showEllipsisInsteadOfLast =
                isLastItemInDisplayed && shouldTruncate;

            return TextChip(
              text: showEllipsisInsteadOfLast ? '...' : value,
              color: color,
              textColor: AppColors.white,
            );
          }).toList(),
    );
  }
}
