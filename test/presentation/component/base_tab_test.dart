import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/base_tab.dart';
import 'package:photopin/main.dart';

void main() {
  group('MyHomePage 테스트', () {
    testWidgets('BaseTab 위젯이 렌더링되는지 확인', (WidgetTester tester) async {
      // 위젯 렌더링
      await tester.pumpWidget(
        const MaterialApp(home: MyHomePage(title: 'Flutter Demo Home Page')),
      );

      // BaseTab 위젯이 존재하는지 확인
      expect(find.byType(BaseTab), findsOneWidget);
    });

    testWidgets('BaseTab에 올바른 레이블이 표시되는지 확인', (WidgetTester tester) async {
      // 위젯 렌더링
      await tester.pumpWidget(
        const MaterialApp(home: MyHomePage(title: 'Flutter Demo Home Page')),
      );

      // 탭 레이블 확인
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Unread'), findsOneWidget);
      expect(find.text('Shares'), findsOneWidget);
    });

    testWidgets('탭 선택 시 onToggle 함수가 호출되는지 확인', (WidgetTester tester) async {
      // 테스트용 변수
      int selectedIndex = -1;

      // 커스텀 MyHomePage 구현
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('BaseTab Example')),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BaseTab(
                  activeColors: [
                    AppColors.marker100,
                    AppColors.marker90,
                    AppColors.marker80,
                  ],
                  labels: const ['All', 'Unread', 'Shares'],
                  initialIndex: 0,
                  onToggle: (index) {
                    selectedIndex = index;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      // 초기 인덱스 확인
      expect(selectedIndex, -1);

      // 두 번째 탭 탭하기
      await tester.tap(find.text('Unread'));
      await tester.pump();

      // 선택된 인덱스 확인
      expect(selectedIndex, 1);

      // 세 번째 탭 탭하기
      await tester.tap(find.text('Shares'));
      await tester.pump();

      // 선택된 인덱스 확인
      expect(selectedIndex, 2);
    });
  });
}
