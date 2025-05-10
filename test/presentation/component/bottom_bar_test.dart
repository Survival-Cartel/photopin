import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/bottom_bar.dart';

void main() {
  group('Battombar 테스트', () {
    testWidgets('홈 Icon 클릭시 홈버튼은 primary100 나머지는 gray2 색 이어야 한다', (
      WidgetTester tester,
    ) async {
      int selectedIndex = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: StatefulBuilder(
              builder: (context, setState) {
                return BottomBar(
                  selectedIndex: selectedIndex,
                  changeTab: (i) => setState(() => selectedIndex = i),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      final homeIconFinder = find.byIcon(Icons.home);
      expect(homeIconFinder, findsOneWidget);

      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home));
      final bookIcon = tester.widget<Icon>(find.byIcon(Icons.book));
      final photoIcon = tester.widget<Icon>(find.byIcon(Icons.photo));
      final settingsIcon = tester.widget<Icon>(find.byIcon(Icons.settings));

      expect(homeIcon.color, AppColors.primary100);
      expect(bookIcon.color, AppColors.gray2);
      expect(photoIcon.color, AppColors.gray2);
      expect(settingsIcon.color, AppColors.gray2);
    });
    testWidgets('북 Icon 클릭시 맵버튼은 secondary100 나머지는 gray2 색 이어야 한다', (
      WidgetTester tester,
    ) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: StatefulBuilder(
              builder: (context, setState) {
                return BottomBar(
                  selectedIndex: selectedIndex,
                  changeTab: (i) => setState(() => selectedIndex = i),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.book));
      await tester.pump();

      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home));
      final bookIcon = tester.widget<Icon>(find.byIcon(Icons.book));
      final photoIcon = tester.widget<Icon>(find.byIcon(Icons.photo));
      final settingsIcon = tester.widget<Icon>(find.byIcon(Icons.settings));

      expect(bookIcon.color, AppColors.secondary100);
      expect(homeIcon.color, AppColors.gray2);
      expect(photoIcon.color, AppColors.gray2);
      expect(settingsIcon.color, AppColors.gray2);
    });
    testWidgets('포토 Icon 클릭시 포토버튼은 marker80 나머지는 gray2 색 이어야 한다', (
      WidgetTester tester,
    ) async {
      int selectedIndex = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: StatefulBuilder(
              builder: (context, setState) {
                return BottomBar(
                  selectedIndex: selectedIndex,
                  changeTab: (i) => setState(() => selectedIndex = i),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.photo));
      await tester.pump();

      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home));
      final bookIcon = tester.widget<Icon>(find.byIcon(Icons.book));
      final photoIcon = tester.widget<Icon>(find.byIcon(Icons.photo));
      final settingsIcon = tester.widget<Icon>(find.byIcon(Icons.settings));

      expect(photoIcon.color, AppColors.marker80);
      expect(bookIcon.color, AppColors.gray2);
      expect(homeIcon.color, AppColors.gray2);
      expect(settingsIcon.color, AppColors.gray2);
    });
    testWidgets('세팅 Icon 클릭시 세팅버튼은 marker100 나머지는 gray2 색 이어야 한다', (
      WidgetTester tester,
    ) async {
      int selectedIndex = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: StatefulBuilder(
              builder: (context, setState) {
                return BottomBar(
                  selectedIndex: selectedIndex,
                  changeTab: (i) => setState(() => selectedIndex = i),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();

      final homeIcon = tester.widget<Icon>(find.byIcon(Icons.home));
      final bookIcon = tester.widget<Icon>(find.byIcon(Icons.book));
      final photoIcon = tester.widget<Icon>(find.byIcon(Icons.photo));
      final settingsIcon = tester.widget<Icon>(find.byIcon(Icons.settings));

      expect(settingsIcon.color, AppColors.marker100);
      expect(bookIcon.color, AppColors.gray2);
      expect(photoIcon.color, AppColors.gray2);
      expect(homeIcon.color, AppColors.gray2);
    });
  });
}
