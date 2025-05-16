import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';

class MoveBottomSheet extends StatefulWidget {
  final Widget body;
  const MoveBottomSheet({super.key, required this.body});

  @override
  State<MoveBottomSheet> createState() => _MoveBottomSheetState();
}

class _MoveBottomSheetState extends State<MoveBottomSheet> {
  static const double _minHeight = 60;
  static const double _maxHeight = 400;
  double _sheetHeight = _maxHeight;

  void _onHandleDragEnd(DragEndDetails details) {
    final mid = (_maxHeight + _minHeight) / 2;
    setState(() {
      _sheetHeight = _sheetHeight >= mid ? _maxHeight : _minHeight;
    });
  }

  void _onHandleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _sheetHeight = (_sheetHeight - details.delta.dy).clamp(
        _minHeight,
        _maxHeight,
      );
    });
  }

  void _onHandleTap() {
    setState(() {
      _sheetHeight = _sheetHeight == _minHeight ? _maxHeight : _minHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      duration: const Duration(milliseconds: 200),
      height: _sheetHeight,
      decoration: const BoxDecoration(
        color: AppColors.gray5,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        spacing: 8,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragUpdate: _onHandleDragUpdate,
            onVerticalDragEnd: _onHandleDragEnd,
            onTap: _onHandleTap,
            child: Container(
              width: double.infinity,
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          (_sheetHeight == _maxHeight)
              ? Expanded(child: widget.body)
              : const SizedBox(),
        ],
      ),
    );
  }
}
