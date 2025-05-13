import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photopin/core/styles/app_color.dart';
import 'package:photopin/presentation/component/photopin_map.dart';

void main() {
  group('photopin map component 테스트 : ', () {
    testWidgets('제대로 생성되어야 한다.', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhotoPinMap(
              key: ValueKey('testKey'),
              initialLocation: LatLng(37.5125, 127.1025),
              initialZoomLevel: 10,
              markers: {},
              polylines: {},
              polyLineColor: AppColors.marker50,
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('testKey')), findsOneWidget);
    });
    testWidgets('marker가 제대로 생성되어야 한다.', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoPinMap(
              key: const ValueKey('testKey'),
              initialLocation: const LatLng(37.5125, 127.1025),
              initialZoomLevel: 10,
              markers: {
                const Marker(
                  markerId: MarkerId('testMarker'),
                  position: LatLng(37.5125, 127.1025),
                ),
              },
              polylines: const {},
              polyLineColor: AppColors.marker50,
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate((w) {
          if (w is GoogleMap) {
            return w.markers.any((m) => m.markerId.value == 'testMarker');
          }
          return false;
        }),
        findsOneWidget,
      );
    });
    // testWidgets('polyline이 제대로 생성되어야 한다.', (tester) async {
    //   await tester.pumpWidget(
    //     MaterialApp(
    //       home: Scaffold(
    //         body: PhotoPinMap(
    //           key: const ValueKey('testKey'),
    //           initialLocation: const LatLng(37.5125, 127.1025),
    //           initialZoomLevel: 18,
    //           markers: {
    //             const Marker(
    //               markerId: MarkerId('testMarker'),
    //               position: LatLng(37.5125, 127.1025),
    //             ),
    //           },
    //           polylines: const {
    //             'testPolyline': [
    //               LatLng(37.5125, 127.1025),
    //               LatLng(37.5123, 127.1021),
    //             ],
    //           },
    //           polyLineColor: AppColors.marker50,
    //         ),
    //       ),
    //     ),
    //   );

    //   expect(
    //     find.byWidgetPredicate((w) {
    //       if (w is GoogleMap) {
    //         return w.polylines.any((m) => m.polylineId.value == 'testPolyline');
    //       }
    //       return false;
    //     }),
    //     findsOneWidget,
    //   );
    // });
  });
}
