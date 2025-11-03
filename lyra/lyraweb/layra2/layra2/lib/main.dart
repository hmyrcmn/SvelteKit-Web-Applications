import 'package:flutter/material.dart';
import 'package:layra2/ui/widgets/mic_button.dart';
import 'package:layra2/services/speech_services.dart';
import 'package:layra2/services/tts_services.dart';
import 'package:layra2/utils/command_parser.dart';
import 'package:layra2/utils/json_handler.dart';
import 'package:layra2/models/command_model.dart';
import 'package:provider/provider.dart';
import 'package:layra2/services/app_state.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        home: MainScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    ),
  );
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final SpeechService _speech = SpeechService();
  final TtsService _tts = TtsService();
  final CommandParser _parser = CommandParser();
  final JsonHandler _jsonHandler = JsonHandler();
  bool _isInitialized = false;
  bool _isLoading = true;
  int _retryCount = 0;
  static const int maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      final micStatus = await Permission.microphone.request();
      if (micStatus.isDenied) {
        appState.setError("Mikrofon izni gerekli");
        appState.setStatus("İzin Reddedildi");
        return;
      }

      final speechStatus = await Permission.speech.request();
      if (speechStatus.isDenied) {
        appState.setError("Ses izni gerekli");
        appState.setStatus("İzin Reddedildi");
        return;
      }

      await _initializeServices();
    } catch (e) {
      appState.setError("İzin kontrolü başarısız: ${e.toString()}");
      appState.setStatus("Hata");
    }
  }

  Future<void> _initializeServices() async {
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      setState(() => _isLoading = true);

      // Önce TTS'i başlat
      await _tts.initialize();

      // Sonra ses tanıma servisini başlat
      final speechInitialized = await _speech.initialize();
      if (!speechInitialized) {
        throw Exception('Ses tanıma servisi başlatılamadı');
      }

      await _tts.speak("Sistem hazır");
      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
      appState.setStatus("Hazır");
    } catch (e) {
      if (_retryCount < maxRetries) {
        _retryCount++;
        appState.setStatus("Yeniden deneniyor... (${_retryCount}/$maxRetries)");
        await Future.delayed(Duration(seconds: 2));
        await _initializeServices();
      } else {
        setState(() => _isLoading = false);
        appState.setError("Servis başlatılamadı: ${e.toString()}");
        appState.setStatus("Hata");
      }
    }
  }

  Future<void> _activateAssistant() async {
    if (!_isInitialized) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setError("Sistem henüz hazır değil");
      return;
    }

    final appState = Provider.of<AppState>(context, listen: false);

    try {
      appState.setListening(true);
      appState.setError(null);

      final wakeWordResult = await _speech
          .listenOnce(language: 'tr_TR')
          .timeout(Duration(seconds: 10), onTimeout: () => null);

      if (wakeWordResult?.contains("hey layra") == true) {
        await _tts.stop(); // Önceki konuşmayı durdur
        await _tts.speak("Efendim");

        final commandResult = await _speech
            .listenOnce(language: 'tr_TR')
            .timeout(Duration(seconds: 10), onTimeout: () => null);

        if (commandResult != null && commandResult.isNotEmpty) {
          final parts = _parser.parseCommand(commandResult);
          final response = _parser.generateResponse(parts);
          await _tts.stop(); // Önceki konuşmayı durdur
          await _tts.speak(response);

          final newCommand = Command(
            komut: commandResult,
            konum: parts["konum"] ?? "",
            hedef: parts["hedef"] ?? "",
            eylem: parts["eylem"] ?? "",
            tarih: DateTime.now().toString(),
          );
          await _jsonHandler.saveCommand(newCommand);
          appState.setStatus(response);
        } else {
          await _tts.stop(); // Önceki konuşmayı durdur
          await _tts.speak("Komut algılanmadı.");
          appState.setStatus("Komut algılanmadı.");
        }
      } else {
        await _tts.stop(); // Önceki konuşmayı durdur
        await _tts.speak("Wake word algılanmadı.");
        appState.setStatus("Wake word algılanmadı.");
      }
    } catch (e) {
      appState.setError(e.toString());
      appState.setStatus("Bir hata oluştu");
      await _tts.stop(); // Önceki konuşmayı durdur
      await _tts.speak("Bir hata oluştu. Lütfen tekrar deneyin.");
    } finally {
      appState.setListening(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/bg.png",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.blue);
            },
          ),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Sistem başlatılıyor...",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          if (!_isLoading) ...[
            Consumer<AppState>(
              builder: (context, appState, child) => Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        appState.status,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      if (appState.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: [
                              Text(
                                appState.error!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: _checkPermissions,
                                child: Text(
                                  "Yeniden Dene",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Consumer<AppState>(
              builder: (context, appState, child) => Align(
                alignment: Alignment.bottomCenter,
                child: MicButton(
                  isListening: appState.isListening,
                  onPressed: _activateAssistant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
