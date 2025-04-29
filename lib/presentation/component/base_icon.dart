import 'package:flutter/material.dart';

class BaseIcon extends StatelessWidget {
  final Color iconColor;
  final IconData iconData;
  final double size;
  const BaseIcon({
    super.key,
    required this.iconColor,
    required this.iconData,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: size,
      backgroundColor: iconColor.withValues(alpha: 0.1),
      child: Icon(iconData, color: iconColor, size: 18),
    );
  }
}
