import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

/// [labels]와 [activeColors]의 요소의 개수는 같아야 합니다.
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
          child: AnimatedToggleSwitch<int>.size(
            textDirection: TextDirection.ltr,
            current: currentIndex,
            values: List.generate(widget.labels.length, (index) => index),
            iconOpacity: 1.0,
            indicatorSize: const Size.fromHeight(40),
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
            styleBuilder:
                (index) => ToggleStyle(indicatorColor: _colorBuilder(index)),
            onChanged: (index) {
              setState(() {
                currentIndex = index;
              });

              widget.onToggle?.call(index);
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
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: currentIndex == index ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Color _colorBuilder(int index) {
    return widget.activeColors[index];
  }
}
