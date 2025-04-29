import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photopin/presentation/component/journey_card.dart';

void main() {
  group('journey card 컴포넌트 테스트 : ', () {
    const String cardTitle = 'Barcelona Adventure';
    final DateTime startDate = DateTime(2025, 04, 21);
    final DateTime endDate = DateTime(2025, 04, 30);

    testWidgets('제대로 생성되어야 한다.', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: JourneyCard(
              imageUrl: '',
              journeyTitle: cardTitle,
              markerCount: 12,
              photoCount: 42,
              startDate: startDate,
              endDate: endDate,
              onTap: () {},
            ),
          ),
        );
      });

      expect(find.text(cardTitle), findsOneWidget);
    });
    testWidgets('카드 클릭시 콜백이 작동되어야 한다.', (tester) async {
      int testValue = 0;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: JourneyCard(
                  imageUrl: '',
                  journeyTitle: cardTitle,
                  markerCount: 12,
                  photoCount: 42,
                  startDate: startDate,
                  endDate: endDate,
                  onTap: () {
                    testValue += 1;
                  },
                ),
              ),
            ),
          ),
        );
      });

      await tester.tap(find.byType(JourneyCard));
      await tester.pump(); // 탭 이벤트 후 UI 갱신을 기다림

      expect(testValue, 1);
    });
  });
}
