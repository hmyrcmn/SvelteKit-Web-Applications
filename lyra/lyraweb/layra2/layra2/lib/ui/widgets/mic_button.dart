import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MicButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onPressed;

  const MicButton({
    Key? key,
    required this.isListening,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.only(bottom: 32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isListening)
              Lottie.asset(
                'assets/animations/listenAnim.json',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
                repeat: true,
              ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isListening ? Colors.red : Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(Icons.mic, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
