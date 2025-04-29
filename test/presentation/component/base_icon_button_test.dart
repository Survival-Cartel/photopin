import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/base_icon_button.dart';

void main() {
  group('base icon button 컴포넌트 테스트', () {
    testWidgets('아이콘 버튼이 생성되어야 한다', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BaseIconButton(
            buttonType: ButtonType.small,
            iconName: Icons.edit,
            buttonName: 'Edit',
            onClick: () {},
            buttonColor: AppColors.primary100,
          ),
        ),
      );
      final Finder finder = find.byType(BaseIconButton);

      expect(finder, findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });
    testWidgets('', (WidgetTester tester) async {
      int count = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: BaseIconButton(
            buttonType: ButtonType.small,
            iconName: Icons.edit,
            buttonName: 'Edit',
            onClick: () {
              count++;
            },
            buttonColor: AppColors.primary100,
          ),
        ),
      );
      expect(count, equals(0));

      await tester.tap(find.text('Edit'));
      await tester.pump();

      expect(count, equals(1));

    });
  });
}
