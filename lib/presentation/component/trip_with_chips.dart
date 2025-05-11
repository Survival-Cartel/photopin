import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/text_chip.dart';

class TripWithChips extends StatelessWidget {
  const TripWithChips({super.key, required this.tripWith});

  final List<String> tripWith;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children:
          tripWith.map((value) {
            return TextChip(
              text: value,
              color: AppColors.primary80,
              textColor: AppColors.white,
            );
          }).toList(),
    );
  }
}
