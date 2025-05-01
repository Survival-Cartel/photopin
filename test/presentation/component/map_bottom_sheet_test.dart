import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:photopin/presentation/component/map_bottom_sheet.dart';

void main() {
  const String title = 'Seoul';
  const String imageUrl = '';
  const String location = 'Gangnam';
  const String comment = '서울 최고';
  final DateTime dateTime = DateTime.parse('2025-05-01 16:00:00');

  testWidgets('버튼 클릭 시 MapBottomSheet가 열리고 구성 요소가 정상적으로 보여야한다.', (
    WidgetTester tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SafeArea(
              child: Builder(
                builder: (context) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return MapBottomSheet(
                              title: title,
                              location: location,
                              imageUrl: imageUrl,
                              comment: comment,
                              dateTime: dateTime,
                              onTapEdit: () {},
                              onTapShare: () {},
                              onTapClose: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      child: const Text('Show BottomSheet'),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Show BottomSheet'));
      await tester.pumpAndSettle();

      expect(find.byType(MapBottomSheet), findsOneWidget);
      expect(find.text('Seoul'), findsOneWidget);
      expect(find.text('Gangnam'), findsOneWidget);
      expect(find.text('서울 최고'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.comment), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(MapBottomSheet), findsNothing);
    });
  });

  testWidgets(
    'MapBottomSheet의 닫기 아이콘을 탭하면 MapBottomSheet가 정상적으로 닫히면서 콜백이 호출되어야 한다.',

    (WidgetTester tester) async {
      bool isClosing = false;
      bool isTapped = false;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SafeArea(
                child: Builder(
                  builder: (context) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return MapBottomSheet(
                                title: title,
                                location: location,
                                imageUrl: imageUrl,
                                comment: comment,
                                dateTime: dateTime,
                                onTapEdit: () {},
                                onTapShare: () {},
                                onTapClose: () {
                                  isTapped = true;
                                  Navigator.pop(context);
                                },
                                onClosing: () {
                                  isClosing = true;
                                },
                              );
                            },
                          );
                        },
                        child: const Text('Show BottomSheet'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.text('Show BottomSheet'));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();

        expect(find.byType(MapBottomSheet), findsNothing);
        expect(isClosing, true);
        expect(isTapped, true);
      });
    },
  );

  testWidgets(
    'MapBottomSheet의 Edit, Share 버튼을 탭하면 onTapEdit, onTapShare 콜백 함수가 실행되어야 한다.',
    (WidgetTester tester) async {
      bool isTapEdit = false;
      bool isTapShare = false;

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SafeArea(
                child: Builder(
                  builder: (context) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return MapBottomSheet(
                                title: title,
                                location: location,
                                imageUrl: imageUrl,
                                comment: comment,
                                dateTime: dateTime,
                                onTapEdit: () {
                                  isTapEdit = true;
                                },
                                onTapShare: () {
                                  isTapShare = true;
                                },
                                onTapClose: () {},
                              );
                            },
                          );
                        },
                        child: const Text('Show BottomSheet'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.text('Show BottomSheet'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Edit'));
        await tester.tap(find.text('Share'));

        expect(isTapShare, true);
        expect(isTapEdit, true);
      });
    },
  );
}
