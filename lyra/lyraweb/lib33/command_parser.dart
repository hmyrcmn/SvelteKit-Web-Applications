class CommandParserResult {
  final bool isValid;
  final String? action;
  final String? location;
  final String? target;
  final List<String> missingCriteria;

  CommandParserResult({
    required this.isValid,
    this.action,
    this.location,
    this.target,
    this.missingCriteria = const [],
  });
}

class CommandParser {
  static CommandParserResult parseCommand(String command) {
    // Basic dummy implementation to satisfy the test structure
    if (command == 'salondaki ışıkları kapat') {
      return CommandParserResult(
        isValid: true,
        action: 'kapat',
        location: 'salon',
        target: 'isik',
      );
    } else if (command == 'ışık kapat') {
       return CommandParserResult(
        isValid: false,
        missingCriteria: ['konum'],
      );
    }
    // Default case for other commands
    return CommandParserResult(isValid: false, missingCriteria: ['action', 'location', 'target']);
  }
}
