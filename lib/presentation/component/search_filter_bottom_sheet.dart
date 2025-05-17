import 'package:flutter/material.dart';
import 'package:photopin/core/enums/search_filter_option.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/core/styles/app_font.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  final SearchFilterOption initialOption;
  final Function(SearchFilterOption option) onChangeFilterOption;

  const SearchFilterBottomSheet({
    super.key,
    required this.initialOption,
    required this.onChangeFilterOption,
  });

  @override
  State<StatefulWidget> createState() => _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  late SearchFilterOption _option;

  @override
  void initState() {
    super.initState();
    _option = widget.initialOption;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Search Filter',
                  style: AppFonts.normalTextBold.copyWith(
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    title: Text('제목으로 검색', style: AppFonts.smallTextRegular),
                    leading: Radio<SearchFilterOption>(
                      value: SearchFilterOption.title,
                      groupValue: _option,
                      onChanged: (SearchFilterOption? value) {
                        if (value != null) {
                          setState(() {
                            _option = value;
                          });
                          widget.onChangeFilterOption(_option);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                    title: Text('날짜로 검색', style: AppFonts.smallTextRegular),
                    leading: Radio<SearchFilterOption>(
                      value: SearchFilterOption.date,
                      groupValue: _option,
                      onChanged: (SearchFilterOption? value) {
                        if (value != null) {
                          setState(() {
                            _option = value;
                          });
                          widget.onChangeFilterOption(_option);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
