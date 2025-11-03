import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';
import 'dart:async';

/// Ses tanıma ve konuşma servisi
class VoiceService {
  // Singleton instance
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  // Servis nesneleri
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  // Durum değişkenleri
  bool _isInitialized = false;
  bool _isSpeaking = false;
  Timer? _silenceTimer;
  Timer? _noResponseTimer;

  // Callback'ler
  Function(String)? onStatusChange;
  Function(String)? onError;
  Function(String)? onFinalResult;
  Function()? onTtsComplete;
  Function()? onSilenceTimeout;
  Function(String)? onCommandComplete;
  Function()? onNoResponse;

  /// Servisi başlat
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Initialize speech recognition
      bool available = await _speech.initialize(
        onStatus: (status) {
          onStatusChange?.call(status);
          if (status == "done" && _isSpeaking) {
            _stopListening();
          }
        },
        onError: (error) => onError?.call(error.errorMsg),
      );

      // Initialize TTS
      await _flutterTts.setLanguage("tr-TR");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        onTtsComplete?.call();
      });

      _isInitialized = available;
      return available;
    } catch (e) {
      onError?.call("Initialization error: $e");
      return false;
    }
  }

  /// Dinlemeyi başlat
  Future<void> startListening({
    required Function(String) onResult,
    Duration? listenFor,
    Duration? pauseFor,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    _resetSilenceTimer();
    _startNoResponseTimer();

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
        _resetSilenceTimer();
        _noResponseTimer?.cancel();
      },
      listenMode: ListenMode.dictation,
      listenFor: listenFor,
      pauseFor: pauseFor,
    );
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 5), () {
      onSilenceTimeout?.call();
      _stopListening();
    });
  }

  void _startNoResponseTimer() {
    _noResponseTimer?.cancel();
    _noResponseTimer = Timer(const Duration(seconds: 10), () {
      onNoResponse?.call();
      _stopListening();
    });
  }

  /// Dinlemeyi durdur
  Future<void> stopListening() async {
    await _speech.stop();
    _silenceTimer?.cancel();
    _noResponseTimer?.cancel();
  }

  /// Konuşma başlat
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    _isSpeaking = true;
    await _flutterTts.speak(text);
  }

  bool get isSpeaking => _isSpeaking;

  /// Servisi kapat
  Future<void> dispose() async {
    await _speech.stop();
    await _flutterTts.stop();
    _silenceTimer?.cancel();
    _noResponseTimer?.cancel();
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    _silenceTimer?.cancel();
    _noResponseTimer?.cancel();
  }
}
