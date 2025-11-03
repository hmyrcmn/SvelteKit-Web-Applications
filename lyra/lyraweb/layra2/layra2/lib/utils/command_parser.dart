class CommandParser {
  Map<String, String> parseCommand(String command) {
    final words = command.split(" ");
    if (words.length < 3) return {};

    final konum = words[0].replaceAll("ın", "").replaceAll("ün", "");
    final hedef = words
        .sublist(1, words.length - 1)
        .join(" ")
        .replaceAll("ı", "")
        .replaceAll("i", "")
        .replaceAll("nı", "")
        .replaceAll("ni", "");
    final eylem = words.last;

    return {"konum": konum, "hedef": hedef, "eylem": eylem};
  }

  String generateResponse(Map<String, String> parts) {
    final konum = parts["konum"] ?? "";
    final hedef = parts["hedef"] ?? "";
    final eylem = parts["eylem"] ?? "";

    if (eylem.contains("aç")) {
      return "$konum'daki $hedef açıldı.";
    } else if (eylem.contains("kapat")) {
      return "$konum'daki $hedef kapatıldı.";
    } else {
      return "Anlamadım, tekrar eder misiniz?";
    }
  }
}
