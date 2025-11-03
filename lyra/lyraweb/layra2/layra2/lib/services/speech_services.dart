import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();

  Future<bool> initialize() async {
    return await _speech.initialize(
      onStatus: (status) => print('Ses durumu: $status'),
      onError: (error) => print('Hata: $error'),
    );
  }

  Future<String?> listenOnce({required String language}) async {
    String? recognizedText;

    await _speech.listen(
      localeId: language, // Türkçe: 'tr_TR'
      cancelOnError: true,
      onResult: (SpeechRecognitionResult result) {
        recognizedText = result.recognizedWords;
      },
    );

    await Future.delayed(Duration(seconds: 5)); // 5 saniye dinle
    await _speech.stop();
    return recognizedText;
  }
}
