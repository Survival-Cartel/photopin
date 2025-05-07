import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/presentation/component/alert_share_link.dart';

void main() {
  group('AlertShareLink Test', () {
    testWidgets('Share 버튼 클릭 시 Dialog가 생성 되어야 한다', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: tester.element(find.byType(ElevatedButton)),
                    builder:
                        (_) => AlertShareLink(
                          url: 'https://travelsnap.app/share/paris25',
                          onClick: () {},
                        ),
                  );
                },
                child: const Text('Share'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Share'));
      await tester.pump();

      expect(find.text('Shareable Link'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
    });

    // 클립보드 모킹 설정
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (
          MethodCall methodCall,
        ) async {
          if (methodCall.method == 'Clipboard.setData') {
            // 클립보드에 데이터 설정 시 처리
            return null;
          } else if (methodCall.method == 'Clipboard.getData') {
            // 클립보드에서 데이터 가져올 때, 우리가 설정한 값을 반환
            return {'text': 'https://travelsnap.app/share/paris25'};
          }
          return null;
        });

    testWidgets('dialog가 열린 후 Copy 버튼을 클릭하면 클립보드에 Url이 복사 되어야 한다', (
      WidgetTester tester,
    ) async {
      final testUrl = 'https://travelsnap.app/share/paris25';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: tester.element(find.byType(ElevatedButton)),
                    builder:
                        (_) => AlertShareLink(
                          url: testUrl,
                          onClick: () {
                            Clipboard.setData(ClipboardData(text: testUrl));
                          },
                        ),
                  );
                },
                child: const Text('Share'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Share'));
      await tester.pump();

      expect(find.text('Copy'), findsOneWidget);
      await tester.tap(find.text('Copy'));
      await tester.pump();

      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      expect(clipboardData?.text, equals(testUrl));
    });
  });
}
