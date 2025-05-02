
import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';
import 'package:photopin/presentaion/component/date_range_slider.dart';
import 'package:photopin/presentation/component/base_button.dart';
import 'package:photopin/presentation/component/base_icon_button.dart';

import '../../core/enums/button_type.dart';

void main() {
  runApp(
    MaterialApp(
      home: BottomBar(),
    )
  );
}


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
        width: 48,
        height: 56,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, color: isSelected ? activeColor : AppColors.gray2,
            ),
            // SizedBox(
            //   height: 4
            // ),
            Text(label,
              style: AppFonts.smallerTextRegular.copyWith(
                color: isSelected ? activeColor : AppColors.gray2,
                height: 1.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double barHeight = 56.0;
    const double fabSize   = 48.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('포토 핀'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BaseButton(
                buttonName: '은렬',
                onClick: () {},
                buttonType: ButtonType.big
              ),
              SizedBox(
                height: 8,
              ),
              BaseIconButton(
                buttonType: ButtonType.small,
                iconName: Icons.edit,
                buttonName: '공부하세요',
                onClick: () {} ,
                buttonColor: AppColors.secondary80
              ),
              SizedBox(
                height: 8,
              ),
              DateRangeSlider(
                startDate: DateTime(2025, 3, 25),
                endDate: DateTime(2025, 6, 3),
                onChanged: (DateTime sd, DateTime ed) {},
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: AppColors.white,
        child: SizedBox(
          height: barHeight,
          child: Row(
            mainAxisAlignment:  MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0, AppColors.primary100),
              _buildNavItem(Icons.map,  'Map',  1, AppColors.secondary100),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _onItemTapped(2),
                child: Container(
                  width: fabSize,
                  height: fabSize,
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    shape: BoxShape.circle,
                    boxShadow: const [BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                    )]
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 24,
                    color: AppColors.white,
                  ),
                ),
              ),
              _buildNavItem(Icons.photo,    'Photos',   3, AppColors.marker80),
              _buildNavItem(Icons.settings, 'Settings', 4, AppColors.marker100),
            ],
          ),
        )
      ),
    );
  }
}
