import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/map_filter.dart'; // 실제 MapFilter 경로로 수정 필요

void main() {
  group('MapFilter 위젯 테스트', () {
    testWidgets('잘못된 입력시 ArgumentError 발생', (WidgetTester tester) async {
      // Arrange
      const icons = [Icon(Icons.access_time), Icon(Icons.photo)];
      const labels = ['Time', 'Photos', 'Extra']; // 길이가 일치하지 않음

      // Act & Assert
      expect(
        () => MapFilter(
          icons: icons,
          labels: labels,
          initialIndex: 0,
          onSelected: (index) {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    testWidgets('초기 인덱스가 올바르게 선택됨', (WidgetTester tester) async {
      // Arrange
      const icons = [
        Icon(Icons.access_time),
        Icon(Icons.local_fire_department),
        Icon(Icons.photo),
      ];
      const labels = ['Time', 'Heat Map', 'Photos'];
      const initialIndex = 1;
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapFilter(
              icons: icons,
              labels: labels,
              initialIndex: initialIndex,
              onSelected: (index) {},
            ),
          ),
        ),
      );

      // Assert
      final selectedItem = find.byWidgetPredicate((widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).color == AppColors.primary100
      );
      
      expect(selectedItem, findsOneWidget);
      
      // 선택된 항목에 히트맵 텍스트가 있는지 확인
      final selectedItemText = find.descendant(
        of: selectedItem,
        matching: find.text('Heat Map'),
      );
      expect(selectedItemText, findsOneWidget);
    });

    testWidgets('탭하면 선택된 항목이 변경됨', (WidgetTester tester) async {
      // Arrange
      const icons = [
        Icon(Icons.access_time),
        Icon(Icons.local_fire_department),
        Icon(Icons.photo),
      ];
      const labels = ['Time', 'Heat Map', 'Photos'];
      int selectedIndex = -1;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapFilter(
              icons: icons,
              labels: labels,
              initialIndex: 0,
              onSelected: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      // 초기 상태 확인
      expect(
        find.byWidgetPredicate((widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == AppColors.primary100
        ),
        findsOneWidget
      );
      
      // Act - 세 번째 탭(Photos)을 탭
      await tester.tap(find.text('Photos'));
      await tester.pump();

      // Assert
      // 1. 콜백이 호출되었는지 확인
      expect(selectedIndex, 2);
      
      // 2. UI가 업데이트되었는지 확인
      final selectedContainers = find.byWidgetPredicate((widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).color == AppColors.primary100
      );
      
      expect(selectedContainers, findsOneWidget);
      
      // 선택된 항목에 'Photos' 텍스트가 있는지 확인
      final selectedItemText = find.descendant(
        of: selectedContainers.first,
        matching: find.text('Photos'),
      );
      expect(selectedItemText, findsOneWidget);
    });

    testWidgets('모든 아이템이 Expanded로 감싸져 있는지 확인', (WidgetTester tester) async {
      // Arrange
      const icons = [
        Icon(Icons.access_time),
        Icon(Icons.local_fire_department),
        Icon(Icons.photo),
      ];
      const labels = ['Time', 'Heat Map', 'Photos'];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapFilter(
              icons: icons,
              labels: labels,
              initialIndex: 0,
              onSelected: (index) {},
            ),
          ),
        ),
      );

      // Assert
      final expandedWidgets = find.byType(Expanded);
      expect(expandedWidgets, findsNWidgets(3)); // 3개의 Expanded 위젯이 있어야 함
    });
    
    testWidgets('선택된 항목과 선택되지 않은 항목의 스타일이 다른지 확인', (WidgetTester tester) async {
      // Arrange
      const icons = [
        Icon(Icons.access_time),
        Icon(Icons.local_fire_department),
      ];
      const labels = ['Time', 'Heat Map'];
      
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MapFilter(
              icons: icons,
              labels: labels,
              initialIndex: 0,
              onSelected: (index) {},
            ),
          ),
        ),
      );

      // Assert
      // 선택된 항목 (Time)
      final selectedText = find.text('Time');
      final selectedTextWidget = tester.widget<Text>(selectedText);
      expect(selectedTextWidget.style?.color, Colors.white);
      
      // 선택되지 않은 항목 (Heat Map)
      final unselectedText = find.text('Heat Map');
      final unselectedTextWidget = tester.widget<Text>(unselectedText);
      expect(unselectedTextWidget.style?.color, AppColors.gray1);
      
      // 컨테이너 배경색 확인
      final containers = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.borderRadius != null;
        }
        return false;
      });
      
      // 모든 일치하는 컨테이너 가져오기
      final containerWidgets = tester.widgetList<Container>(containers).toList();
      
      // 배경색으로 선택된/선택되지 않은 컨테이너 찾기
      Container? selectedContainer;
      Container? unselectedContainer;
      
      for (final container in containerWidgets) {
        if (container.decoration is BoxDecoration) {
          final decoration = container.decoration as BoxDecoration;
          if (decoration.color == AppColors.primary100) {
            selectedContainer = container;
          } else if (decoration.color == AppColors.gray4) {
            unselectedContainer = container;
          }
        }
      }
      
      expect(selectedContainer != null, true);
      expect(unselectedContainer != null, true);
      expect((selectedContainer!.decoration as BoxDecoration).color, AppColors.primary100);
      expect((unselectedContainer!.decoration as BoxDecoration).color, AppColors.gray4);
    });
  });
}