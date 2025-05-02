import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/compare_card.dart';

void main() {
  group('compare card 컴포넌트 테스트 : ', () {
    testWidgets('제대로 생성되어야 한다.', (tester) async {
      await mockNetworkImagesFor(
        () async => await tester.pumpWidget(
          MaterialApp(
            home: CompareCard(
              profileImageUrl: 'https://avatar.iran.liara.run/public/35',
              nameString: 'Jea Visit',
              color: AppColors.primary100,
              dateTime: DateTime.now(),
              timeMessage: 'Spent 45 minutes',
              photoMessage: 'Took 4 photos',
              location: 'Seoul',
            ),
          ),
        ),
      );

      expect(find.text('Jea Visit'), findsOneWidget);
    });
  });
}
