import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/presentation/component/bottom_bar.dart';


void main() {
  group('Battombar 테스트', () {
    testWidgets('Bottombar 생성이 되어야 한다', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: BottomBar(),));
      await tester.pump();

      expect(find.byType(BottomBar), findsOneWidget);
    });
    testWidgets('Bottombar 버튼이 클릭 시 변수가 변경되어야 한다', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: BottomBar(),));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.map));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.camera_alt));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
    });
  });
}