import 'package:flutter/material.dart';

class LoadingImageWidget extends StatefulWidget {
  const LoadingImageWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingImageWidgetState createState() => _LoadingImageWidgetState();
}

class _LoadingImageWidgetState extends State<LoadingImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLoadingEffect(); // Show the loading effect while loading
  }

  Widget _buildLoadingEffect() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3
              ],
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.4),
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          child: Container(
            color: Colors.grey[300], // Fallback background color while loading
          ),
        );
      },
    );
  }
}