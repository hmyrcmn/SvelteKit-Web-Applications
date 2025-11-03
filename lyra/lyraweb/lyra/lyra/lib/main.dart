import 'package:flutter/material.dart';
import 'dart:ui'; // ImageFilter için gerekli
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

// Sabitler
const String WAKE_WORD = "hey layra";
const String RESPONSE_TEXT = "Efendim";
const String JSON_PATH = "komutlar.json";
const String ENTITIES_PATH = "entities.json";
const String LANGUAGE = "tr-TR";
const Duration RETRY_DELAY = Duration(milliseconds: 1000);
const Duration LISTEN_TIMEOUT = Duration(
  seconds: 10,
); // Tetikleme kelimesi için genel dinleme süresi
const Duration COMMAND_TIMEOUT = Duration(
  seconds: 10,
); // Komut için dinleme süresi
const Duration SILENCE_TIMEOUT = Duration(
  seconds: 5,
); // Sessizlik zaman aşımı süresi

const List<String> WAKE_WORD_VARIATIONS = [
  "hey layra",
  // "hey layra", // Tekrar eden kaldırıldı
  "hey lara",
  "hey lera",
  "hey lira",
  "hey", // Bu çok genel, yanlış pozitiflere neden olabilir.
];

// Örnek komutlar ve geçerli eylemler
const List<String> SAMPLE_COMMANDS = [
  "salon ışıkları kapat",
  "mutfak ışıkları aç",
  "odanın perdesini kapat",
];
const List<String> VALID_ACTIONS = [
  "aç",
  "açık",
  "kapat",
  "kapa",
  "git",
  "gel",
  "getir",
  "götür",
];
const List<String> VALID_LOCATIONS = [
  "salon",
  "mutfak",
  "oda",
  "banyo",
  "koridor",
  "bahçe",
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await _initializeTurkishLocale(); // Tanımlı değil, MaterialApp içinde locale ayarı var.
  await initializeJson();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lyra Assistant',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Roboto'),
      home: const LyraFocusPage(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('tr', 'TR'), // Türkçe locale'i zorla
      supportedLocales: const [Locale('tr', 'TR')],
    );
  }
}

class LyraFocusPage extends StatefulWidget {
  const LyraFocusPage({super.key});
  @override
  State<LyraFocusPage> createState() => _LyraFocusPageState();
}

class _LyraFocusPageState extends State<LyraFocusPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const Color baseBlueColor = Color(0xFF0A2C7B);
    return Scaffold(
      backgroundColor: baseBlueColor,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundPainter(baseColor: baseBlueColor),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/lyra.png',
              width: screenSize.width * 0.7,
              height: screenSize.width * 0.7,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: screenSize.height * 0.18,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                icon: Icon(Icons.mic, size: 60, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LyraMicPage(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LyraMicPage extends StatefulWidget {
  const LyraMicPage({super.key});
  @override
  State<LyraMicPage> createState() => _LyraMicPageState();
}

class _LyraMicPageState extends State<LyraMicPage> {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _conversationHistory = [];
  final List<String> _debugLogs = [];

  bool _isListening = false;
  bool _isTriggered = false;
  bool _speechInitialized = false;
  bool _initializing = false;
  bool _awaitingCommand = false;
  String _lastWords = '';
  String _partialWords = '';
  String _status = '';
  DateTime?
  _lastStateChangeTime; // Durum değişiklikleri arasındaki süreyi kontrol etmek için
  Timer? _silenceTimer; // Sessizlik durumunda dinlemeyi durdurmak için

  double _lastSoundLevel = -1.0;
  DateTime? _lastSoundTime;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  @override
  void dispose() {
    _silenceTimer?.cancel();
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    await _initTts();
    await _initSpeech();
  }

  Future<void> _initSpeech() async {
    if (_speechInitialized || _initializing) return;
    _initializing = true;
    _addDebugLog('Konuşma tanıma başlatılıyor...', type: 'INIT');

    try {
      final permissionStatus = await _requestMicrophonePermission();
      if (!permissionStatus) {
        _initializing = false;
        _addDebugLog(
          'Mikrofon izni alınamadı, konuşma tanıma başlatılamıyor.',
          type: 'ERROR',
        );
        if (mounted) {
          setState(() {
            _status = 'Mikrofon izni gerekli';
          });
        }
        return;
      }

      final available = await _speechToText.initialize(
        onStatus: _handleSpeechStatus,
        onError: _handleSpeechError,
        debugLogging: true,
      );

      if (!mounted) return;

      setState(() {
        _speechInitialized = available;
        _initializing = false;
        _status = available ? 'Hazır' : 'Başlatılamadı';
      });

      if (available) {
        _addDebugLog('Konuşma tanıma başarıyla başlatıldı.', type: 'SUCCESS');
        _listenForTrigger();
      } else {
        _addDebugLog(
          'Konuşma tanıma başlatılamadı (available=false).',
          type: 'ERROR',
        );
      }
    } catch (e) {
      _addDebugLog('Konuşma tanıma başlatma hatası: $e', type: 'ERROR');
      if (mounted) {
        setState(() {
          _initializing = false;
          _status = 'Başlatma hatası';
        });
      }
    }
  }

  Future<bool> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    _addDebugLog('Mikrofon izni durumu: $status', type: 'PERMISSION');
    if (!status.isGranted) {
      _addDebugLog('Mikrofon izni isteniyor...', type: 'PERMISSION');
      status = await Permission.microphone.request();
      _addDebugLog('Mikrofon izni yanıtı: $status', type: 'PERMISSION');
      if (!status.isGranted) {
        _addDebugLog('Mikrofon izni reddedildi!', type: 'ERROR');
        return false;
      }
    }
    return true;
  }

  void _handleSpeechStatus(String status) {
    if (!mounted) return;
    final now = DateTime.now();
    if (_lastStateChangeTime != null &&
        now.difference(_lastStateChangeTime!) <
            const Duration(milliseconds: 300)) {
      // Çok sık durum değişikliğini engelle
      return;
    }
    _lastStateChangeTime = now;
    _addDebugLog('Konuşma durumu: $status', type: 'STATUS');
    setState(() {
      _status = status;
    });

    if (status == SpeechToText.listeningStatus) {
      if (!_isListening) {
        setState(() {
          _isListening = true;
        });
      }
    } else if (status == SpeechToText.notListeningStatus) {
      // Eğer tetikleme kelimesi bekleniyorsa ve komut beklenmiyorsa ve aktif bir tetikleme yoksa yeniden dinle
      if (!_isTriggered && !_awaitingCommand && _isListening) {
        _addDebugLog(
          'Dinleme durdu (notListening), yeniden tetikleme için dinleniyor.',
          type: 'STATUS',
        );
        setState(() {
          _isListening = false;
        });
        // Kısa bir bekleme sonrası yeniden dinlemeyi dene, sürekli döngüye girmemesi için kontrol ekle
        Future.delayed(RETRY_DELAY, () {
          if (mounted && !_isListening && !_isTriggered && !_awaitingCommand) {
            _listenForTrigger();
          }
        });
      } else if (_isListening) {
        setState(() {
          _isListening = false;
        });
      }
    } else if (status == SpeechToText.doneStatus) {
      if (_isListening) {
        setState(() {
          _isListening = false;
        });
      }
      if (!_isTriggered && !_awaitingCommand) {
        _addDebugLog(
          'Dinleme tamamlandı (done), yeniden tetikleme için dinleniyor.',
          type: 'STATUS',
        );
        Future.delayed(RETRY_DELAY, () {
          if (mounted && !_isListening && !_isTriggered && !_awaitingCommand) {
            _listenForTrigger();
          }
        });
      }
    }
  }

  void _handleSpeechError(error) {
    if (!mounted) return;
    final now = DateTime.now();
    if (_lastStateChangeTime != null &&
        now.difference(_lastStateChangeTime!) <
            const Duration(milliseconds: 500)) {
      return;
    }
    _lastStateChangeTime = now;
    _addDebugLog(
      'Konuşma hatası: ${error.errorMsg}, Permanent: ${error.permanent}',
      type: 'ERROR',
    );

    setState(() {
      _status = 'Hata: ${error.errorMsg}';
      _isListening = false;
      _awaitingCommand = false;
      _isTriggered = false;
    });

    // Kalıcı olmayan hatalarda yeniden dinlemeyi dene
    if (!error.permanent && mounted) {
      _addDebugLog(
        'Kalıcı olmayan hata, yeniden dinleme deneniyor...',
        type: 'RETRY',
      );
      Future.delayed(RETRY_DELAY, () {
        if (mounted && !_isListening) {
          _listenForTrigger();
        }
      });
    } else {
      // Kalıcı hata durumunda servisi yeniden başlatmayı dene
      _addDebugLog(
        'Kalıcı hata, servis yeniden başlatılıyor...',
        type: 'RETRY',
      );
      _speechInitialized = false;
      Future.delayed(RETRY_DELAY, () {
        if (mounted) {
          _initSpeech();
        }
      });
    }
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("tr-TR");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.4); // Daha yavaş ve anlaşılır konuşma
      await _flutterTts.setVolume(1.0);

      // Android için ses ayarları
      if (Platform.isAndroid) {
        await _flutterTts.setVoice({
          "name": "tr-tr-x-dfn#male_2-local",
          "locale": "tr-TR",
        });
      }

      // TTS durumunu dinle
      _flutterTts.setStartHandler(() {
        _addDebugLog('TTS başladı', type: 'TTS');
      });

      _flutterTts.setCompletionHandler(() {
        _addDebugLog('TTS tamamlandı', type: 'TTS');
      });

      _flutterTts.setErrorHandler((error) {
        _addDebugLog('TTS hatası: $error', type: 'ERROR');
      });

      _addDebugLog('TTS başarıyla başlatıldı', type: 'SUCCESS');
    } catch (e) {
      _addDebugLog('TTS başlatma hatası: $e', type: 'ERROR');
    }
  }

  void _addDebugLog(String message, {String type = 'INFO'}) {
    final timestamp = DateTime.now().toIso8601String().substring(
      11,
      23,
    ); // Sadece saat:dakika:saniye.milisaniye
    final logMessage = '[$timestamp][$type] $message';
    print(logMessage); // Konsola da yazdır
    if (mounted) {
      setState(() {
        _debugLogs.insert(0, logMessage); // Yeni logları başa ekle
        if (_debugLogs.length > 50)
          _debugLogs.removeLast(); // Log sayısını sınırla
      });
    }
  }

  void _addToConversation(
    String text, {
    bool isUser = true,
    bool isPartial = false,
  }) {
    if (mounted) {
      setState(() {
        // Eğer son mesaj kısmi ise ve yeni gelen de kısmi ise, sonuncuyu güncelle
        if (isPartial &&
            _conversationHistory.isNotEmpty &&
            _conversationHistory.first['isPartial'] == 'true' &&
            _conversationHistory.first['isUser'] == isUser.toString()) {
          _conversationHistory.first['text'] = text;
          _conversationHistory.first['time'] = DateTime.now().toIso8601String();
        } else {
          _conversationHistory.insert(0, {
            'text': text,
            'isUser': isUser.toString(),
            'time': DateTime.now().toIso8601String(),
            'isPartial': isPartial.toString(),
          });
        }
        if (_conversationHistory.length > 20) _conversationHistory.removeLast();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0.0, // En üste kaydır
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _listenForTrigger() async {
    if (!mounted || _isListening || !_speechInitialized || _initializing)
      return;

    if (await _speechToText.isListening) {
      await _speechToText.stop();
      _addDebugLog(
        'Mevcut dinleme durduruldu (trigger öncesi).',
        type: 'ACTION',
      );
      await Future.delayed(
        const Duration(milliseconds: 200),
      ); // Kısa bir bekleme
    }

    setState(() {
      _isListening = true;
      _isTriggered = false;
      _awaitingCommand = false;
      _lastWords = '';
      _partialWords = '';
      _status = 'Dinleniyor (Tetikleme için)...';
    });
    _addDebugLog(
      'Tetikleme kelimesi için dinleme başlatılıyor...',
      type: 'ACTION',
    );

    try {
      await _speechToText.listen(
        onResult: _onTriggerResult,
        listenFor: LISTEN_TIMEOUT,
        pauseFor: SILENCE_TIMEOUT,
        partialResults: true,
        localeId: LANGUAGE,
        cancelOnError: false, // Hatalarda otomatik iptal etme
        listenMode: ListenMode.dictation,
        onSoundLevelChange: _handleSoundLevelChange,
      );
      _resetSilenceTimer();
    } catch (e) {
      _addDebugLog('Tetikleme dinleme başlatma hatası: $e', type: 'ERROR');
      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(SILENCE_TIMEOUT, () {
      if (mounted && _isListening) {
        if (!_isTriggered && !_awaitingCommand) {
          _addDebugLog(
            'Sessizlik zaman aşımı, dinleme durduruluyor (tetikleme).',
            type: 'TIMEOUT',
          );
          _stopListeningAndRestartTrigger();
        } else if (_awaitingCommand) {
          _addDebugLog(
            'Sessizlik zaman aşımı, komut dinleme durduruluyor.',
            type: 'TIMEOUT',
          );
          _stopListeningAndRestartTrigger();
        }
      }
    });
  }

  void _handleSoundLevelChange(double level) {
    if (!mounted || !_isListening) return;
    // Ses algılandığında sessizlik zamanlayıcısını sıfırla
    if (level > 0) {
      // Basit bir ses algılama kontrolü
      _resetSilenceTimer();
    }
    // _lastSoundLevel = level;
    // _lastSoundTime = DateTime.now();
  }

  void _onTriggerResult(result) async {
    if (!mounted) return;
    final recognizedWords = result.recognizedWords.toLowerCase();
    setState(() {
      _lastWords = recognizedWords;
      _partialWords = recognizedWords;
    });
    _addToConversation(
      _partialWords,
      isUser: true,
      isPartial: !result.finalResult,
    );

    // Tetikleme kelimesi algılandı mı?
    if (!_isTriggered && result.finalResult) {
      bool isWakeWord = WAKE_WORD_VARIATIONS.any(
        (w) =>
            recognizedWords.contains(w) ||
            recognizedWords.replaceAll(" ", "").contains(w.replaceAll(" ", "")),
      );

      if (isWakeWord) {
        setState(() {
          _isTriggered = true;
          _awaitingCommand = false;
          _isListening = false;
        });

        _addToConversation(RESPONSE_TEXT, isUser: false);
        _addDebugLog(
          'Tetikleyici algılandı, mikrofon kapatılıyor ve TTS başlatılıyor.',
          type: 'ACTION',
        );

        // Mikrofonu kapat ve TTS'i başlat
        await _speechToText.stop();

        // TTS'i başlat ve tamamlanmasını bekle
        try {
          await _flutterTts.speak(RESPONSE_TEXT);

          // TTS tamamlandığında komut dinlemeye geç
          _flutterTts.setCompletionHandler(() {
            _addDebugLog(
              'TTS tamamlandı, komut dinlemeye geçiliyor.',
              type: 'ACTION',
            );
            if (mounted) {
              setState(() {
                _awaitingCommand = true;
              });
              _listenForCommand();
            }
          });
        } catch (e) {
          _addDebugLog('TTS konuşma hatası: $e', type: 'ERROR');
          // Hata durumunda da komut dinlemeye geç
          if (mounted) {
            setState(() {
              _awaitingCommand = true;
            });
            _listenForCommand();
          }
        }
        return;
      }
    }
  }

  void _listenForCommand() async {
    if (!mounted || _isListening || !_speechInitialized || !_awaitingCommand) {
      _addDebugLog(
        'Komut dinleme koşulları sağlanamadı. isListening: $_isListening, speechInitialized: $_speechInitialized, awaitingCommand: $_awaitingCommand',
        type: 'WARN',
      );
      // Eğer bir şekilde komut dinleme beklenirken bu duruma gelinirse, başa dön
      if (mounted && _awaitingCommand) {
        setState(() {
          _awaitingCommand = false;
          _isTriggered = false;
        });
        _listenForTrigger();
      }
      return;
    }

    if (await _speechToText.isListening) {
      await _speechToText.stop();
      _addDebugLog('Mevcut dinleme durduruldu (komut öncesi).', type: 'ACTION');
      await Future.delayed(const Duration(milliseconds: 200));
    }

    setState(() {
      _isListening = true; // Komut için dinleme aktif
      _status = 'Komut bekleniyor...';
      _partialWords = ''; // Önceki kısmi sonuçları temizle
    });
    _addDebugLog('Komut için dinleme başlatılıyor...', type: 'ACTION');

    try {
      await _speechToText.listen(
        onResult: _handleCommandResult,
        listenFor: COMMAND_TIMEOUT,
        pauseFor: SILENCE_TIMEOUT,
        partialResults: true,
        localeId: LANGUAGE,
        cancelOnError: false,
        listenMode: ListenMode.dictation,
        onSoundLevelChange: (level) {
          // Komut dinlerken de sessizlik zamanlayıcısını sıfırla
          if (mounted && _isListening && _awaitingCommand) {
            _resetCommandSilenceTimer();
          }
        },
      );
      _resetCommandSilenceTimer();
    } catch (e) {
      _addDebugLog('Komut dinleme başlatma hatası: $e', type: 'ERROR');
      if (mounted) {
        setState(() {
          _isListening = false;
          _awaitingCommand = false;
          _isTriggered = false;
        });
        _listenForTrigger(); // Hata durumunda başa dön
      }
    }
  }

  void _resetCommandSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(Duration(seconds: 10), () {
      if (mounted && _isListening && _awaitingCommand) {
        _addDebugLog(
          'Sessizlik zaman aşımı, komut dinleme durduruluyor.',
          type: 'TIMEOUT',
        );
        _stopListeningAndRestartTrigger(); // Komut gelmezse başa dön
      }
    });
  }

  void _handleCommandResult(result) async {
    if (!mounted) return;

    setState(() {
      _lastWords = result.recognizedWords.toLowerCase();
      _partialWords = result.recognizedWords.toLowerCase();
    });
    _addToConversation(
      _partialWords,
      isUser: true,
      isPartial: !result.finalResult,
    );

    if (result.finalResult && _awaitingCommand) {
      _addDebugLog('Sonuç (Komut): $_lastWords', type: 'COMMAND_RESULT');
      _silenceTimer?.cancel();

      if (await _speechToText.isListening) {
        await _speechToText.stop();
        _addDebugLog('Dinleme durduruldu (komut sonrası).', type: 'ACTION');
      }

      setState(() {
        _isListening = false;
        _awaitingCommand = false;
      });

      var parsed = parseCommand(_lastWords);
      if (isValidCommand(parsed)) {
        await saveCommand(_lastWords, parsed);
        String feedback = naturalFeedback(parsed);
        _addToConversation(feedback, isUser: false);
        await _speak(feedback); // SESLİ YANIT EKLENDİ
        _addDebugLog(
          'Komut algılandı, mikrofon kapatılıyor ve TTS başlatılıyor.',
          type: 'ACTION',
        );
        await _speechToText.stop();
        await _flutterTts.speak(feedback);
        _flutterTts.setCompletionHandler(() {
          _addDebugLog(
            'TTS tamamlandı, tetikleyici dinlemeye dönülüyor.',
            type: 'ACTION',
          );
          if (mounted) {
            setState(() {
              _isTriggered = false;
              _isListening = false;
            });
            _listenForTrigger();
          }
        });
        _addToConversation(feedback, isUser: false);
      } else {
        _flutterTts.setCompletionHandler(() {
          if (mounted) {
            setState(() {
              _awaitingCommand = true;
              _isListening = true;
            });
            _addDebugLog(
              '"Komut anlaşılamadı" yanıtı tamamlandı, yeniden komut için dinleniyor.',
              type: 'TTS_DONE',
            );
            _listenForCommand();
          }
        });
        await _speak("Komut anlaşılamadı. Lütfen tekrar söyleyin.");
        _addToConversation(
          "Komut anlaşılamadı. Lütfen tekrar söyleyin.",
          isUser: false,
        );
      }
    }
  }

  Future<void> _speak(String text) async {
    if (!mounted) return;

    try {
      await _flutterTts.stop();
      _addDebugLog('TTS konuşma başlıyor: $text', type: 'TTS_START');
      await _flutterTts.speak(text);
    } catch (e) {
      _addDebugLog('TTS konuşma hatası: $e', type: 'ERROR');
      if (mounted) {
        setState(() {
          _status = 'TTS Hatası';
        });
      }
    }
  }

  void _stopListeningAndRestartTrigger() async {
    if (!mounted) return;

    _addDebugLog(
      'Dinleme durduruluyor ve tetikleme yeniden başlatılıyor.',
      type: 'ACTION',
    );
    _silenceTimer?.cancel();

    try {
      if (await _speechToText.isListening) {
        await _speechToText.stop();
      }
    } catch (e) {
      _addDebugLog('Dinleme durdurma hatası: $e', type: 'ERROR');
    }

    if (mounted) {
      setState(() {
        _isListening = false;
        _awaitingCommand = false;
        _isTriggered = false;
        _partialWords = '';
        _status = 'Hazır';
      });

      // Kısa bir bekleme sonrası yeniden dinlemeyi dene
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_isListening) {
          _listenForTrigger();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent, // Arka planı transparan yap
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
            width: screenSize.width * 0.9, // Genişliği artır
            height: screenSize.height * 0.8, // Yüksekliği artır
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 700,
            ), // Max boyutlar
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(
                0.85,
              ), // Koyu tema için daha uygun
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 28,
                    ),
                    onPressed: () {
                      _stopListeningAndRestartTrigger(); // Sayfadan çıkarken dinlemeyi durdur ve sıfırla
                      Navigator.pop(context);
                    },
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        bottom: 10.0,
                      ), // Loglar için yer aç
                      child: Image.asset(
                        'assets/lyra.png',
                        width: screenSize.width * 0.25,
                        height: screenSize.width * 0.25,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Debug Logları Gösterme Alanı
                    if (_debugLogs.isNotEmpty)
                      Container(
                        height: 120, // Yüksekliği artır
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[700]!),
                        ),
                        child: ListView.builder(
                          reverse: true, // Yeni loglar üstte görünsün
                          itemCount: _debugLogs.length,
                          itemBuilder: (context, index) {
                            final log = _debugLogs[index];
                            Color logColor = Colors.white70;
                            if (log.contains('[ERROR]'))
                              logColor = Colors.redAccent;
                            if (log.contains('[WARNING]'))
                              logColor = Colors.orangeAccent;
                            if (log.contains('[SUCCESS]'))
                              logColor = Colors.greenAccent;
                            if (log.contains('[TRIGGER]'))
                              logColor = Colors.lightBlueAccent;
                            if (log.contains('[COMMAND'))
                              logColor = Colors.purpleAccent;
                            return Text(
                              log,
                              style: TextStyle(
                                fontSize: 10, // Boyutu küçült
                                color: logColor,
                                fontFamily: 'monospace',
                              ),
                            );
                          },
                        ),
                      ),
                    // Konuşma Geçmişi Alanı
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListView.builder(
                          reverse:
                              true, // Yeni mesajlar altta (veya üstte, tercihe göre)
                          controller: _scrollController,
                          itemCount: _conversationHistory.length,
                          itemBuilder: (context, index) {
                            final message = _conversationHistory[index];
                            final isUser = message['isUser'] == 'true';
                            final isPartial = message['isPartial'] == 'true';
                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? (isPartial
                                            ? Colors.blue[800]?.withOpacity(0.7)
                                            : Colors.blue[700])
                                      : Colors.grey[700],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  message['text']!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontStyle: isPartial
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Kısmi Sonuçları Gösterme Alanı (isteğe bağlı)
                    if (_partialWords.isNotEmpty &&
                        _isListening &&
                        !_isTriggered)
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.mic, color: Colors.white70, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _partialWords,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Mikrofon Butonu ve Durum Metni
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: _isListening
                                ? Lottie.asset(
                                    'assets/animations/anim.json', // Bu animasyonun olduğundan emin olun
                                    width: 70,
                                    height: 70,
                                    repeat: true,
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.mic,
                                      size: 50,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: _isListening
                                        ? null
                                        : _listenForTrigger, // Dinlerken tekrar basılmasını engelle
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(
                                        0.1,
                                      ),
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(15),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _status, // _status değişkenini kullan
                            // _isListening
                            //     ? (_awaitingCommand ? 'Komutunuzu söyleyin...' : 'Dinleniyor...')
                            //     : (_isTriggered ? 'Yanıt bekleniyor...' : 'Mikrofona dokunun veya "Hey Layra" deyin'),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Color baseColor;
  BackgroundPainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = baseColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final circlePaint1 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              baseColor
                  .withBlue(baseColor.blue + 40)
                  .withGreen(baseColor.green + 20)
                  .withOpacity(0.4),
              baseColor.withOpacity(0.1),
            ],
            stops: const [0.0, 1.0],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.2, size.height * 0.25),
              radius: size.width * 0.85,
            ),
          )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);

    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.25),
      size.width * 0.85,
      circlePaint1,
    );

    final circlePaint2 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              baseColor
                  .withRed(baseColor.red + 30)
                  .withGreen(baseColor.green + 10)
                  .withOpacity(0.35),
              baseColor.withOpacity(0.05),
            ],
            stops: const [0.0, 1.0],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.85, size.height * 0.75),
              radius: size.width * 0.75,
            ),
          )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 70);

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.75),
      size.width * 0.75,
      circlePaint2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<File> getCommandsFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/$JSON_PATH');
}

Future<void> initializeJson() async {
  try {
    final file = await getCommandsFile();
    if (!(await file.exists())) {
      List<Map<String, dynamic>> initialCommands = SAMPLE_COMMANDS.map((cmd) {
        var parsed = parseCommand(cmd);
        return {
          "komut": cmd,
          ...parsed,
          "tarih": DateTime.now().toIso8601String(),
        };
      }).toList();
      await file.writeAsString(jsonEncode(initialCommands));
      print('JSON dosyası oluşturuldu');
    }
  } catch (e) {
    print('JSON başlatma hatası: $e');
  }
}

Future<void> saveCommand(String command, Map<String, String> parsed) async {
  try {
    final file = await getCommandsFile();
    List<dynamic> commands = [];
    if (await file.exists()) {
      String content = await file.readAsString();
      if (content.isNotEmpty) {
        try {
          commands = jsonDecode(content);
        } catch (e) {
          print('JSON decode hatası (saveCommand): $e, içerik: $content');
          commands = []; // Hata durumunda boş liste ile devam et
        }
      } else {
        commands = [];
      }
    }
    commands.add({
      "tam_komut": command,
      ...parsed,
      "tarih": DateTime.now().toIso8601String(),
    });
    await file.writeAsString(jsonEncode(commands));
    print('Komut kaydedildi: $command');
  } catch (e) {
    print('Komut kaydetme hatası: $e');
  }
}

Map<String, String> parseCommand(String command) {
  if (command.isEmpty) return {};

  String fullCommand = command
      .toLowerCase()
      // .replaceAll(RegExp(r'(i|ı|u|ü|a|e) (a|e|i|ı|o|ö|u|ü)'), ' ') // Bu kural çok agresif olabilir
      .replaceAll(
        RegExp(r'(in|ın|un|ün|nin|nın|nun|nün)$'),
        '',
      ) // Sadece sondaki ekleri kaldır
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  // Türkçe karakter dönüşümleri (normalizasyon)
  fullCommand = fullCommand
      .replaceAll('ı', 'i')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u')
      .replaceAll('ş', 's')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c');

  List<String> parts = fullCommand
      .split(" ")
      .where((s) => s.isNotEmpty)
      .toList();
  if (parts.isEmpty) return {};

  String action = "";
  String location = "";
  String target = "";

  // Eylemi bulmaya çalış (genellikle sonda olur)
  for (int i = parts.length - 1; i >= 0; i--) {
    if (VALID_ACTIONS.contains(parts[i])) {
      action = parts[i];
      parts.removeAt(i);
      break;
    }
  }
  // Eğer eylem bulunamadıysa, son kelimeyi eylem olarak al (riskli olabilir)
  if (action.isEmpty && parts.isNotEmpty) {
    action = parts.removeLast();
  }

  // Konumu bulmaya çalış (genellikle başta olur)
  if (parts.isNotEmpty && VALID_LOCATIONS.contains(parts.first)) {
    location = parts.removeAt(0);
  }

  // Kalanlar hedef olur
  target = parts.join(" ");

  // Eğer hedef boşsa ve konum varsa, konumu hedef yap (örn: "salonu kapat")
  if (target.isEmpty &&
      location.isNotEmpty &&
      !VALID_ACTIONS.contains(location)) {
    target = location;
    location = ""; // Konum artık hedef oldu
  }

  return {
    "konum": location,
    "hedef": target,
    "eylem": action,
    "tam_komut": command, // Orijinal komutu da sakla
  };
}

bool isValidCommand(Map<String, String> parsed) {
  // Temel geçerlilik: eylem olmalı ve ya konum ya da hedef dolu olmalı.
  return parsed["eylem"] != null &&
      parsed["eylem"]!.isNotEmpty &&
      ((parsed["konum"] != null && parsed["konum"]!.isNotEmpty) ||
          (parsed["hedef"] != null && parsed["hedef"]!.isNotEmpty));
}

String naturalFeedback(Map<String, String> parsed) {
  if (!parsed.containsKey("eylem") || parsed["eylem"]!.isEmpty) {
    return "Komut anlaşılamadı.";
  }

  String location = parsed["konum"] != null && parsed["konum"]!.isNotEmpty
      ? "${parsed["konum"]} konumundaki "
      : "";
  String target = parsed["hedef"] != null && parsed["hedef"]!.isNotEmpty
      ? parsed["hedef"]!
      : (location.isNotEmpty
            ? "belirtilen nesne"
            : "işlem"); // Eğer sadece konum varsa, hedefi "belirtilen nesne" yap
  String action = parsed["eylem"]!;

  String actionPastTense = action;
  // Basit geçmiş zaman ekleri (daha kapsamlı bir kural gerekebilir)
  if (action.endsWith('t')) {
    actionPastTense += "ti";
  } else if (action.endsWith('p') ||
      action.endsWith('ç') ||
      action.endsWith('ş') ||
      action.endsWith('k')) {
    // Sert ünsüz benzeşmesi (fıstıkçı şahap)
    if (['a', 'ı', 'o', 'u'].contains(action[action.length - 2]))
      actionPastTense += "tı";
    else
      actionPastTense += "ti";
  } else if (['a', 'ı'].contains(action.substring(action.length - 1))) {
    actionPastTense += "dı";
  } else if (['e', 'i'].contains(action.substring(action.length - 1))) {
    actionPastTense += "di";
  } else if (['o', 'u'].contains(action.substring(action.length - 1))) {
    actionPastTense += "du";
  } else if (['ö', 'ü'].contains(action.substring(action.length - 1))) {
    actionPastTense += "dü";
  } else {
    // Son harf sesli değilse ve özel durum değilse (örn: gel -> geldi)
    // Bu kısım daha karmaşık olabilir, şimdilik basit tutalım
    // Ünlü uyumuna göre di/dı/du/dü ekle
    String lastVowel = '';
    for (int i = action.length - 1; i >= 0; i--) {
      if (['a', 'e', 'ı', 'i', 'o', 'ö', 'u', 'ü'].contains(action[i])) {
        lastVowel = action[i];
        break;
      }
    }
    if (['a', 'ı', 'o', 'u'].contains(lastVowel))
      actionPastTense += "dı";
    else if (['e', 'i', 'ö', 'ü'].contains(lastVowel))
      actionPastTense += "di";
    else
      actionPastTense += "ildi"; // Varsayılan edilgen çatı
  }

  // "aç" -> "açıldı", "kapat" -> "kapatıldı" gibi daha doğal ifadeler için özel durumlar
  if (action == "aç") actionPastTense = "açıldı";
  if (action == "kapat") actionPastTense = "kapatıldı";

  return "${location}${target} ${actionPastTense}."
      .replaceAll("  ", " ")
      .trim(); // Fazla boşlukları temizle
}
