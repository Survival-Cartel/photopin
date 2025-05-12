import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';

/// [labels]와 [icons] 리스트의 각 요소는 1:1로 매칭되어야 하며, 그렇지 않을 경우 ArgumentError가 발생합니다.
/// 즉, [labels]의 길이와 [icons]의 길이가 같아야 합니다.
class MapFilter extends StatefulWidget {
  final List<Icon> icons;
  final List<String> labels;
  final int initialIndex;
  final Function(int) onSelected;

  MapFilter({
    super.key,
    required this.icons,
    required this.labels,
    required this.initialIndex,
    required this.onSelected,
  }) {
    if (labels.length != icons.length) {
      throw ArgumentError('labels와 icons의 길이가 같아야 합니다.');
    }
  }

  @override
  State<MapFilter> createState() => _MapFilterState();
}

class _MapFilterState extends State<MapFilter> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(widget.icons.length, (index) {
          final bool isLastItem = index == widget.icons.length - 1;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLastItem ? 0 : 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onSelected(index);
                },
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        selectedIndex == index
                            ? AppColors.primary100
                            : AppColors.gray4,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow:
                        selectedIndex == index
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
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconTheme(
                          data: IconThemeData(
                            color:
                                selectedIndex == index
                                    ? Colors.white
                                    : AppColors.gray1,
                            size: 16,
                          ),
                          child: widget.icons[index],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.labels[index],
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                selectedIndex == index
                                    ? Colors.white
                                    : AppColors.gray1,
                          ),
                        ),
                      ],
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
