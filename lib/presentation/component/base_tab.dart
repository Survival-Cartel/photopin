import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

class BaseTab extends StatefulWidget {
  final List<String> labels;
  final List<Color> activeColors;
  final int initialIndex;
  final ValueChanged<int>? onToggle;

  const BaseTab({
    super.key,
    required this.labels,
    required this.activeColors,
    this.initialIndex = 0,
    this.onToggle,
  });

  @override
  State<BaseTab> createState() => _BaseTabState();
}

class _BaseTabState extends State<BaseTab> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabCount = widget.labels.length;
              final availableWidth = constraints.maxWidth;
              final tabWidth = availableWidth / tabCount;
              return AnimatedToggleSwitch<int>.size(
                textDirection: TextDirection.ltr,
                current: currentIndex,
                values: List.generate(tabCount, (index) => index),
                iconOpacity: 1.0,
                indicatorSize: Size(tabWidth, 40),
                iconBuilder: (index) => _textBuilder(index),
                borderWidth: 2.0,
                iconAnimationType: AnimationType.onHover,
                style: ToggleStyle(
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1.5),
                    ),
                  ],
                ),
                styleBuilder: (index) => ToggleStyle(
                  indicatorColor: _colorBuilder(index),
                ),
                onChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                  widget.onToggle?.call(index);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _textBuilder(int index) {
    return Center(
      child: Text(
        widget.labels[index],
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _colorBuilder(int index) {
    return widget.activeColors[index];
  }
}