import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentation/component/base_icon.dart';

class AlertShareLink extends StatelessWidget {
  final String url;
  final VoidCallback onClick;

  const AlertShareLink({super.key, required this.url, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const BaseIcon(
                  iconColor: AppColors.primary100,
                  iconData: Icons.link,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text('Shareable Link', style: AppFonts.mediumTextRegular),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gray4,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(url, style: AppFonts.smallTextRegular),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            onClick();
                          },
                          child: Container(
                            width: 54,
                            height: 24,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.primary100,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Copy',
                              style: AppFonts.smallTextRegular.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
