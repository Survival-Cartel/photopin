import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) changeTab;

  const BottomBar({
    super.key,
    required this.selectedIndex,
    required this.changeTab,
  });

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    Color activeColor,
  ) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => changeTab(index),
      child: SizedBox(
        width: 48,
        height: 56,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? activeColor : AppColors.gray2),
            Text(
              label,
              style: AppFonts.smallerTextRegular.copyWith(
                color: isSelected ? activeColor : AppColors.gray2,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double barHeight = 56.0;
    const double fabSize = 48.0;

    return BottomAppBar(
      elevation: 8,
      color: AppColors.white,
      child: SizedBox(
        height: barHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', 0, AppColors.primary100),
            _buildNavItem(Icons.book, 'Journal', 1, AppColors.secondary100),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => changeTab(2),
              child: Container(
                width: fabSize,
                height: fabSize,
                decoration: const BoxDecoration(
                  color: AppColors.primary100,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 24,
                  color: AppColors.white,
                ),
              ),
            ),
            _buildNavItem(Icons.photo, 'Photo', 3, AppColors.marker80),
            _buildNavItem(Icons.settings, 'Setting', 4, AppColors.marker100),
          ],
        ),
      ),
    );
  }
}
