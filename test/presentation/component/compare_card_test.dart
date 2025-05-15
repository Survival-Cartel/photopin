import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/compare_card.dart';

void main() {
  group('compare card 컴포넌트 테스트 : ', () {
    testWidgets('제대로 생성되어야 한다.', (tester) async {
      await mockNetworkImagesFor(
        () async => await tester.pumpWidget(
          const MaterialApp(
            home: CompareCard(
              profileImageUrl: 'https://avatar.iran.liara.run/public/35',
              nameString: 'Jea Visit',
              color: AppColors.primary100,
              journal: JournalModel(
                id: '',
                name: '',
                tripWith: [],
                startDateMilli: 0,
                endDateMilli: 0,
                comment: '',
              ),
              photoString: '',
            ),
          ),
        ),
      );

      expect(find.text('Jea Visit'), findsOneWidget);
    });
  });
}
