import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/base_icon.dart';

void main() {
  group('base icon 컴포넌트 테스트', () {
    testWidgets('제대로 생성되어야 한다.', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BaseIcon(
            iconColor: AppColors.primary100,
            size: 20,
            iconData: CupertinoIcons.link,
          ),
        ),
      );

      final Finder finder = find.byIcon(CupertinoIcons.link);

      expect(finder, findsOneWidget);
    });
  });
}
