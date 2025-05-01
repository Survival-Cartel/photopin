
import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';




class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;


  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem(
   IconData icon,
   String label,
   int index,
   Color activeColor,
  ){
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onItemTapped(index),
      child:  Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, color: isSelected ? activeColor : AppColors.gray2,
            ),
            SizedBox(
              height: 4
            ),
            Text(label,
              style: AppFonts.smallerTextRegular.copyWith(
                color: isSelected ? activeColor : AppColors.gray2,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double barHeight = 50.0;
    const double fabSize   = 40.0;

    return Scaffold(
      body: Center(child: Text('$_selectedIndex'),),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonLocation:
      const CustomFabLocation(overlapPercent: 2.1, barHeight: barHeight),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2),
        backgroundColor: AppColors.primary100,
        shape: CircleBorder(),
        child: Icon(Icons.camera_alt,
          color: AppColors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
          // shape: const CircularNotchedRectangle(),
          // notchMargin: 6.0,
          color: AppColors.white,
        child: SizedBox(
          height: barHeight,
          child: Row(
            mainAxisAlignment:  MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0, AppColors.primary100),
              _buildNavItem(Icons.map,  'Map',  1, AppColors.secondary100),
              const SizedBox(width: fabSize),
              _buildNavItem(Icons.photo,    'Photos',   3, AppColors.marker80),
              _buildNavItem(Icons.settings, 'Settings', 4, AppColors.marker100),
            ],
          ),
        )
      ),
    );
  }
}


class CustomFabLocation extends FloatingActionButtonLocation {
  final double overlapPercent;
  final double barHeight;

  const CustomFabLocation({
    this.overlapPercent = 0.5,
    required this.barHeight,
  });

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final fabSize = scaffoldGeometry.floatingActionButtonSize.height;
    final x = (scaffoldGeometry.scaffoldSize.width - fabSize) / 2;
    final y = scaffoldGeometry.scaffoldSize.height
        - barHeight
        + fabSize * (1 - overlapPercent);

    return Offset(x, y);
  }
}