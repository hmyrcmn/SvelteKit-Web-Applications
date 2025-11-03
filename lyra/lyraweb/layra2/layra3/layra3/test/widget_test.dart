// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layra3/main.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  testWidgets('Voice Assistant UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the microphone button exists
    expect(find.byIcon(Icons.mic_none), findsOneWidget);

    // Verify that the app title is correct
    expect(find.text('Layra Asistan'), findsOneWidget);

    // Verify initial state
    expect(find.text('Hazır'), findsOneWidget);

    // Tap the microphone button
    await tester.tap(find.byIcon(Icons.mic_none));
    await tester.pump();

    // Verify that the microphone icon changes to active state
    expect(find.byIcon(Icons.mic), findsOneWidget);

    // Verify that the status changes
    expect(find.text('Dinleniyor...'), findsOneWidget);
  });

  test('SpeechToText initialization test', () async {
    final speechToText = SpeechToText();
    final available = await speechToText.initialize();
    expect(available, isTrue);
  });

  test('FlutterTts initialization test', () async {
    final flutterTts = FlutterTts();
    final languages = await flutterTts.getLanguages;
    expect(languages, isNotNull);
  });
}
