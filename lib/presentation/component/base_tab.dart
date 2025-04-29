import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';

class BaseTab extends StatefulWidget {
  const BaseTab({super.key});

  @override
  State<BaseTab> createState() => _BaseTabState();
}

class _BaseTabState extends State<BaseTab> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedToggleSwitch<int>.size(
        textDirection: TextDirection.rtl,
        current: value,
        values: const [0, 1, 2, 3],
        iconOpacity: 0.2,
        indicatorSize: const Size.fromWidth(100),
        iconBuilder: (value) => iconBuilder(value),
        borderWidth: 4.0,
        iconAnimationType: AnimationType.onHover,
        style: ToggleStyle(
          borderColor: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1.5),
            ),
          ],
        ),
        styleBuilder: (i) => ToggleStyle(indicatorColor: colorBuilder(i)),
        onChanged: (i) => setState(() => value = i),
      ),
    );
  }

  Widget iconBuilder(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.home);
      case 1:
        return const Icon(Icons.search);
      case 2:
        return const Icon(Icons.notifications);
      case 3:
        return const Icon(Icons.settings);
      default:
        return const Icon(Icons.error);
    }
  }

  Color colorBuilder(int index) {
    switch (index) {
      case 0:
        return AppColors.marker100;
      case 1:
        return AppColors.marker90;
      case 2:
        return AppColors.marker80;
      case 3:
        return AppColors.marker70;
      default:
        return Colors.grey;
    }
  }
}