import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/enums/search_filter_option.dart';
import 'package:photopin/presentation/component/search_bar.dart';

void main() {
  group('SearchBarWidget 테스트', () {
    testWidgets('SearchBarWidget이 정상적으로 렌더링되는지 테스트합니다.', (
      WidgetTester tester,
    ) async {
      // 테스트할 위젯 생성
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SafeArea(
              child: SearchBarWidget(
                placeholder: 'Search',
                initFilterOption: SearchFilterOption.title,
                onDateTimeRangeSearch: (DateTimeRange range) {},
                onChangedOption: (SearchFilterOption option) {},
                onChanged: (String value) {},
              ),
            ),
          ),
        ),
      );

      // TextField 위젯이 존재하는지 확인
      expect(find.byType(TextField), findsOneWidget);

      // placeholder 텍스트가 올바르게 표시되는지 확인
      expect(find.text('Search'), findsOneWidget);

      // 검색 필터 아이콘이 표시되는지 확인
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('검색 입력 시 onChanged 콜백이 호출되는지 테스트합니다.', (
      WidgetTester tester,
    ) async {
      String searchText = '';

      // 테스트할 위젯 생성 (onChanged 콜백 포함)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SafeArea(
              child: SearchBarWidget(
                placeholder: 'Search',
                initFilterOption: SearchFilterOption.title,
                onDateTimeRangeSearch: (DateTimeRange range) {},
                onChangedOption: (SearchFilterOption option) {},
                onChanged: (value) {
                  searchText = value;
                },
              ),
            ),
          ),
        ),
      );

      // TextField 찾기
      final textField = find.byType(TextField);

      // 텍스트 입력
      await tester.enterText(textField, '테스트 검색어');

      // onChanged 콜백이 호출되어 searchText 변수가 업데이트되었는지 확인
      expect(searchText, '테스트 검색어');
    });
  });
}
