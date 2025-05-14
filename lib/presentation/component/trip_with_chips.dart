import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/text_chip.dart';

class TripWithChips extends StatelessWidget {
  final List<String> tripWith;
  final Color color;

  const TripWithChips({
    super.key,
    required this.tripWith,
    this.color = AppColors.primary80,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children:
          tripWith.map((value) {
            return TextChip(
              text: value,
              color: color,
              textColor: AppColors.white,
            );
          }).toList(),
    );
  }
}
