import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/presentation/component/base_button.dart';
import 'package:photopin/presentation/component/journal_edit_bottom_sheet.dart';
import 'package:photopin/presentation/component/text_limit_input_field.dart';

import '../../journal/fixtures/journal_model_fixtures.dart';

final String comment = 'A';
final List<JournalModel> journals = journalModelFixtures;
final String imageUrl = '';
final DateTime dateTime = DateTime(2025, 05, 07, 15, 30);
final String title = 'trip';
final JournalModel journal = journalModelFixtures[0];

void main() {
  testWidgets('버튼 클릭 시 JournalEditBottomSheet가 열리고 구성 요소가 정상적으로 보여야한다.', (
    WidgetTester tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return SafeArea(
                  child: Center(
                    child: BaseButton(
                      buttonName: 'Open Bottom Sheet',
                      onClick: () {
                        showModalBottomSheet(
                          builder: (BuildContext context) {
                            return JournalEditBottomSheet(
                              comment: comment,
                              title: title,
                              thumbnailUrl: imageUrl,
                              onTapApply: (JournalModel journal) {},
                              onTapCancel: () {},
                              onTapClose: () {},
                              journal: journal,
                            );
                          },
                          context: context,
                        );
                      },
                      buttonType: ButtonType.small,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Bottom Sheet'));
      await tester.pumpAndSettle();

      expect(find.byType(JournalEditBottomSheet), findsOneWidget);
      expect(find.text(comment), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
      expect(find.byIcon(Icons.comment), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
    });
  });

  testWidgets(
    'JournalEditBottomSheet의 close 아이콘을 탭하면 onTapClose 콜백이 호출되고 JournalEditBottomSheet가 닫혀야한다.',
    (WidgetTester tester) async {
      bool tappedClose = false;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return SafeArea(
                    child: Center(
                      child: BaseButton(
                        buttonName: 'Open Bottom Sheet',
                        onClick: () {
                          showModalBottomSheet(
                            builder: (BuildContext context) {
                              return JournalEditBottomSheet(
                                comment: comment,
                                journal: journal,
                                title: title,
                                thumbnailUrl: imageUrl,
                                onTapApply: (JournalModel journal) {},
                                onTapCancel: () {},
                                onTapClose: () {
                                  tappedClose = true;
                                  Navigator.pop(context);
                                },
                              );
                            },
                            context: context,
                          );
                        },
                        buttonType: ButtonType.small,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Open Bottom Sheet'));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(
          find.byType(JournalEditBottomSheet),
          findsNothing,
          reason: 'JournalEditBottomSheet가 닫히지 않음',
        );
        expect(tappedClose, true, reason: 'tappedClose가 true로 변경되지 않음');
      });
    },
  );

  testWidgets(
    'JournalEditBottomSheet를 변경하고 Apply를 탭하면 onTapApply 콜백 함수로 journal을 반환하고, 해당 journal의 내용으로 업데이트 되야한다.',
    (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        String expectJournalName = 'N/A';
        String expectComment = 'N/A';
        List<String> expectTripWith = [];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return SafeArea(
                    child: Center(
                      child: BaseButton(
                        buttonName: 'Open Bottom Sheet',
                        onClick: () {
                          showModalBottomSheet(
                            builder: (BuildContext context) {
                              return JournalEditBottomSheet(
                                comment: comment,
                                title: title,
                                journal: journal,
                                thumbnailUrl: imageUrl,
                                onTapApply: (JournalModel journal) {
                                  expectJournalName = journal.name;
                                  expectComment = journal.comment;
                                  expectTripWith = journal.tripWith;
                                },
                                onTapCancel: () {},
                                onTapClose: () {},
                              );
                            },
                            context: context,
                          );
                        },
                        buttonType: ButtonType.small,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Open Bottom Sheet'));
        await tester.pumpAndSettle();

        // 제목 필드 찾기 및 업데이트
        await tester.enterText(
          find.byType(TextLimitInputField).first,
          'Spain Sagrada Famillia',
        );
        await tester.pumpAndSettle();

        // 코멘트 필드 찾기 및 업데이트
        await tester.enterText(
          find.byKey(const Key('comment_field')),
          'Sagrada',
        );
        await tester.pumpAndSettle();

        // tripWith 필드 찾기 및 업데이트
        await tester.enterText(
          find.byKey(const Key('trip_with_field')),
          '최태호, 아우아',
        );
        await tester.pumpAndSettle();

        // Apply 버튼 찾아서 탭하기
        await tester.ensureVisible(find.text('Apply'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Apply'));
        await tester.pumpAndSettle();

        expect(expectJournalName, journal.name);
        expect(expectComment, 'Sagrada');
        expect(expectTripWith, ['최태호', '아우아']);
      });
    },
  );

  testWidgets('JournalEditBottomSheet의 Cancel을 탭하면 onTapCancel 콜백이 호출되야한다.', (
    WidgetTester tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return SafeArea(
                  child: Center(
                    child: BaseButton(
                      buttonName: 'Open Bottom Sheet',
                      onClick: () {
                        showModalBottomSheet(
                          builder: (BuildContext context) {
                            return JournalEditBottomSheet(
                              comment: comment,
                              title: title,
                              journal: journal,
                              thumbnailUrl: imageUrl,
                              onTapApply: (JournalModel journal) {},
                              onTapCancel: () {
                                Navigator.pop(context);
                              },
                              onTapClose: () {},
                            );
                          },
                          context: context,
                        );
                      },
                      buttonType: ButtonType.small,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Bottom Sheet'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(
        find.byType(JournalEditBottomSheet),
        findsNothing,
        reason: 'JournalEditBottomSheet가 닫히지 않음',
      );
    });
  });
}
