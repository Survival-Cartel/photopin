import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/presentation/component/recent_activity_tile.dart';

void main() {
  group('RecentActivityTile 테스트', () {
    testWidgets(
      'RecentActivityTile 컴포넌트를 클릭하여 onTap함수가 실행되는지 확인하기 위하여 변수 count가 0에서 1이 되게 바꾼다.',
      (WidgetTester tester) async {
        int count = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecentActivityTile(
                title: 'Seoul',
                dateTime: DateTime.now(),
                iconData: Icons.link,
                onTap: () {
                  count++;
                },
              ),
            ),
          ),
        );
        await tester.pump();

        expect(count, 0);

        await tester.tap(find.byType(RecentActivityTile));
        await tester.pump();

        expect(count, 1);
      },
    );
    testWidgets(
      '현재 시간을 기준으로  30일 전과 비교하여 dateTime 인스턴스 변수가 "1 month ago"가 되는지 확인한다',
      (WidgetTester tester) async {
        final now = DateTime.now();
        final oneMonthAgo = now.subtract(const Duration(days: 30));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecentActivityTile(
                title: 'Seoul',
                dateTime: oneMonthAgo,
                onTap: () {},
                iconData: Icons.link,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('1 month ago'), findsOneWidget);
      },
    );
  });
}
