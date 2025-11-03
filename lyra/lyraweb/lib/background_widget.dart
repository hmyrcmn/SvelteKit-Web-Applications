import 'dart:ui';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatefulWidget {
  final double opacity;
  final double blurSigma;
  final String imagePath;
  const BackgroundWidget({super.key, required this.opacity, this.blurSigma = 12, required this.imagePath});

  @override
  _BackgroundWidgetState createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: widget.opacity).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Image.asset(
                  widget.imagePath,
                  width: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.3),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blurSigma, sigmaY: widget.blurSigma),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
