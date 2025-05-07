import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/location/domain/model/location_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';
import 'package:photopin/presentation/component/journal_card.dart';

void main() {
  group('journey card 컴포넌트 테스트 : ', () {
    final DateTime startDate = DateTime(2025, 04, 21);
    final DateTime endDate = DateTime(2025, 04, 30);

    final JournalModel journal = JournalModel(
      id: 'testJournal',
      name: 'Paris Getaway',
      tripWith: ['유제환', '최준성', '최은렬', '최따이호'],
      startDate: startDate,
      endDate: endDate,
      photos: [
        PhotoModel(
          id: 'testPhoto',
          name: 'road to master',
          dateTime: DateTime.now(),
          journalId: 'testJournal',
          imageUrl: '',
          location: const LocationModel(latitude: 0, longitude: 0),
          comment: '뭐',
        ),
      ],
      comment:
          'Breathtaking architecture! The light through the stained glass was magical.',
    );

    testWidgets('제대로 생성되어야 한다.', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(home: JournalCard(journal: journal, onTap: () {})),
        );
      });

      expect(find.text(journal.name), findsOneWidget);
    });
    testWidgets('카드 클릭시 콜백이 작동되어야 한다.', (tester) async {
      int testValue = 0;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: JournalCard(
                  journal: journal,
                  onTap: () {
                    testValue += 1;
                  },
                ),
              ),
            ),
          ),
        );
      });

      await tester.tap(find.byType(JournalCard));
      await tester.pump(); // 탭 이벤트 후 UI 갱신을 기다림

      expect(testValue, 1);
    });
  });
}
