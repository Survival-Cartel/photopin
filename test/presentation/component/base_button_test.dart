import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/presentation/component/base_button.dart';


void main() {
  group('base button 컴포넌트 테스트', () {
    testWidgets('버튼 생성이 되어야 한다', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BaseButton(
            buttonName: 'Share',
            onClick: () {

            },
            buttonType: ButtonType.big,
          )
        )
      );
      final Finder finder = find.byType(BaseButton);

      expect(finder, findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
    });
    testWidgets('onClick 콜백 시 변수가 바뀌어야 한다', (WidgetTester tester) async {
      int count = 0;

      await tester.pumpWidget(
          MaterialApp(
              home: BaseButton(
                buttonName: 'Share',
                onClick: () {
                  count++;
                },
                buttonType: ButtonType.big,
              )
          )
      );
      expect(count, equals(0));

      await tester.tap(find.text('Share'));
      await tester.pump();

      expect(count, equals(1));
    });
  });
}