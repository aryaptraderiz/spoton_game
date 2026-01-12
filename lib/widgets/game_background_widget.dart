import 'dart:math';
import 'package:flutter/material.dart';

class GameBackgroundWidget extends StatelessWidget {
  final int level;
  final List<Widget> children;

  const GameBackgroundWidget({
    super.key,
    required this.level,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated Background
        AnimatedContainer(
          duration: const Duration(seconds: 2),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.8,
              colors: [
                Colors.deepPurple.withOpacity(level / 10),
                Colors.purple.withOpacity(level / 15),
                const Color(0xFF0A0E21).withOpacity(0.9),
              ],
              stops: const [0.0, 0.3, 1.0],
            ),
          ),
        ),

        // Children widgets
        ...children,
      ],
    );
  }
}

class ParticlesWidget extends StatelessWidget {
  final int count;
  final double safeAreaTop;
  final double safeAreaBottom;
  final double safeAreaLeft;
  final double safeAreaRight;

  const ParticlesWidget({
    super.key,
    this.count = 15,
    required this.safeAreaTop,
    required this.safeAreaBottom,
    required this.safeAreaLeft,
    required this.safeAreaRight,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(); // FIX: Random() constructor
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: List.generate(count, (index) {
        // Calculate position within safe area
        final left = safeAreaLeft +
            random.nextDouble() * (screenWidth - safeAreaLeft - safeAreaRight);
        final top = safeAreaTop +
            random.nextDouble() * (screenHeight - safeAreaTop - safeAreaBottom);

        return Positioned(
          left: left,
          top: top,
          child: Container(
            width: random.nextDouble() * 3 + 1,
            height: random.nextDouble() * 3 + 1,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(random.nextDouble() * 0.2),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

class BottomControlsWidget extends StatelessWidget {
  const BottomControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.touch_app_rounded,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                "Tap the spots before they disappear!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BackButtonWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 20,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}