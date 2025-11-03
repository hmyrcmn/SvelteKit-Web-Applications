import '../main.dart';

/// Komut işleme ve tetikleyici kelime yönetimi için servis sınıfı
class CommandProcessor {
  /// Tetikleyici kelime varyasyonları
  static const List<String> WAKE_WORD_VARIATIONS = [
    "hey layra",
    "hey lara",
    "hey lera",
    "hey lira",
    "leyla ile",
    "he ilayda",
    "hey layla",
    "he ilayda",
  ];

  /// Geçerli eylemler listesi
  static const List<String> VALID_ACTIONS = [
    "aç",
    "kapat",
    "kapa",
    "açık",
    "kapalı",
    "git",
    "gel",
    "getir",
    "götür"
  ];

  /// Geçerli konumlar listesi
  static const List<String> VALID_LOCATIONS = [
    "salon",
    "mutfak",
    "oda",
    "banyo",
    "koridor",
    "bahçe",
    "yatak",
    "çocuk",
    "çalışma",
    "oturma"
  ];

  /// Tetikleyici kelime kontrolü
  static bool isWakeWord(String text) {
    if (text.isEmpty) return false;

    String normalizedText = text.toLowerCase().trim();
    return AppConstants.WAKE_WORD_VARIATIONS
        .any((wakeWord) => normalizedText.contains(wakeWord.toLowerCase()));
  }

  /// Komut ayrıştırma
  static Map<String, String> parseCommand(String command) {
    if (command.isEmpty) return {};

    String fullCommand = _normalizeCommand(command);
    List<String> words =
        fullCommand.split(" ").where((s) => s.isNotEmpty).toList();
    if (words.isEmpty) return {};

    // Eylem kelimesi bul
    String action = _findAction(words);
    if (action.isEmpty) return {};

    // Konum ve hedef kelimeleri bul
    String location = _findLocation(words);
    String target = _findTarget(words, action, location);

    // Eğer konum bulunamadıysa ve hedef varsa, hedefi konum olarak kabul et
    if (location.isEmpty && target.isNotEmpty) {
      location = target;
      target = "ışık"; // Varsayılan hedef
    }

    return {
      "konum": location,
      "hedef": target,
      "eylem": action,
      "tam_komut": command,
    };
  }

  /// Komut normalizasyonu
  static String _normalizeCommand(String command) {
    return command
        .toLowerCase()
        .replaceAll(RegExp(r'(in|ın|un|ün|nin|nın|nun|nün)$'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
  }

  /// Eylem kelimesi bulma
  static String _findAction(List<String> words) {
    for (int i = 0; i < words.length; i++) {
      if (AppConstants.VALID_ACTIONS.contains(words[i])) {
        return words[i];
      }
    }
    return "";
  }

  /// Konum kelimesi bulma
  static String _findLocation(List<String> words) {
    for (int i = 0; i < words.length; i++) {
      if (AppConstants.VALID_LOCATIONS.contains(words[i])) {
        return words[i];
      }
    }
    return "";
  }

  /// Hedef kelimeleri bulma
  static String _findTarget(
      List<String> words, String action, String location) {
    List<String> targetWords = [];
    for (int i = 0; i < words.length; i++) {
      if (words[i] != action && words[i] != location) {
        targetWords.add(words[i]);
      }
    }
    return targetWords.join(" ");
  }

  /// Yanıt oluşturma
  static String generateResponse(Map<String, String> parsed) {
    if (!_validateCommand(parsed)) {
      return _generateErrorResponse(parsed);
    }

    String location = parsed["konum"]!;
    String target = parsed["hedef"]!;
    String action = parsed["eylem"]!;
    String actionPastTense = _getActionPastTense(action);

    // Eğer hedef boşsa veya "ışık" ise, sadece konum ve eylemi kullan
    if (target.isEmpty || target == "ışık") {
      return "$location $actionPastTense.";
    }

    return "${location}daki $target $actionPastTense.";
  }

  /// Komut doğrulama
  static bool _validateCommand(Map<String, String> parsed) {
    return parsed["eylem"] != null &&
        parsed["eylem"]!.isNotEmpty &&
        parsed["konum"] != null &&
        parsed["konum"]!.isNotEmpty;
  }

  /// Hata yanıtı oluşturma
  static String _generateErrorResponse(Map<String, String> parsed) {
    if (parsed["eylem"] == null || parsed["eylem"]!.isEmpty) {
      return "Ne yapmamı istersiniz?";
    }
    return "Neyi ${parsed["eylem"]}mamı istersiniz?";
  }

  /// Eylem için geçmiş zaman oluşturma
  static String _getActionPastTense(String action) {
    switch (action) {
      case "aç":
      case "açık":
        return "açıldı";
      case "kapat":
      case "kapa":
      case "kapalı":
        return "kapatıldı";
      case "git":
        return "gidildi";
      case "gel":
        return "gelindi";
      case "getir":
        return "getirildi";
      case "götür":
        return "götürüldü";
      default:
        return "${action}ildi";
    }
  }
}
