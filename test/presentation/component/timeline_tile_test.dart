import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photopin/core/enums/timeline_divide.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/timeline_tile.dart';

void main() {
  group('timeline tile component 테스트 : ', () {
    final Color morningColor = AppColors.secondary80;
    final Color dayColor = AppColors.marker50;
    final Color nightColor = AppColors.marker40;
    final Color dawnColor = AppColors.marker80;

    testWidgets('제대로 생성되어야 한다.', (tester) async {
      await mockNetworkImagesFor(
        () async => await tester.pumpWidget(
          MaterialApp(
            home: TimeLineTile(
              dateTime: DateTime(1999, 11, 30, 7, 30),
              title: 'Cafe Bene',
              imageUrl: '',
              onTap: (String photoId) {},
              photoId: '',
            ),
          ),
        ),
      );

      final Finder finder = find.text('Cafe Bene');

      expect(finder, findsOneWidget);
    });
    testWidgets('TimeLineTile 시간대별 색상 테스트\n'
        '- 06:00 ~ 12:00 일 경우 AppColors.secondary80 이어야한다.\n'
        '- 12:00 ~ 18:00 일 경우 AppColors.marker50 이어야한다.\n'
        '- 18:00 ~ 23:00 일 경우 AppColors.marker40 이어야한다.\n'
        '- 00:00 ~ 06:00 일 경우 AppColors.marker80 이어야한다.', (
      WidgetTester tester,
    ) async {
      // 여러 시간대 테스트 케이스
      final testCases = [
        {
          'time': DateTime(2023, 5, 7, 9, 30), // 오전
          'expectedColor': morningColor,
          'divideType': TimelineDivide.morning,
        },
        {
          'time': DateTime(2023, 5, 7, 14, 30), // 오후
          'expectedColor': dayColor,
          'divideType': TimelineDivide.day,
        },
        {
          'time': DateTime(2023, 5, 7, 19, 30), // 저녁
          'expectedColor': nightColor,
          'divideType': TimelineDivide.day,
        },
        {
          'time': DateTime(2023, 5, 7, 01, 30), // 새벽
          'expectedColor': dawnColor,
          'divideType': TimelineDivide.day,
        },
      ];

      for (final testCase in testCases) {
        // 위젯 다시 빌드
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TimeLineTile(
                dateTime: testCase['time'] as DateTime,
                title: '테스트',
                imageUrl: '',
                onTap: (String photoId) {},
                photoId: '',
              ),
            ),
          ),
        );

        // 색상 막대 Container 찾기
        final colorBarFinder = find.descendant(
          of: find.byType(Row),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container && widget.constraints?.maxWidth == 8,
          ),
        );

        final Container colorBarContainer = tester.widget<Container>(
          colorBarFinder,
        );
        final BoxDecoration decoration =
            colorBarContainer.decoration as BoxDecoration;

        // 시간대에 따른 색상 확인
        expect(decoration.color, testCase['expectedColor']);

        // 다음 테스트를 위해 현재 위젯 정리
        await tester.pumpAndSettle();
      }
    });
  });
}
