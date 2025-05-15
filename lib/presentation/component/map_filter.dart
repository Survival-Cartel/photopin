import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';

class MapFilter extends StatefulWidget {
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onSelected;

  const MapFilter({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  State<MapFilter> createState() => _MapFilterState();
}

class _MapFilterState extends State<MapFilter> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(MapFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 부모 위젯에서 selectedIndex가 변경되면 내부 상태도 업데이트
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _currentIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.labels.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
                widget.onSelected(index);
              },
              child: Container(
                height: 24, // 높이는 고정
                decoration: BoxDecoration(
                  color:
                      _currentIndex == index
                          ? AppColors.primary100
                          : AppColors.gray4,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow:
                      _currentIndex == index
                          ? const [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1.5),
                            ),
                          ]
                          : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Text(
                      widget.labels[index],
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            _currentIndex == index
                                ? Colors.white
                                : AppColors.gray1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
