import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/main_icon_card.dart';

void main() {
  group('main icon card 컴포넌트 테스트 : ', () {
    const String cardTitle = 'New Photo';

    testWidgets('제대로 생성되어야 한다.', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MainIconCard(
            iconColor: AppColors.primary100,
            iconData: CupertinoIcons.camera,
            title: cardTitle,
            onTap: () {},
          ),
        ),
      );

      final Finder finder = find.text(cardTitle);

      expect(finder, findsOneWidget);
    });

    testWidgets('카드 클릭시 콜백이 작동 되어야 한다.', (tester) async {
      int testValue = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: MainIconCard(
            iconColor: AppColors.primary100,
            iconData: CupertinoIcons.camera,
            title: cardTitle,
            onTap: () {
              testValue += 1;
            },
          ),
        ),
      );

      final Finder finder = find.byType(MainIconCard);

      await tester.tap(finder);
      await tester.pump();

      expect(testValue, 1);
    });
  });
}
