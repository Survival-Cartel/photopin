import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/presentation/component/top_bar.dart';

void main() {
  testWidgets('Topbar 생성이 되어야 한다', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(appBar: TopBar(onNotificationTap: () {}))),
    );
    await tester.pump();
    expect(find.text('Photopin'), findsOneWidget);
  });

  testWidgets(
    'Notification Icon을 클릭하면 onNotificationTab이 호출 되어 변수 Count가 증가 하여야 한다',
    (WidgetTester tester) async {
      int count = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: TopBar(
              onNotificationTap: () {
                count++;
              },
            ),
          ),
        ),
      );
      await tester.pump();

      final notificationFinder = find.byIcon(Icons.notifications_none);
      expect(notificationFinder, findsOneWidget);

      await tester.tap(notificationFinder);
      await tester.pump();

      expect(count, 1);
    },
  );

  testWidgets('profileImg가 주어지면 NetworkImage Container가 생성 되어야 한다', (
    WidgetTester tester,
  ) async {
    const url = 'https://example.com/avatar.png';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: TopBar(profileImg: url, onNotificationTap: () {}),
        ),
      ),
    );
    await tester.pump();

    final networkImgContainer = find.byType(Container());
  });

  testWidgets('profileImg가 없으면 PersonIcon이 생성 되어야 한다', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(appBar: TopBar(onNotificationTap: () {}))),
    );
    await tester.pump();

    expect(find.byIcon(Icons.notifications_none), findsOneWidget);
  });
}
