import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  bool _isListening = false;
  String _status = "Hazır";
  String? _error;

  bool get isListening => _isListening;
  String get status => _status;
  String? get error => _error;

  void setListening(bool value) {
    _isListening = value;
    notifyListeners();
  }

  void setStatus(String value) {
    _status = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void reset() {
    _isListening = false;
    _status = "Hazır";
    _error = null;
    notifyListeners();
  }
}
