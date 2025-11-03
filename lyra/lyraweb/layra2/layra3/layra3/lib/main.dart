import 'package:flutter/material.dart';
import 'dart:ui'; // ImageFilter için gerekli
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'services/voice_service.dart';
import 'services/permission_service.dart';
import 'services/command_processor.dart';
import 'package:path_provider/path_provider.dart';

/// Uygulama sabitleri
class AppConstants {
  static const String WAKE_WORD = "hey layra";
  static const String RESPONSE_TEXT = "Efendim";
  static const String JSON_PATH = "assets/komutlar.json";

  static const String ENTITIES_PATH = "entities.json";
  static const String LANGUAGE = "tr-TR";
  static const Duration RETRY_DELAY = Duration(milliseconds: 1000);
  static const Duration LISTEN_TIMEOUT = Duration(seconds: 10);
  static const Duration COMMAND_TIMEOUT = Duration(seconds: 10);
  static const Duration SILENCE_TIMEOUT = Duration(seconds: 5);

  /// Tetikleyici kelime varyasyonları
  static const List<String> WAKE_WORD_VARIATIONS = [
    "hey layra",
    "he layra",
    "he öyle",
    "heyra ile",
    "hey gayrı",
    "hey lara",
    "hey lera",
    "hey lira",
    "leyla ile",
    "he ilayda",
    "hey layla",
    "he ilayda",
    "hey ilayda",
    "hey kayra",
    "hey yayla",
    "hayır hayır",
  ];

  /// Örnek komutlar
  static const List<String> SAMPLE_COMMANDS = [
    "salon ışıkları kapat",
    "mutfak ışıkları aç",
    "odanın perdesini kapat",
  ];

  /// Geçerli eylemler
  static const List<String> VALID_ACTIONS = [
    "aç",
    "açık",
    "kapat",
    "kapa",
    "git",
    "gel",
    "getir",
    "götür",
    "açtır",
    "kapatır",
    "açılsın",
    "kapansın",
  ];

  /// Geçerli konumlar
  static const List<String> VALID_LOCATIONS = [
    "salon",
    "mutfak",
    "oda",
    "banyo",
    "koridor",
    "bahçe",
    "yatak odası",
    "çocuk odası",
    "çalışma odası",
    "oturma odası",
  ];

  /// Geçerli hedefler
  static const List<String> VALID_TARGETS = [
    "ışık",
    "ışıklar",
    "perde",
    "perdeler",
    "klima",
    "televizyon",
    "tv",
    "radyo",
    "müzik",
    "hoparlör",
    "hoparlörler",
    "kapı",
    "kapılar",
    "pencere",
    "pencereler",
  ];
}

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
      home: const LyraMicPage(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR')],
    );
  }
}

class LyraMicPage extends StatefulWidget {
  const LyraMicPage({super.key});
  @override
  State<LyraMicPage> createState() => _LyraMicPageState();
}

class _LyraMicPageState extends State<LyraMicPage> {
  final VoiceService _voiceService = VoiceService();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _conversationHistory = [];
  final List<String> _debugLogs = [];

  bool _isListening = false;
  bool _isTriggered = false;
  bool _awaitingCommand = false;
  bool _isInitialized = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  @override
  void dispose() {
    _voiceService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    if (_isInitialized) return;

    // Mikrofon izni kontrolü
    if (!await PermissionService.requestMicrophonePermission(context)) {
      return;
    }

    // Ses servisi başlatma
    if (!await _voiceService.initialize()) {
      PermissionService.showErrorSnackBar(
        context,
        'Ses servisi başlatılamadı. Lütfen tekrar deneyin.',
      );
      return;
    }

    // Callback'leri ayarla
    _voiceService.onStatusChange = _handleStatusChange;
    _voiceService.onError = _handleError;
    _voiceService.onFinalResult = _handleFinalResult;
    _voiceService.onTtsComplete = _handleTtsComplete;
    _voiceService.onSilenceTimeout = _handleSilenceTimeout;
    _voiceService.onCommandComplete = _handleCommandComplete;

    setState(() {
      _isInitialized = true;
      _status = 'Hazır';
    });
  }

  void _handleStatusChange(String status) {
    if (!mounted) return;
    setState(() {
      _status = status;
      _isListening = status == SpeechToText.listeningStatus;
      if (!_isListening) {
        _status = 'Hazır';
      }
    });
  }

  void _handleError(String error) {
    if (!mounted) return;
    PermissionService.showErrorSnackBar(context, error);
    _addDebugLog(error, type: 'ERROR');

    // Hata durumunda servisi yeniden başlat
    if (_isInitialized) {
      _restartService();
    }
  }

  Future<void> _restartService() async {
    setState(() {
      _isInitialized = false;
      _isListening = false;
      _isTriggered = false;
      _awaitingCommand = false;
    });

    await _voiceService.dispose();
    await _initializeServices();
  }

  void _handleFinalResult(String text) {
    if (!mounted || text.trim().isEmpty) return;

    // Kısmi sonuçları temizle
    if (_conversationHistory.isNotEmpty &&
        _conversationHistory.first['isPartial'] == 'true') {
      _conversationHistory.removeAt(0);
    }

    // Tetikleyici kelime kontrolü
    if (CommandProcessor.isWakeWord(text)) {
      _addToConversation("Hey Layra", isUser: true, isPartial: false);
      _handleWakeWord();
    } else {
      // Eğer tetiklenmemiş ve komut beklemiyorsa (yani ilk aşamadaysa)
      if (!_isTriggered && !_awaitingCommand) {
        _addToConversation(text, isUser: true, isPartial: false);
        _addToConversation("Lütfen Hey Layra diyin", isUser: false);
        _voiceService.speak("Lütfen Hey Layra diyin");
        return;
      }

      // Eğer tetiklenmiş ve komut bekliyorsa
      if (_awaitingCommand) {
        _addToConversation(text, isUser: true, isPartial: false);
        _processCommand(text);
      }
    }
  }

  void _handleCommandComplete(String command) {
    if (!mounted) return;
    _processCommand(command);
  }

  void _handleSilenceTimeout() {
    if (!mounted) return;

    if (_awaitingCommand) {
      setState(() {
        _awaitingCommand = false;
        _status = 'Ne yapmamı istersiniz?';
      });
      _voiceService.stopListening();
      _voiceService.speak("Ne yapmamı istersiniz?");
    }
  }

  void _handleWakeWord() async {
    if (!mounted) return;

    // Eğer zaten tetiklenmişse veya konuşma devam ediyorsa, yeni tetiklemeyi engelle
    if (_isTriggered || _voiceService.isSpeaking) {
      return;
    }

    setState(() {
      _isTriggered = true;
      _awaitingCommand = false;
    });

    await _voiceService.stopListening();
    _addToConversation("Efendim", isUser: false);
    await _voiceService.speak("Efendim");
  }

  void _handleTtsComplete() {
    if (!mounted) return;

    // TTS tamamlandığında durumu güncelle
    if (_isTriggered) {
      setState(() {
        _awaitingCommand = true;
        _isTriggered = false;
        _status = 'Komut bekleniyor...';
      });
      _startListening();
    }
  }

  void _startListening() async {
    if (!_isInitialized) {
      await _initializeServices();
    }

    if (!_isInitialized) {
      setState(() {
        _status = 'Ses servisi başlatılamadı';
      });
      return;
    }

    setState(() {
      _isListening = true;
      _status = 'Dinleniyor... (10 saniye içinde konuşun)';
    });

    await _voiceService.startListening(
      onResult: (text) {
        // Bu callback'i kaldırdık çünkü onFinalResult ve onPartialResult kullanıyoruz
      },
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 5),
    );

    _voiceService.onNoResponse = () {
      setState(() {
        _status = 'Sizi anlayamadım';
        _isListening = false;
      });
    };
  }

  void _processCommand(String command) async {
    if (!mounted) return;
    await _voiceService.stopListening();

    if (command.trim().isEmpty) {
      setState(() {
        _status = 'Ne yapmamı istersiniz?';
        _isTriggered = false;
        _awaitingCommand = false;
        _isListening = false;
      });
      await _voiceService.speak("Ne yapmamı istersiniz?");
      return;
    }

    var parsed = parseCommand(command);
    print('Ayrıştırılan komut: $parsed'); // Debug için

    // Komut geçerlilik kontrolü
    if (isValidCommand(parsed)) {
      try {
        await saveCommand(command, parsed);
        _addDebugLog('Komut başarıyla kaydedildi: $command', type: 'SUCCESS');

        // Doğal yanıt oluştur
        String response = naturalFeedback(parsed);
        _addToConversation(response, isUser: false);
        await _voiceService.speak(response);

        setState(() {
          _isTriggered = false;
          _awaitingCommand = false;
          _isListening = false;
          _status = 'Hey Layra diyerek başlayabilirsiniz';
        });
      } catch (e) {
        _addDebugLog('Komut kaydedilemedi: $e', type: 'ERROR');
        setState(() {
          _status = 'Komut işlenirken bir hata oluştu';
        });
      }
    } else {
      print('Geçersiz komut detayları: $parsed'); // Debug için
      setState(() {
        _status = 'Sizi anlayamadım';
        _isTriggered = false;
        _awaitingCommand = true;
        _isListening = false;
      });

      await _voiceService.speak("Sizi anlayamadım");
      _voiceService.onTtsComplete = () {
        if (mounted) {
          setState(() {
            _status = 'Komut bekleniyor...';
            _isListening = true;
            _awaitingCommand = true;
          });
          _startListening();
        }
      };
    }
  }

  Future<void> saveCommand(String command, Map<String, String> parsed) async {
    try {
      // Komutun geçerli olup olmadığını kontrol et
      if (!isValidCommand(parsed)) {
        print('Geçersiz komut, kaydedilmedi: $command');
        return;
      }

      final file = await getCommandsFile();
      print('Komut kaydedilecek dosya konumu: ${file.path}');

      List<dynamic> commands = [];

      // Mevcut komutları oku
      if (await file.exists()) {
        String content = await file.readAsString();
        print('Dosyadaki mevcut komutlar: $content');

        if (content.isNotEmpty) {
          try {
            commands = jsonDecode(content);
            print('Dosyada bulunan komut sayısı: ${commands.length}');
          } catch (e) {
            print('JSON dosyası okuma hatası: $e');
            commands = [];
          }
        }
      }

      // Yeni komut detaylarını oluştur
      Map<String, dynamic> commandDetails = {
        "tam_komut": command,
        "eylem": parsed["eylem"] ?? "",
        "konum": parsed["konum"] ?? "",
        "hedef": parsed["hedef"] ?? "",
        "tarih": DateTime.now().toIso8601String(),
        "durum": "başarılı",
        "işlem_türü": "sesli_komut"
      };

      print('Yeni eklenecek komut detayları: $commandDetails');

      // Komutları ekle
      commands.add(commandDetails);

      // JSON dosyasına kaydet
      String jsonContent = jsonEncode(commands);
      print('Kaydedilecek tüm komutlar: $jsonContent');

      await file.writeAsString(jsonContent, flush: true);
      print('Komut başarıyla kaydedildi: $command');

      // Kaydedilen dosyanın son halini oku ve göster
      final savedContent = await file.readAsString();
      print('\n=== KOMUTLAR.JSON DOSYASININ GÜNCEL İÇERİĞİ ===');
      print(savedContent);
      print('================================================\n');
    } catch (e) {
      print('Komut kaydetme işlemi sırasında hata oluştu: $e');
      throw e;
    }
  }

  bool isValidCommand(Map<String, String> parsed) {
    // Üç zorunlu alan kontrolü: eylem, konum ve hedef
    bool hasAction = parsed['eylem']?.isNotEmpty ?? false;
    bool hasTarget = parsed['hedef']?.isNotEmpty ?? false;
    bool hasLocation = parsed['konum']?.isNotEmpty ?? false;

    print('Komut geçerlilik kontrolü:');
    print('- Eylem var mı: $hasAction');
    print('- Hedef var mı: $hasTarget');
    print('- Konum var mı: $hasLocation');
    print('- Parsed değerleri: $parsed');

    // Tüm zorunlu alanların varlığını kontrol et
    return hasAction && hasTarget && hasLocation;
  }

  void _addDebugLog(String message, {String type = 'INFO'}) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    final logMessage = '[$timestamp][$type] $message';
    if (mounted) {
      setState(() {
        _debugLogs.insert(0, logMessage);
        if (_debugLogs.length > 50) _debugLogs.removeLast();
      });
    }
  }

  void _addToConversation(String text,
      {bool isUser = true, bool isPartial = false}) {
    if (!mounted) return;
    setState(() {
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
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/lyra.png',
                  width: screenSize.width * 0.7,
                  height: screenSize.width * 0.7,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                if (_debugLogs.isNotEmpty)
                  Container(
                    height: 120,
                    width: screenSize.width * 0.9,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                    child: ListView.builder(
                      reverse: true,
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
                            fontSize: 10,
                            color: logColor,
                            fontFamily: 'monospace',
                          ),
                        );
                      },
                    ),
                  ),
                Expanded(
                  child: Container(
                    width: screenSize.width * 0.9,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      reverse: true,
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
                                'assets/animations/anim.json',
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
                                onPressed: !_isInitialized
                                    ? null
                                    : () {
                                        if (!_isListening &&
                                            !_isTriggered &&
                                            !_awaitingCommand) {
                                          _startListening();
                                        }
                                      },
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Colors.white.withOpacity(0.1),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                ),
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _status,
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
          ),
        ],
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
      ..shader = RadialGradient(
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
      ..shader = RadialGradient(
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
  try {
    // Uygulama dokümanlar dizinini al
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/komutlar.json');

    print('=== DOSYA BİLGİLERİ ===');
    print('Uygulama Dizini: ${appDir.path}');
    print('Dosya Tam Yolu: ${file.path}');
    print('Dosya Var mı: ${await file.exists()}');
    print('=====================');

    // Dosya yoksa oluştur ve başlangıç verilerini ekle
    if (!await file.exists()) {
      print('Dosya bulunamadı, yeni dosya oluşturuluyor...');

      // Başlangıç verilerini oluştur
      List<Map<String, dynamic>> initialCommands = [
        {
          "tam_komut": "salon ışıkları kapat",
          "eylem": "kapat",
          "konum": "salon",
          "hedef": "ışık",
          "tarih": DateTime.now().toIso8601String(),
          "durum": "başarılı",
          "işlem_türü": "sesli_komut"
        }
      ];

      // JSON formatında kaydet
      String jsonContent = jsonEncode(initialCommands);
      await file.writeAsString(jsonContent, flush: true);
      print('Başlangıç verileri eklendi: $jsonContent');
    }

    return file;
  } catch (e) {
    print('Dosya işlemi hatası: $e');
    rethrow;
  }
}

Future<void> initializeJson() async {
  try {
    final file = await getCommandsFile();
    print('JSON dosyası konumu: ${file.path}');
  } catch (e) {
    print('JSON başlatma hatası: $e');
  }
}

// Kelime grupları ve ilişkileri için sınıflar
class WordGroup {
  final String type;
  final List<String> words;
  final List<String> synonyms;
  final List<String> variations;

  WordGroup(this.type, this.words, this.synonyms, this.variations);
}

class WordRelation {
  final String word;
  final String type;
  final List<String> relatedWords;
  final List<String> contexts;

  WordRelation(this.word, this.type, this.relatedWords, this.contexts);
}

// Kelime grupları tanımlamaları
final List<WordGroup> wordGroups = [
  // EYLEM GRUBU
  WordGroup('eylem', [
    'aç',
    'kapat',
    'kapa'
  ], [
    'açık',
    'kapalı',
    'kapatır',
    'kapatıyor',
    'açtır',
    'kapatır',
    'açılsın',
    'kapansın',
    'kapatılsın'
  ], [
    'açtır',
    'kapatır',
    'açılsın',
    'kapansın',
    'kapatılsın',
    'açabilir misin',
    'kapatabilir misin',
    'açarmısın',
    'kapatırmısın',
    'açar mısın',
    'kapatır mısın'
  ]),

  // KONUM GRUBU
  WordGroup('konum', [
    'salon',
    'mutfak',
    'oda',
    'banyo',
    'koridor',
    'bahçe'
  ], [
    'oturma odası',
    'çalışma odası',
    'yatak odası',
    'çocuk odası'
  ], [
    'salonda',
    'mutfakta',
    'odada',
    'banyoda',
    'koridorda',
    'bahçede',
    'salonun',
    'mutfağın',
    'odanın',
    'banyonun',
    'koridorun',
    'bahçenin',
    'salondaki',
    'mutfaktaki',
    'odadaki',
    'banyodaki',
    'koridordaki',
    'bahçedeki'
  ]),

  // HEDEF GRUBU
  WordGroup('hedef', [
    'ışık',
    'perde',
    'klima',
    'televizyon',
    'radyo'
  ], [
    'ışıklar',
    'perdeler',
    'klimalar',
    'tv',
    'müzik',
    'lamba',
    'lambalar'
  ], [
    'ışıkları',
    'perdeleri',
    'klimaları',
    'ışıkların',
    'perdelerin',
    'klimaların',
    'ışıklarını',
    'perdelerini',
    'klimalarını'
  ]),
];

// Kelime ilişkileri tanımlamaları
final List<WordRelation> wordRelations = [
  // IŞIK İLİŞKİLERİ
  WordRelation('ışık', 'hedef', [
    'ışıklar',
    'lamba',
    'lambalar',
    'aydınlatma',
    'ışıkları',
    'ışıklarını',
    'ışıkların'
  ], [
    'aç',
    'kapat',
    'yak',
    'söndür'
  ]),

  // PERDE İLİŞKİLERİ
  WordRelation('perde', 'hedef', [
    'perdeler',
    'panjur',
    'panjurlar',
    'tül',
    'perdeleri',
    'perdelerini',
    'perdelerin'
  ], [
    'aç',
    'kapat',
    'indir',
    'kaldır'
  ]),

  // KLİMA İLİŞKİLERİ
  WordRelation('klima', 'hedef', [
    'klimalar',
    'havalandırma',
    'soğutma',
    'ısıtma',
    'klimaları',
    'klimalarını',
    'klimaların'
  ], [
    'aç',
    'kapat',
    'çalıştır',
    'durdur'
  ]),
];

// Türkçe kelime kökü bulma fonksiyonu
String findRootWord(String word) {
  // Türkçe karakterleri düzelt
  String normalized = word
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u')
      .replaceAll('ş', 's')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c')
      .replaceAll('İ', 'i')
      .replaceAll('Ğ', 'g')
      .replaceAll('Ü', 'u')
      .replaceAll('Ş', 's')
      .replaceAll('Ö', 'o')
      .replaceAll('Ç', 'c');

  print('Kök ayrıştırma başladı: $word -> $normalized');

  // Yaygın Türkçe ekleri kaldır
  List<String> suffixes = [
    // İyelik ekleri
    'in', 'ın', 'un', 'ün', 'nin', 'nın', 'nun', 'nün',
    'i', 'ı', 'u', 'ü',
    'n', 'ni', 'nı', 'nu', 'nü',
    // Çoğul ekleri
    'lar', 'ler',
    // Durum ekleri
    'de', 'da', 'te', 'ta',
    'den', 'dan', 'ten', 'tan',
    'e', 'a',
    'i', 'ı', 'u', 'ü',
    // Fiil çekim ekleri
    'iyor', 'ıyor', 'uyor', 'üyor',
    'ecek', 'acak',
    'miş', 'mış', 'muş', 'müş',
    'di', 'dı', 'du', 'dü',
    'ti', 'tı', 'tu', 'tü',
    'mek', 'mak',
    'meli', 'malı',
    'ebil', 'abil',
    'mı', 'mi', 'mu', 'mü',
    'sın', 'sin', 'sun', 'sün',
    'ız', 'iz', 'uz', 'üz',
    'ım', 'im', 'um', 'üm',
    'ın', 'in', 'un', 'ün',
    'ız', 'iz', 'uz', 'üz',
    'lar', 'ler',
    'ı', 'i', 'u', 'ü'
  ];

  String root = normalized;

  // Ekleri kaldır
  for (String suffix in suffixes) {
    if (root.endsWith(suffix)) {
      root = root.substring(0, root.length - suffix.length);
      print('Eki kaldırıldı: $suffix -> $root');
    }
  }

  // Özel durumlar
  if (root == 'isik') root = 'ışık';
  if (root == 'kapat') root = 'kapat';
  if (root == 'ac') root = 'aç';

  print('Kök ayrıştırma sonucu: $word -> $root');
  return root;
}

// Kelime eşleştirme fonksiyonu
bool isWordMatch(String word, String target) {
  // Türkçe karakterleri normalize et
  String normalizedWord = word
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u')
      .replaceAll('ş', 's')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c')
      .replaceAll('İ', 'i')
      .replaceAll('Ğ', 'g')
      .replaceAll('Ü', 'u')
      .replaceAll('Ş', 's')
      .replaceAll('Ö', 'o')
      .replaceAll('Ç', 'c');

  String normalizedTarget = target
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('ğ', 'g')
      .replaceAll('ü', 'u')
      .replaceAll('ş', 's')
      .replaceAll('ö', 'o')
      .replaceAll('ç', 'c')
      .replaceAll('İ', 'i')
      .replaceAll('Ğ', 'g')
      .replaceAll('Ü', 'u')
      .replaceAll('Ş', 's')
      .replaceAll('Ö', 'o')
      .replaceAll('Ç', 'c');

  // Tam eşleşme kontrolü
  if (normalizedWord == normalizedTarget) {
    print('Tam eşleşme bulundu: $word = $target');
    return true;
  }

  // Kelime kökü eşleşmesi kontrolü
  String wordRoot = findRootWord(normalizedWord);
  String targetRoot = findRootWord(normalizedTarget);
  if (wordRoot == targetRoot) {
    print('Kök eşleşmesi bulundu: $wordRoot = $targetRoot');
    return true;
  }

  // İçerme kontrolü
  if (normalizedWord.contains(normalizedTarget) ||
      normalizedTarget.contains(normalizedWord)) {
    print('İçerme eşleşmesi bulundu: $word içinde $target');
    return true;
  }

  print('Eşleşme bulunamadı: $word != $target');
  return false;
}

// Komut ayrıştırma fonksiyonu
Map<String, String> parseCommand(String command) {
  if (command.isEmpty) return {};

  // 1. Komutu temizle ve kelimelere ayır
  String cleanCommand = command
      .toLowerCase()
      .replaceAll(RegExp(r'[^\wığüşöçİĞÜŞÖÇ\s]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  List<String> words = cleanCommand.split(' ');
  print('Temizlenmiş kelimeler: $words');

  // 2. Sonuç map'i
  Map<String, String> result = {
    'tam_komut': command,
    'eylem': '',
    'konum': '',
    'hedef': ''
  };

  // 3. Her kelime için kontrol
  for (String word in words) {
    print('Kelime işleniyor: $word');

    // Konum kontrolü
    for (var group in wordGroups) {
      if (group.type == 'konum') {
        for (var location in [
          ...group.words,
          ...group.synonyms,
          ...group.variations
        ]) {
          if (isWordMatch(word, location)) {
            // Kelimeyi olduğu gibi kaydet, ana kelimeye çevirme
            result['konum'] = word;
            print('Konum bulundu: $word');
            break;
          }
        }
      }
    }

    // Hedef kontrolü
    for (var group in wordGroups) {
      if (group.type == 'hedef') {
        for (var target in [
          ...group.words,
          ...group.synonyms,
          ...group.variations
        ]) {
          if (isWordMatch(word, target)) {
            // Kelimeyi olduğu gibi kaydet, ana kelimeye çevirme
            result['hedef'] = word;
            print('Hedef bulundu: $word');
            break;
          }
        }
      }
    }

    // Eylem kontrolü
    for (var group in wordGroups) {
      if (group.type == 'eylem') {
        for (var action in [
          ...group.words,
          ...group.synonyms,
          ...group.variations
        ]) {
          if (isWordMatch(word, action)) {
            // Kelimeyi olduğu gibi kaydet, ana kelimeye çevirme
            result['eylem'] = word;
            print('Eylem bulundu: $word');
            break;
          }
        }
      }
    }
  }

  // 4. Özel kontroller ve düzeltmeler
  // Eğer eylem bulunamadıysa ve "kapat" veya "kapa" kelimeleri varsa
  if (result['eylem']?.isEmpty ?? true) {
    if (cleanCommand.contains('kapat') || cleanCommand.contains('kapa')) {
      result['eylem'] = 'kapat';
      print('Eylem bulundu (özel kontrol): kapat');
    }
  }

  // Eğer hedef bulunamadıysa ve "ışık" veya "ışıklar" kelimeleri varsa
  if (result['hedef']?.isEmpty ?? true) {
    if (cleanCommand.contains('ışık') ||
        cleanCommand.contains('ışıklar') ||
        cleanCommand.contains('isik') ||
        cleanCommand.contains('isiklar') ||
        cleanCommand.contains('lamba') ||
        cleanCommand.contains('lambalar')) {
      result['hedef'] = 'ışık';
      print('Hedef bulundu (özel kontrol): ışık');
    }
  }

  // Eğer konum bulunamadıysa ve "salon" veya "mutfak" kelimeleri varsa
  if (result['konum']?.isEmpty ?? true) {
    if (cleanCommand.contains('salon') || cleanCommand.contains('mutfak')) {
      result['konum'] = cleanCommand.contains('salon') ? 'salon' : 'mutfak';
      print('Konum bulundu (özel kontrol): ${result['konum']}');
    }
  }

  print('Ayrıştırma sonucu: $result');
  return result;
}

bool isValidCommand(Map<String, String> parsed) {
  // Üç zorunlu alan kontrolü
  bool hasAction = parsed['eylem']?.isNotEmpty ?? false;
  bool hasTarget = parsed['hedef']?.isNotEmpty ?? false;
  bool hasLocation = parsed['konum']?.isNotEmpty ?? false;

  print('Komut geçerlilik kontrolü:');
  print('- Eylem var mı: $hasAction (${parsed['eylem']})');
  print('- Hedef var mı: $hasTarget (${parsed['hedef']})');
  print('- Konum var mı: $hasLocation (${parsed['konum']})');

  // Tüm zorunlu alanların varlığını kontrol et
  return hasAction && hasTarget && hasLocation;
}

// Test fonksiyonu
void testCommand(String cmd) {
  print('\n=== Komut Testi ===');
  print('Orijinal komut: $cmd');
  var parsed = parseCommand(cmd);
  print('Ayrıştırma sonucu: $parsed');
  print('Geçerli mi: ${isValidCommand(parsed)}');
  if (isValidCommand(parsed)) {
    print('Yanıt: ${naturalFeedback(parsed)}');
  }
  print('===================\n');
}

String naturalFeedback(Map<String, String> parsed) {
  print('Yanıt oluşturma başladı. Parsed değerleri: $parsed');

  // Eksik bilgi kontrolü
  if (parsed["eylem"] == null || parsed["eylem"]!.isEmpty) {
    return "Ne yapmamı istersiniz?";
  }
  if (parsed["hedef"] == null || parsed["hedef"]!.isEmpty) {
    return "Neyi ${parsed["eylem"]}mamı istersiniz?";
  }
  if (parsed["konum"] == null || parsed["konum"]!.isEmpty) {
    return "${parsed["hedef"]}ı nerede ${parsed["eylem"]}mamı istersiniz?";
  }

  String location = parsed["konum"]!;
  String target = parsed["hedef"]!;
  String action = parsed["eylem"]!;
  String originalCommand = parsed["tam_komut"]!;

  print('Yanıt oluşturma detayları:');
  print('- Konum: $location');
  print('- Hedef: $target');
  print('- Eylem: $action');
  print('- Orijinal Komut: $originalCommand');

  // Soru formatı kontrolü
  bool isQuestion = originalCommand.toLowerCase().contains('mısın') ||
      originalCommand.toLowerCase().contains('misin') ||
      originalCommand.toLowerCase().contains('abilir') ||
      originalCommand.toLowerCase().contains('ır mı') ||
      originalCommand.toLowerCase().contains('r mısın') ||
      originalCommand.toLowerCase().contains('r misin');

  // Eylem için geçmiş zaman oluştur
  String actionPastTense = "";
  String actionPresentTense = "";

  // Eylem kökünü bul
  String actionRoot = findRootWord(action.toLowerCase());

  switch (actionRoot) {
    case "aç":
      actionPastTense = "açıldı";
      actionPresentTense = "açıyorum";
      break;
    case "kapat":
      actionPastTense = "kapatıldı";
      actionPresentTense = "kapatıyorum";
      break;
    default:
      actionPastTense = "${actionRoot}ildi";
      actionPresentTense = "${actionRoot}ıyorum";
  }

  // Konum kelimesini düzelt
  String locationWord = location;
  if (location.endsWith('ki')) {
    locationWord = location.substring(0, location.length - 2);
  }
  if (location.endsWith('de') || location.endsWith('da')) {
    locationWord = location.substring(0, location.length - 2);
  }

  // Hedef kelimesini düzelt
  String targetWord = target;
  if (target.endsWith('ı') ||
      target.endsWith('i') ||
      target.endsWith('u') ||
      target.endsWith('ü')) {
    targetWord = target.substring(0, target.length - 1);
  }
  if (target.endsWith('lar') || target.endsWith('ler')) {
    targetWord = target.substring(0, target.length - 3);
  }

  // Doğal yanıt oluştur
  String response;
  if (isQuestion) {
    response =
        "Tabii ki, ${locationWord}daki ${targetWord}ı ${actionPresentTense}.";
  } else {
    response = "${locationWord}daki ${targetWord} ${actionPastTense}.";
  }

  print('Oluşturulan yanıt: $response');
  return response;
}
