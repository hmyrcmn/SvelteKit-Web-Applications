import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  static Future<bool> requestMicrophonePermission(BuildContext context) async {
    var status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await Permission.microphone.request();

      if (status.isGranted) {
        return true;
      } else {
        _showPermissionDialog(
          context,
          'Mikrofon İzni Gerekli',
          'Sesli komutları algılayabilmek için mikrofon iznine ihtiyacım var. Lütfen ayarlardan mikrofon iznini etkinleştirin.',
        );
        return false;
      }
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDialog(
        context,
        'Mikrofon İzni Reddedildi',
        'Mikrofon izni kalıcı olarak reddedildi. Ayarlardan mikrofon iznini etkinleştirmeniz gerekiyor.',
        showSettingsButton: true,
      );
      return false;
    }

    return false;
  }

  static void _showPermissionDialog(
    BuildContext context,
    String title,
    String message, {
    bool showSettingsButton = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (showSettingsButton)
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              child: const Text('Ayarlara Git'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Tamam',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
