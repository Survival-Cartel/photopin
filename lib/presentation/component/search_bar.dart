import 'package:flutter/material.dart';
import 'package:photopin/core/extensions/datetime_range_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/enums/search_filter_option.dart';
import 'package:photopin/presentation/component/search_filter_bottom_sheet.dart';

/// SearchBarWidget은 앱에서 검색 기능을 위한 검색창 UI를 제공합니다.
/// [placeholder]를 통해 힌트 텍스트를 설정할 수 있으며,
/// [onChanged] 콜백을 통해 텍스트 변경 이벤트를 처리할 수 있습니다.
class SearchBarWidget extends StatelessWidget {
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final SearchFilterOption initFilterOption;
  final DateTimeRange? initRange;
  final Function(DateTimeRange dateTimeRange) onDateTimeRangeSearch;
  final Function(SearchFilterOption option) onChangedOption;

  const SearchBarWidget({
    super.key,
    required this.initFilterOption,
    required this.placeholder,
    required this.onChangedOption,
    required this.onDateTimeRangeSearch,
    this.initRange,
    this.onChanged,
  });

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
      child:
          initFilterOption == SearchFilterOption.title
              ? TextField(
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: placeholder,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _buildSearchFilterBottomSheet(context);
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.gray4,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.tune,
                        size: 24,
                        color: AppColors.primary100,
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              )
              : _showDateRangePicker(context),
    );
  }

  Future<dynamic> _buildSearchFilterBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SearchFilterBottomSheet(
          initialOption: initFilterOption,
          onChangeFilterOption: (option) {
            onChangedOption(option);
          },
        );
      },
    );
  }

  Widget _showDateRangePicker(BuildContext context) {
    return TextField(
      showCursor: false,
      readOnly: true,
      onTap: () async {
        final DateTimeRange? range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(1999),
          lastDate: DateTime(2100, 12, 31),
          initialDateRange: initRange,
          saveText: '저장',
          builder: (BuildContext context, Widget? child) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: double.infinity,
                  maxHeight: 600.0,
                ),
                child: child,
              ),
            );
          },
        );

        if (range != null) {
          onDateTimeRangeSearch(range.toDayRange());
        }
      },
      decoration: InputDecoration(
        hintText: placeholder,
        suffixIcon: GestureDetector(
          onTap: () => _buildSearchFilterBottomSheet(context),
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gray4,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.tune,
              size: 24,
              color: AppColors.primary100,
            ),
          ),
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
