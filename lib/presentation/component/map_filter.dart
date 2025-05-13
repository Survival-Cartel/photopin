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
      height: 24, // 세로 사이즈 고정 유지
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼들을 균등하게 분배
        children: List.generate(widget.icons.length, (index) {
          final bool isLastItem = index == widget.icons.length - 1;

          return Padding(
            // Expanded 대신 Padding 사용
            padding: EdgeInsets.only(right: isLastItem ? 0 : 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onSelected(index);
              },
              child: Container(
                // 높이는 부모 컨테이너에 맞추기
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
                // IntrinsicWidth를 사용하여 내용물 크기에 맞게 크기 조정
                child: IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 가로 패딩 추가
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // 내용물에 맞게 크기 조정
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
                    ],
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
