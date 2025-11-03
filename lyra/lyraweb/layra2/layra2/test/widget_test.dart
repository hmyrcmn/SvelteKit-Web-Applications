// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layra2/main.dart';
import 'package:provider/provider.dart';
import 'package:layra2/services/app_state.dart';
import 'package:layra2/ui/widgets/mic_button.dart';

void main() {
  testWidgets('MainScreen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(home: MainScreen()),
      ),
    );

    // Wait for the first frame to be rendered
    await tester.pumpAndSettle();

    // Verify that the initial status is "Hazır"
    expect(find.text('Hazır'), findsOneWidget);

    // Verify that the mic button is present
    expect(find.byType(MicButton), findsOneWidget);

    // Verify that the background image is present
    expect(find.byType(Image), findsOneWidget);
  });
}
