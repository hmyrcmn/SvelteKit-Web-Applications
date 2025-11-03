import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _tts.setLanguage("tr-TR");
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _isInitialized = true;
      print("[TTS] TTS başarıyla başlatıldı");
    } catch (e) {
      print("[TTS_ERROR] TTS başlatma hatası: $e");
      _isInitialized = false;
      rethrow;
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      print("[TTS_START] TTS konuşma başlıyor: $text");
      await _tts.speak(text);
      _tts.setCompletionHandler(() {
        print("[TTS_COMPLETE] Konuşma tamamlandı");
      });
    } catch (e) {
      print("[TTS_ERROR] TTS hatası: $e");
      // Hata durumunda yeniden başlatmayı dene
      _isInitialized = false;
      await initialize();
      // Tekrar konuşmayı dene
      try {
        await _tts.speak(text);
      } catch (e) {
        print("[TTS_ERROR] İkinci deneme hatası: $e");
        rethrow;
      }
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      print("[TTS_ERROR] Durdurma hatası: $e");
    }
  }
}
