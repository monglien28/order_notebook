import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/logo.jpeg",
              fit: BoxFit.cover,
              color: const Color.fromARGB(
                255,
                236,
                236,
                236,
              ).withValues(alpha: 0.7),
            ),
          ),
          // Page content
          child,
        ],
      ),
    );
  }
}
