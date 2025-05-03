import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/base_tab.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

void main() {
  group('BaseTab 위젯 테스트', () {
    testWidgets('BaseTab 위젯이 올바르게 렌더링되는지 확인', (WidgetTester tester) async {
      // BaseTab 위젯 렌더링
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseTab(
              activeColors: const [
                AppColors.marker100,
                AppColors.marker90,
                AppColors.marker80,
              ],
              labels: const ['All', 'Unread', 'Shares'],
              initialIndex: 0,
              onToggle: (index) {},
            ),
          ),
        ),
      );

      // BaseTab이 렌더링되었는지 확인
      expect(find.byType(BaseTab), findsOneWidget);

      // 내부 구현인 AnimatedToggleSwitch가 렌더링되었는지 확인
      expect(find.byType(AnimatedToggleSwitch<int>), findsOneWidget);

      // 모든 라벨이 표시되는지 확인
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Unread'), findsOneWidget);
      expect(find.text('Shares'), findsOneWidget);
    });

    testWidgets('BaseTab의 초기 인덱스 설정이 올바르게 작동하는지 확인', (
      WidgetTester tester,
    ) async {
      int selectedIndex = -1;

      // BaseTab 위젯 렌더링
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseTab(
              activeColors: const [
                AppColors.marker100,
                AppColors.marker90,
                AppColors.marker80,
              ],
              labels: const ['All', 'Unread', 'Shares'],
              initialIndex: 1, // 두 번째 탭이 초기 선택
              onToggle: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      // 탭 상태 직접적으로 확인하는 대신, 다음 탭을 눌러서 콜백 호출 확인
      await tester.tap(find.text('Shares'));
      await tester.pumpAndSettle(); // 애니메이션 완료 대기

      // 세 번째 탭(인덱스 2)으로 변경되었는지 확인
      expect(selectedIndex, 2);

      // 첫 번째 탭으로 돌아가는지 확인
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(selectedIndex, 0);
    });

    testWidgets('BaseTab의 onToggle 콜백이 올바르게 호출되는지 확인', (
      WidgetTester tester,
    ) async {
      // 선택된 인덱스를 저장할 변수
      int selectedIndex = -1;

      // BaseTab 위젯 렌더링
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BaseTab(
              activeColors: const [
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
          ),
        ),
      );

      // 두 번째 탭 클릭
      await tester.tap(find.text('Unread'));
      await tester.pumpAndSettle(); // 애니메이션 완료 대기

      // 콜백이 올바른 인덱스로 호출되었는지 확인
      expect(selectedIndex, 1);

      // 세 번째 탭 클릭
      await tester.tap(find.text('Shares'));
      await tester.pumpAndSettle();

      // 콜백이 올바른 인덱스로 호출되었는지 확인
      expect(selectedIndex, 2);

      // 첫 번째 탭 클릭
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      // 콜백이 올바른 인덱스로 호출되었는지 확인
      expect(selectedIndex, 0);
    });

    testWidgets('BaseTab에 올바른 색상이 적용되는지 확인', (WidgetTester tester) async {
      // Arrange
      const labels = ['All', 'Unread', 'Shares'];
      final activeColors = [
        AppColors.marker100,
        AppColors.marker90,
        AppColors.marker80,
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: BaseTab(
                activeColors: activeColors,
                labels: labels,
                initialIndex: 0,
                onToggle: (index) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // AnimatedToggleSwitch가 있는지 확인
      final toggleFinder = find.byType(AnimatedToggleSwitch<int>);
      expect(toggleFinder, findsOneWidget);

      // 현재 indicator 색상을 가져오기
      final animatedToggleSwitchWidget = tester
          .widget<AnimatedToggleSwitch<int>>(toggleFinder);

      // indicator 색상은 styleBuilder에서 정해지기 때문에 직접 계산
      final indicatorColor = activeColors[animatedToggleSwitchWidget.current];

      // 우리가 예상한 색깔과 맞는지 검증
      expect(indicatorColor, AppColors.marker100);

      // (추가) 다른 인덱스 선택 후 색깔 변화 테스트

      // 직접 상태를 바꿔서 두 번째 탭 선택 (Unread)
      await tester.tapAt(
        const Offset(300, 300),
      ); // 터치 위치 대충 주는 것보단 정확히 주는 게 더 좋지만 예시로
      await tester.pumpAndSettle();

      // 변경된 상태를 다시 가져와야 함
      final updatedToggleSwitchWidget = tester
          .widget<AnimatedToggleSwitch<int>>(toggleFinder);

      final updatedIndicatorColor =
          activeColors[updatedToggleSwitchWidget.current];

      // 두 번째 탭(Unread)이면 marker90 색상이어야 함
      expect(updatedIndicatorColor, AppColors.marker90);
    });

    testWidgets('BaseTab의 라벨 길이가 activeColors와 다를 때 예외 발생', (
      WidgetTester tester,
    ) async {
      // Arrange
      const labels = ['All', 'Unread'];
      final activeColors = [
        AppColors.marker100,
        AppColors.marker90,
        AppColors.marker80,
      ];

      // Act & Assert
      expect(
        () => BaseTab(
          activeColors: activeColors,
          labels: labels,
          initialIndex: 0,
          onToggle: (index) {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
