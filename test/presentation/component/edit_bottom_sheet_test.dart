import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photopin/core/enums/button_type.dart';
import 'package:photopin/presentation/component/base_button.dart';
import 'package:photopin/presentation/component/edit_bottom_sheet.dart';
import 'package:photopin/presentation/component/text_limit_input_field.dart';

final String comment = 'A';
final List<String> journalNames = ['Journal 1', 'Journal 2'];
final String imageUrl = '';
final DateTime dateTime = DateTime(2025, 05, 07, 15, 30);

void main() {
  testWidgets('버튼 클릭 시 EditBottomSheet가 열리고 구성 요소가 정상적으로 보여야한다.', (
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
                            return EditBottomSheet(
                              comment: comment,
                              dateTime: dateTime,
                              journalNames: journalNames,
                              imageUrl: imageUrl,
                              onTapApply:
                                  (String journalName, String comment) {},
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

      expect(find.byType(EditBottomSheet), findsOneWidget);
      expect(find.text(comment), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
      expect(find.byIcon(Icons.comment), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.note), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
    });
  });

  testWidgets(
    'EditBottomSheet의 close 아이콘을 탭하면 onTapClose 콜백과 onClosing 콜백이 호출되고 EditBottomSheet가 닫혀야한다.',
    (WidgetTester tester) async {
      bool tappedClose = false;
      bool calledClosing = false;

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
                              return EditBottomSheet(
                                comment: comment,
                                dateTime: dateTime,
                                journalNames: journalNames,
                                imageUrl: imageUrl,
                                onTapApply:
                                    (String journalName, String comment) {},
                                onTapCancel: () {},
                                onClosing: () => calledClosing = true,
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
          find.byType(EditBottomSheet),
          findsNothing,
          reason: 'EditBottomSheet가 닫히지 않음',
        );
        expect(tappedClose, true, reason: 'tappedClose가 true로 변경되지 않음');
        expect(calledClosing, true, reason: 'calledClosing이 true로 변경되지 않음');
      });
    },
  );

  testWidgets(
    'EditBottomSheet를 변경하고 Apply를 탭하면 onTapApply 콜백 함수로 journalName과 comment의 값이 반환되야한다.',
    (WidgetTester tester) async {
      await mockNetworkImagesFor(() async {
        String expectJournalName = '';
        String expectComment = '';

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
                              return EditBottomSheet(
                                comment: comment,
                                dateTime: dateTime,
                                journalNames: journalNames,
                                imageUrl: imageUrl,
                                onTapApply: (
                                  String journalName,
                                  String comment,
                                ) {
                                  expectJournalName = journalName;
                                  expectComment = comment;
                                },
                                onTapCancel: () {},
                                onClosing: () {},
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

        await tester.enterText(find.byType(TextLimitInputField), 'Hello');
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('Apply'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Apply'));
        await tester.pumpAndSettle();

        expect(expectComment, 'Hello');
        expect(expectJournalName, journalNames[0]);
      });
    },
  );

  testWidgets('EditBottomSheet의 Cancel을 탭하면 onTapCancel 콜백이 호출되야한다.', (
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
                            return EditBottomSheet(
                              comment: comment,
                              dateTime: dateTime,
                              journalNames: journalNames,
                              imageUrl: imageUrl,
                              onTapApply:
                                  (String journalName, String comment) {},
                              onTapCancel: () {
                                Navigator.pop(context);
                              },
                              onClosing: () {},
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
        find.byType(EditBottomSheet),
        findsNothing,
        reason: 'EditBottomSheet가 닫히지 않음',
      );
    });
  });
}
