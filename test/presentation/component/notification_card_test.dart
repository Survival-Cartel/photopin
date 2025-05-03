import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/extensions/datetime_extension.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/notification_card.dart';

void main() {
  final String title = 'Title';
  final String message = 'Message';
  final String badgeTitle = 'Badge Title';
  final DateTime dateTime = DateTime.parse('2025-05-02 16:00:00');

  testWidgets('NotificationCard가 정상적으로 렌더링 되고, 구성요소가 올바르게 표시되어야한다.', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: NotificationCard(
              title: title,
              dateTime: dateTime,
              message: message,
              badgeTitle: badgeTitle,
              onTapDetail: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text(title), findsOneWidget);
    expect(find.text(message), findsOneWidget);
    expect(find.text(badgeTitle), findsOneWidget);
    expect(find.text(dateTime.timeAgoFromNow()), findsOneWidget);
    expect(find.byIcon(Icons.visibility), findsOneWidget);
    expect(find.byIcon(Icons.link), findsOneWidget);
  });

  testWidgets(
    'NotificationCard의 isRead 속성이 true일 경우, 우측 상단의 read checker 표시가 하얀색으로 렌더링 되야한다.',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: NotificationCard(
                title: title,
                dateTime: dateTime,
                message: message,
                badgeTitle: badgeTitle,
                onTapDetail: () {},
                isRead: true,
              ),
            ),
          ),
        ),
      );

      Finder readChecker = find.byKey(const Key('read_checker'));
      Container readContainer = tester.firstWidget(readChecker) as Container;
      BoxDecoration decoration = readContainer.decoration as BoxDecoration;

      expect(decoration.color, AppColors.white);
    },
  );

  testWidgets(
    'NotificationCard의 View Detail을 누를 경우 onTapDetail 콜백 함수가 실행되어야한다.',
    (tester) async {
      bool onTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: NotificationCard(
                title: title,
                dateTime: dateTime,
                message: message,
                badgeTitle: badgeTitle,
                onTapDetail: () {
                  onTapped = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('View Details'));
      expect(onTapped, true);
    },
  );
}
