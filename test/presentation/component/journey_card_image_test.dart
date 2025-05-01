import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photopin/presentation/component/journey_card_image.dart';

void main() {
  group('share journey card 컴포넌트 테스트', () {
    const String journeyTitle = 'Paris Getaway';
    const int photoCount = 20;
    const int markerCount = 8;

    testWidgets('제대로 생성되어야 한다.', (tester) async {
      await mockNetworkImagesFor(
        () async => await tester.pumpWidget(
          MaterialApp(
            home: JourneyCardImage(
              imageUrl: '',
              journeyTitle: journeyTitle,
              description: '$photoCount photos, $markerCount locations',
            ),
          ),
        ),
      );

      final Finder finder = find.text(journeyTitle);

      expect(finder, findsOneWidget);
    });
  });
}
