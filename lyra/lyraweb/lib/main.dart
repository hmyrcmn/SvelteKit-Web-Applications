import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

// Bu dosyaların projenizde var olduğundan ve doğru şekilde yapılandırıldığından emin olun.
import 'voice_service.dart';
import 'message_bubble.dart';
import 'background_widget.dart';

// GÜVENLİK UYARISI: API anahtarınızı buraya yapıştırın.
// Bu anahtarı herkese açık yerlerde (örn. GitHub) paylaşmamaya özen gösterin.
const GEMINI_API_KEY = "AIzaSyD875C-7kNQgcTpeOFxQA67w_IsaLoagx0"; // LÜTFEN KENDİ API ANAHTARINIZI GİRİN

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
  // State Değişkenleri
  final VoiceService _voiceService = VoiceService();
  final ScrollController _scrollController = ScrollController();
  final List<String> _messages = [];
  bool _isListening = false;
  bool _showLyraOverlay = false;

  // YENİ: 10 saniyelik sessizlik zaman aşımı için zamanlayıcı
  Timer? _silenceTimer;

  // Gemini için Gerekli State'ler
  late final GenerativeModel _model;
  late ChatSession _chat;
  bool _isProcessingGemini = false;

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();

    // Gemini Modelini ve Sohbet Oturumunu Başlatma
    // Bu kısım, sistem talimatlarınızı içerir.
    final systemInstruction = Content.text(r"""
🤖 Layra Komut İşleyici Yapay Zeka – Görev Tanımı  
Sen, adımları takip ederek doğal dilde gelen ev otomasyon komutlarını yorumlayan, eksikleri tamamlayan ve simüle eden ‘Layra’ isimli bir AI’sın.  
Her işlemi bir JSON çıktısı olarak hazırlar ve kullanıcıya hem bu JSON hem de açıklayıcı doğal dilde simülasyon sonucu ile yanıt verirsin.  

----------------------------------------  
🧩 KOMUT YAPISI  
Her komut aşağıdaki bileşenleri içerir (birden çok değere izinli):  
• locations (array of string) – İşlemin yapılacağı yerler  
• targets (array of string) – Kontrol edilecek nesneler  
• actions (array of string) – Yapılacak eylemler  
• schedule (object | null) – Zamanlı komut için: { "time": "YYYY-MM-DDTHH:MM:SS±HH:MM" }, belirtilmemişse işlem anında yapılır  
• query (boolean) – Durum sorgusuysa true  
• steps (array of objects | null) – Çok adımlı komutlar için  
• raw_command (string) – Kullanıcının girdiği metin  
• received_time (string) – Komutun alındığı tarih: "YYYY-MM-DDTHH:MM:SS"  

----------------------------------------  
🧠 İŞLEM AKIŞI  

1️⃣ Normalize Et  
- Küçük harfe çevir, dolgu kelimeleri ve noktalama temizle  

2️⃣ Ayrıştır (Parse)  
- locations, targets, actions, schedule gibi parçaları çıkart  
- "yarın", "sabah", "öğle", "akşam", "gece" gibi doğal zaman ifadelerini tanı:  
  sabah → 07:00  
  öğle → 12:00  
  akşam → 18:00  
  gece → 22:00  
- Kullanıcının gönderdiği tarih = received_time  
- Eğer komutta zaman belirtilmemişse: schedule.time = received_time  
- Eğer komut belirsiz zaman içeriyorsa:  
  → Kullanıcıya: "Öğle saatinde klimayı açmamı ister misin? (varsayılan 12:00)" gibi bir soru sor  
  → "Evet" derse belirtilen saat alınır, "Hayır" derse saat bilgisi istenir  

3️⃣ Eksik Bilgi Kontrolü ve Soru Yönetimi  
- locations eksikse: "Neredeki <target> için işlem yapmamı istersin?"  
- targets eksikse: "Hangi cihazı kontrol etmemi istersin?"  
- actions eksikse: "Ne yapılmasını istersin: aç, kapat, kıs...?"  
- schedule eksikse ama komut zamanı belirsizse: "Bu işlemi ne zaman yapmamı istersin?"  
- Kullanıcıdan alınan bilgi, orijinal komutla birleştirilerek yeniden işlenir  

4️⃣ Yanıt Formatı  
Komut tamamlandıktan sonra tek bir yanıt döndürülür:  

✅ Doğal Dil Cevap Örneği:  
- “Mutfaktaki ışıkları kapatıyorum.”  
- “25 Haziran 2025 tarihinde saat 07:00'de klimayı kapatacağım.”  

✅ JSON Çıktısı Örneği:
{
  "locations": ["mutfak"],
  "targets": ["ışık"],
  "actions": ["kapat"],
  "query": false,
  "schedule": {
    "time": "2025-06-25T07:00:00+03:00"
  },
  "received_time": "2025-06-24T15:30:00+03:00",
  "steps": null,
  "raw_command": "Mutfaktaki ışıkları kapat"
}
""");



    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: GEMINI_API_KEY,
      systemInstruction: systemInstruction,
    );

    _chat = _model.startChat();
  }

  @override
  void dispose() {
    _voiceService.dispose();
    _silenceTimer?.cancel(); // Widget yok edilirken zamanlayıcıyı iptal et
    _scrollController.dispose();
    super.dispose();
  }

  /// Mikrofon butonuna basıldığında dinlemeyi başlatır.
  Future<void> _startListening() async {
    // Varsa önceki zamanlayıcıyı temizle
    _silenceTimer?.cancel();

    bool available = await _voiceService.initialize(
      onStatus: (status) {},
      onError: (error) => _showError("Mikrofon hatası: $error"),
    );
    if (!available) {
      _showError("Mikrofon başlatılamadı. Lütfen izinleri kontrol edin.");
      return;
    }

    setState(() {
      _isListening = true;
      _chat = _model.startChat(); // Her yeni komutta sohbeti sıfırla (isteğe bağlı)
    });

    // YENİ: Dinleme başladığı anda 10 saniyelik sessizlik sayacını başlat
    _silenceTimer = Timer(const Duration(seconds: 10), () {
      _stopListeningDueToTimeout();
    });

    // Doğrudan komutu dinle ve sonucu _handleCommandResult'a gönder
    _voiceService.listen(
      onResult: (recognized) {
        // Boş sonuçları dikkate almamak için kontrol
        if (recognized.isNotEmpty) {
          _handleCommandResult(recognized);
        }
      },
    );
  }

  /// YENİ: Zaman aşımı durumunda dinlemeyi durduran fonksiyon.
  void _stopListeningDueToTimeout() {
    // Sadece hala dinleme modundaysa işlem yap
    if (_isListening) {
      print("Zaman aşımı: 10 saniye boyunca ses algılanmadı. Mikrofon kapatılıyor.");
      _voiceService.stop();
      setState(() {
        _isListening = false;
        // İsteğe bağlı: Kullanıcıyı bilgilendirmek için bir mesaj ekleyebilirsiniz.
        // _addMessage("Asistan: Zaman aşımı. Mikrofon kapatıldı.");
      });
    }
  }

  /// Kullanıcı komutunu alıp Gemini ile işleyen ve konuşma akışını yöneten ana fonksiyon.
  Future<void> _handleCommandResult(String recognized) async {
    // GÜNCELLENDİ: Komut algılandığı anda sessizlik sayacını iptal et.
    _silenceTimer?.cancel();

    // Zaten bir komut işleniyorsa veya dinleme kapalıysa tekrar çalıştırma
    if (!_isListening) return;

    _voiceService.stop(); // Yeni komut geldi, dinlemeyi durdurup işlemeye başla
    setState(() {
      _isListening = false;
      _isProcessingGemini = true;
      _showLyraOverlay = true;
      _addMessage("Kullanıcı: $recognized");
    });

    final geminiResponse = await _sendToGemini(recognized);

    // Gelen cevabı etiketine göre işle (Soru mu, Eylem mi?)
    if (geminiResponse.startsWith('[SORU]')) {
      await _handleQuestionResponse(geminiResponse);
    } else { // [EYLEM] veya etiketsiz fallback durumu
      await _handleActionResponse(geminiResponse);
    }
  }

  /// Gemini'ye metni gönderip cevabını alan fonksiyon.
  Future<String> _sendToGemini(String prompt) async {
    try {
      final response = await _chat.sendMessage(Content.text(prompt));
      return response.text ?? "[EYLEM]Üzgünüm, anlayamadım. Tekrar dener misin?";
    } catch (e) {
      print("Gemini Hatası: $e");
      return "[EYLEM]Bir hata oluştu, lütfen daha sonra tekrar deneyin.";
    }
  }

  /// Gemini bir soru sorduğunda bu fonksiyon çalışır.
  Future<void> _handleQuestionResponse(String response) async {
    final question = response.replaceFirst('[SORU]', '').trim();
    setState(() {
      _addMessage("Asistan: $question");
      _isProcessingGemini = false;
    });

    await _voiceService.speakAndWait(question);

    // Sorunun cevabını almak için tekrar dinlemeyi başlat
    setState(() { _showLyraOverlay = false; });
    // Kullanıcıdan cevap almak için mikrofonu yeniden aç
    _startListening();
  }

  /// Gemini bir eylemi onayladığında bu fonksiyon çalışır.
  Future<void> _handleActionResponse(String response) async {
    final actionConfirmation = response.replaceFirst('[EYLEM]', '').trim();
    // JSON kısmını ayıkla (ilk { karakterinden sonrası)
    String textToSpeak = actionConfirmation;
    int jsonIndex = actionConfirmation.indexOf('{');
    if (jsonIndex != -1) {
      textToSpeak = actionConfirmation.substring(0, jsonIndex).trim();
    }
    setState(() {
      _addMessage("Asistan: $actionConfirmation");
      _isProcessingGemini = false;
    });
    if (textToSpeak.isNotEmpty) {
      await _voiceService.speakAndWait(textToSpeak);
    }
    setState(() { _showLyraOverlay = false; });
  }


  // --- Yardımcı Fonksiyonlar ve UI Kodu (Değişiklik Gerekmiyor) ---

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
    // Eğer hata mikrofon ile ilgiliyse hiçbir yerde gösterme
    if (message.toLowerCase().contains("mikrofon")) {
      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
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

  void _addMessage(String message) {
    // Tekrarlanan mesajları engellemek için basit kontrol
    if (_messages.isEmpty || _messages.last != message) {
      setState(() {
        _messages.add(message);
      });
    }
    _scrollToBottom();
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
            Image.asset('assets/lyra.png', width: 36, height: 36),
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
          BackgroundWidget(
            opacity: 1.0,
            blurSigma: 3,
            imagePath: 'assets/lyrabg.png',
          ),
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
                child: _isListening || _isProcessingGemini
                    ? Lottie.asset(
                        'assets/animations/anim.json',
                        width: 70,
                        height: 70,
                        repeat: true,
                      )
                    : IconButton(
                        icon: const Icon(Icons.mic, size: 50, color: Colors.blueAccent),
                        // Gemini işlem yaparken butonu devre dışı bırak
                        onPressed: _isProcessingGemini ? null : _startListening,
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