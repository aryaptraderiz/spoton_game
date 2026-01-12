import 'package:flutter/material.dart';
import '../logic/game_logic.dart';

class SpotWidget extends StatefulWidget {
  final Spot spot;
  final VoidCallback onTap;
  final double scale;

  const SpotWidget({
    super.key,
    required this.spot,
    required this.onTap,
    this.scale = 1.0,
  });

  @override
  State<SpotWidget> createState() => _SpotWidgetState();
}

class _SpotWidgetState extends State<SpotWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: widget.scale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: widget.spot.size,
            height: widget.spot.size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.spot.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: widget.spot.shape,
              borderRadius: widget.spot.shape == BoxShape.rectangle
                  ? BorderRadius.circular(20)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: widget.spot.gradientColors[0].withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(-2, -2),
                ),
              ],
            ),
            child: Center(
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(0),
                child: Icon(
                  widget.spot.shape == BoxShape.circle
                      ? Icons.circle_rounded
                      : Icons.square_rounded,
                  color: Colors.white.withOpacity(0.2),
                  size: widget.spot.size * 0.6,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}