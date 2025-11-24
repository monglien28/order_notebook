import 'dart:math';

import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Faster animation
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha:  0.5), // <-- UPDATED (was .withValues)
      child: Center(
        child: SizedBox(
          width: 120, // Adjusted size
          height: 120, // Adjusted size
          child: Stack(
            children: List.generate(4, (index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double angle =
                      (index / 4) * 2 * pi + _controller.value * 2 * pi;
                  double radius =
                      30 * (1 - _controller.value); // Adjusted radius

                  // Scale and depth effect
                  double scale =
                      1 + _controller.value * 0.5; // Scale for 3D effect
                  double zIndex =
                      1 - _controller.value; // Z-index for depth effect

                  // --- Your New Opacity Logic ---
                  // Get the dot's base color
                  Color baseColor = _getDotColor(index); // <-- NEW

                  // Calculate opacity:
                  // When value is 0.0, opacity = 1.0 (fully opaque)
                  // When value is 1.0, opacity = 0.3 (translucent)
                  double opacity = 1.0 - (_controller.value * 0.7); // <-- NEW

                  // Apply the calculated opacity to the base color
                  Color animatedColor = baseColor.withValues(
                    alpha: opacity,
                  ); // <-- NEW
                  // --- End of New Logic ---

                  return Positioned(
                    left:
                        60 +
                        radius * cos(angle) -
                        10, // Adjusted for smaller size
                    top:
                        60 +
                        radius * sin(angle) -
                        10, // Adjusted for smaller size
                    child: Transform.scale(
                      scale: scale,
                      child: Dot(
                        color:
                            animatedColor, // <-- UPDATED (was _getDotColor(index))
                        zIndex: zIndex,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  Color _getDotColor(int index) {
    switch (index) {
      case 0:
        return Colors.white;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.teal;
      case 3:
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }
}

class Dot extends StatelessWidget {
  final Color color;
  final double zIndex;

  const Dot({super.key, required this.color, required this.zIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, // Adjusted size
      height: 20, // Adjusted size
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
