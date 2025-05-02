import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/presentaion/component/date_range_slider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() {
  group('DateRangeSlider 테스트', () {
    testWidgets('DateRangeSlider 생성되어야 한다', (tester) async {
      final start = DateTime(2025, 4, 1);
      final end = DateTime(2025, 6, 2);
      DateTime? cbStart, cbEnd;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangeSlider(
              startDate: start,
              endDate: end,
              onChanged: (s, e) {
                cbStart = s;
                cbEnd = e;
                print('>>> onChanged fired: $s ~ $e');
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final finder = find.byType(SfRangeSlider);
      expect(finder, findsOneWidget);
    });

    testWidgets('DateRangeSlider onChanged 날짜가 바뀌어서 전달되어야 한다', (tester) async {
      final start = DateTime(2025, 4, 1);
      final end = DateTime(2025, 6, 2);
      DateTime? cbStart, cbEnd;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateRangeSlider(
              startDate: start,
              endDate: end,
              onChanged: (s, e) {
                cbStart = s;
                cbEnd = e;
                print('>>> onChanged fired: $s ~ $e');
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final finder = find.byType(SfRangeSlider);
      final SfRangeSlider slider = tester.widget(finder);

      final newS = DateTime(2025, 5, 5);
      final newE = DateTime(2025, 5, 20);
      slider.onChanged!(SfRangeValues(newS, newE));

      await tester.pump(const Duration(milliseconds: 300));

      expect(cbStart, equals(DateTime(2025, 5, 5)));
      expect(cbEnd, equals(DateTime(2025, 5, 20)));
    });
  });
}
