import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';

class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  Future<bool> initialize({Function(String)? onStatus, Function(dynamic)? onError}) async {
    try {
      return await _speech.initialize(
        onStatus: onStatus,
        onError: onError,
      );
    } catch (e) {
      onError?.call(e);
      return false;
    }
  }

  void listen({required Function(String) onResult}) {
    _speech.listen(
      onResult: (val) => onResult(val.recognizedWords),
      listenMode: stt.ListenMode.dictation,
      onSoundLevelChange: null,
      cancelOnError: true,
      partialResults: false,
    );
  }

  void stop() {
    _speech.stop();
  }

  Future<void> speak(String text) async {
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('TTS error: $e');
    }
  }

  Future<void> speakAndWait(String text) async {
    try {
      final completer = Completer<void>();
      _flutterTts.setCompletionHandler(() {
        if (!completer.isCompleted) completer.complete();
      });
      await _flutterTts.speak(text);
      await completer.future;
    } catch (e) {
      debugPrint('TTS error: $e');
    }
  }

  void dispose() {
    _speech.stop();
    _flutterTts.stop();
  }
}
