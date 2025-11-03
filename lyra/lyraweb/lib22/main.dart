import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'voice_service.dart';
import 'message_bubble.dart';
import 'background_widget.dart';
import 'package:permission_handler/permission_handler.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final VoiceService _voiceService = VoiceService();
  final ScrollController _scrollController = ScrollController();
  bool _isListening = false;
  String _text = '';
  final List<String> _messages = [];
  Timer? _commandSilenceTimer;
  bool _showLyraOverlay = false;
  bool _awaitingCommand = false;

  static const List<String> WAKE_WORD_VARIATIONS = [
    "hey layra","leyla","hey leyla" "he layra", "he öyle", "heyra ile", "hey gayrı", "hey lara", "hey lera", "hey lira", "leyla ile", "he ilayda", "hey layla", "hey ilayda", "hey kayra", "hey yayla", "hayır hayır"
  ];

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();
  }

  Future<void> _checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        _showError("Mikrofon izni verilmedi. Uygulamanın çalışması için izin gereklidir.");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addMessage(String message, {bool isWakeWord = false}) {
    if (isWakeWord) {
      if (_messages.isEmpty || !_messages.last.startsWith("Kullanıcı: hey layra")) {
        _messages.add("Kullanıcı: hey layra");
      }
    } else {
      if (_messages.isEmpty || _messages.last != message) {
        _messages.add(message);
      }
    }
    _scrollToBottom();
  }

  void _stopListening() {
    _voiceService.stop();
    _commandSilenceTimer?.cancel();
    setState(() {
      _isListening = false;
      _showLyraOverlay = false;
    });
    if (_text.isNotEmpty) {
      _addMessage("Kullanıcı: $_text");
      _voiceService.speak(_text);
      _text = '';
    }
  }

  void _resetCommandSilenceTimer() {
    _commandSilenceTimer?.cancel();
    _commandSilenceTimer = Timer(const Duration(seconds: 10), () async {
      if (_awaitingCommand) {
        _awaitingCommand = false;
        _isListening = false;
        _voiceService.stop();
        setState(() {
          _addMessage("Asistan: Sizi anlayamadım");
          _showLyraOverlay = false;
        });
        await _voiceService.speak("Sizi anlayamadım");
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          _isListening = true;
          _awaitingCommand = true;
        });
        _startCommandListening();
      }
    });
  }

  void _handleCommandResult(String recognized) async {
    if (_awaitingCommand && recognized.isNotEmpty) {
      _awaitingCommand = false;
      _isListening = false;
      _voiceService.stop();
      _commandSilenceTimer?.cancel();
      setState(() {
        _addMessage("Kullanıcı: $recognized");
        _showLyraOverlay = true;
      });
      String yanit = "$recognized komutu işlendi";
      setState(() {
        _addMessage("Asistan: $yanit");
      });
      await _voiceService.speak(yanit);
      setState(() {
        _showLyraOverlay = false;
      });
      _text = '';
    }
  }

  void _startCommandListening() {
    _voiceService.listen(
      onResult: (recognized) {
        setState(() {
          _text = recognized;
        });
        _handleCommandResult(_text);
        _resetCommandSilenceTimer();
      },
    );
    _resetCommandSilenceTimer();
  }

  void _handleSpeechResultTrigger(String recognized) async {
    final recognizedLower = recognized.toLowerCase();
    final isWakeWord = WAKE_WORD_VARIATIONS.any((w) => recognizedLower.contains(w));
    if (isWakeWord) {
      setState(() {
        _showLyraOverlay = true;
      });
      _addMessage("Kullanıcı: hey layra", isWakeWord: true);
      _awaitingCommand = true;
      await Future.delayed(const Duration(milliseconds: 300));
      await _voiceService.speak("Efendim");
      setState(() {
        _addMessage("Asistan: Efendim");
        _isListening = true;
        _awaitingCommand = true;
      });
      _startCommandListening();
    } else if (recognized.isNotEmpty) {
      setState(() {
        _showLyraOverlay = false;
      });
      _addMessage("Kullanıcı: $recognized");
      await _voiceService.speak("Lütfen hey layra deyin");
      setState(() {
        _addMessage("Asistan: Lütfen hey layra deyin");
      });
      _text = '';
    }
  }

  void _startListening() async {
    bool available = await _voiceService.initialize(
      onStatus: (status) {
        if (status == "done" && _isListening) {
          _stopListening();
        }
      },
      onError: (error) {
        _showError("Mikrofon veya sesli yanıt hatası: $error");
      },
    );
    if (!available) {
      _showError("Mikrofon başlatılamadı. Lütfen izinleri kontrol edin.");
      return;
    }
    setState(() {
      _isListening = true;
      _awaitingCommand = false;
      _text = '';
    });
    _voiceService.listen(
      onResult: (recognized) {
        final recognizedLower = recognized.toLowerCase();
        final isWakeWord = WAKE_WORD_VARIATIONS.any((w) => recognizedLower.contains(w));
        if (isWakeWord) {
          _handleSpeechResultTrigger(recognized);
        } else {
          setState(() {
            _text = recognized;
          });
          _addMessage("Kullanıcı: $_text");
          _handleSpeechResultTrigger(_text);
        }
      },
    );
  }

  @override
  void dispose() {
    _voiceService.dispose();
    _commandSilenceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/lyra.png',
              width: 36,
              height: 36,
            ),
            const SizedBox(width: 10),
            const Text(
              "Layra Asistan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundWidget(opacity: 1.0, blurSigma: 3, imagePath: 'assets/lyrabg.png'),
          // bg.png sadece lyra overlay yoksa gösterilsin
          if (!_showLyraOverlay)
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  'assets/bg.png',
                  width: MediaQuery.of(context).size.width * 0.95,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          Column(
            children: [
              SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 10),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  itemCount: _messages.length,
                  itemBuilder: (_, index) {
                    final isUser = _messages[index].startsWith("Kullanıcı:");
                    return MessageBubble(
                      message: _messages[index].replaceFirst("Kullanıcı: ", "").replaceFirst("Asistan: ", ""),
                      isUser: isUser,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
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
                        onPressed: () {
                          if (!_isListening) {
                            _startListening();
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
          if (_showLyraOverlay)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 700),
                    child: Image.asset(
                      'assets/lyra.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
