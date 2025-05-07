import 'package:flutter/material.dart';
import 'package:photopin/core/styles/app_color.dart';

/// SearchBarWidget은 앱에서 검색 기능을 위한 검색창 UI를 제공합니다.
/// [placeholder]를 통해 힌트 텍스트를 설정할 수 있으며,
/// [onChanged] 콜백을 통해 텍스트 변경 이벤트를 처리할 수 있습니다.
class SearchBarWidget extends StatelessWidget {
  final String placeholder;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({super.key, required this.placeholder, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: placeholder,
          suffixIcon: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gray4,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(Icons.search, size: 16),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none, 
          focusedBorder: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}
