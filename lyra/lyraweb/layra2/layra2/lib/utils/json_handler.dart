import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/command_model.dart';

class JsonHandler {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/komutlar.json');
  }

  Future<void> saveCommand(Command command) async {
    final file = await _localFile;
    final json = command.toJson();
    List<Map<String, dynamic>> existingData = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      existingData = List<Map<String, dynamic>>.from(jsonDecode(content));
    }

    existingData.add(json);
    await file.writeAsString(jsonEncode(existingData));
  }

  Future<List<Command>> loadCommands() async {
    final file = await _localFile;
    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> data = jsonDecode(content);
      return data.map((item) => Command.fromJson(item)).toList();
    }
    return [];
  }
}
