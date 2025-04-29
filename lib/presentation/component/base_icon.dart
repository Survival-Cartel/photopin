import 'package:flutter/material.dart';

/// size 의 경우 반지름으로 적용되기 때문에 일반적인 크기보다 반으로 줄여서 입력해주세요.
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
