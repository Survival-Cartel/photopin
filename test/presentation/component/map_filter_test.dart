import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/map_filter.dart'; // 실제 MapFilter 경로로 수정 필요

void main() {
  group('MapFilter 위젯 테스트', () {
    testWidgets('Icon과 Label의 갯수가 1:1 매칭되지 않을 시 ArgumentError가 발생합니다.', (
      WidgetTester tester,
    ) async {
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

    testWidgets('초기 인덱스를 n으로 설정하면 해당 인덱스의 항목이 선택된 상태로 표시됩니다.', (
      WidgetTester tester,
    ) async {
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
      final selectedItem = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == AppColors.primary100,
      );

      expect(selectedItem, findsOneWidget);

      // 선택된 항목에 labels[initialIndex] 텍스트가 있는지 확인
      final selectedItemText = find.descendant(
        of: selectedItem,
        matching: find.text(labels[initialIndex]),
      );
      expect(selectedItemText, findsOneWidget);
    });
  });

  testWidgets('탭을 누르면 해당 항목이 선택되어 콜백이 호출되고 UI가 올바르게 업데이트됩니다.', (
    WidgetTester tester,
  ) async {
    // Arrange: 3개의 아이콘과 라벨, 초기 선택 인덱스 0으로 MapFilter를 렌더링합니다.
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

    // Assert: 초기 상태에서 첫 번째 항목만 선택되어 primary100 배경색을 가집니다.
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == AppColors.primary100,
      ),
      findsOneWidget,
    );

    // Act: 'Photos' 텍스트(세 번째 탭)를 탭합니다.
    await tester.tap(find.text('Photos'));
    await tester.pump();

    // Assert: onSelected 콜백이 2번 인덱스로 호출되어 selectedIndex가 2가 됩니다.
    expect(selectedIndex, 2);

    // Assert: UI에서 primary100 배경색을 가진 컨테이너가 하나만 존재하며,
    // 해당 컨테이너에 'Photos' 텍스트가 포함되어 있습니다.
    final selectedContainers = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == AppColors.primary100,
    );

    expect(selectedContainers, findsOneWidget);

    final selectedItemText = find.descendant(
      of: selectedContainers.first,
      matching: find.text('Photos'),
    );
    expect(selectedItemText, findsOneWidget);
  });

  testWidgets('MapFilter의 각 아이템이 Expanded로 감싸져 있어 모든 항목이 동일한 공간을 차지해야 합니다.', (
    WidgetTester tester,
  ) async {
    // Arrange: 3개의 아이콘과 라벨을 가진 MapFilter를 렌더링합니다.
    const icons = [
      Icon(Icons.access_time),
      Icon(Icons.local_fire_department),
      Icon(Icons.photo),
    ];
    const labels = ['Time', 'Heat Map', 'Photos'];

    // Act: MapFilter 위젯을 빌드합니다.
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

    // Assert: 각 아이템이 Expanded로 감싸져 있어 3개의 Expanded 위젯이 존재함을 확인합니다.
    final expandedWidgets = find.byType(Expanded);
    expect(expandedWidgets, findsNWidgets(3));
  });

  testWidgets(
    '선택된 항목의 텍스트 색상과 선택되지 않은 항목의 텍스트 색상이 달라지는지 확인합니다.',
    (WidgetTester tester) async {
      // Arrange: 2개의 아이콘과 라벨, 초기 선택 인덱스 0으로 MapFilter를 렌더링합니다.
      const icons = [
        Icon(Icons.access_time),
        Icon(Icons.local_fire_department),
      ];
      const labels = ['Time', 'Heat Map'];

      // Act: MapFilter 위젯을 빌드합니다.
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

      // Assert: 선택된 항목('Time')의 텍스트 색상이 Colors.white임을 확인합니다.
      final selectedText = find.text('Time');
      final selectedTextWidget = tester.widget<Text>(selectedText);
      expect(selectedTextWidget.style?.color, Colors.white);

      // Assert: 선택되지 않은 항목('Heat Map')의 텍스트 색상이 AppColors.gray1임을 확인합니다.
      final unselectedText = find.text('Heat Map');
      final unselectedTextWidget = tester.widget<Text>(unselectedText);
      expect(unselectedTextWidget.style?.color, AppColors.gray1);

      // Assert: 선택된 항목의 컨테이너 배경색이 AppColors.primary100이고, 선택되지 않은 항목의 컨테이너 배경색이 AppColors.gray4임을 확인합니다.
      final containers = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.borderRadius != null;
        }
        return false;
      });

      final containerWidgets =
          tester.widgetList<Container>(containers).toList();

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

      expect(
        selectedContainer != null,
        true,
        reason: '선택된 항목의 컨테이너가 존재해야 합니다.',
      );
      expect(
        unselectedContainer != null,
        true,
        reason: '선택되지 않은 항목의 컨테이너가 존재해야 합니다.',
      );
      expect(
        (selectedContainer!.decoration as BoxDecoration).color,
        AppColors.primary100,
        reason: '선택된 항목의 배경색이 AppColors.primary100이어야 합니다.',
      );
      expect(
        (unselectedContainer!.decoration as BoxDecoration).color,
        AppColors.gray4,
        reason: '선택되지 않은 항목의 배경색이 AppColors.gray4이어야 합니다.',
      );
    },
  );
}
