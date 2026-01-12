// logic/game_logic.dart
import 'dart:math';
import 'package:flutter/material.dart';

class Spot {
  final String id;
  final Offset position;
  final Color color;
  final BoxShape shape;
  final double size;
  final List<Color> gradientColors;

  Spot({
    required this.id,
    required this.position,
    required this.color,
    required this.shape,
    required this.size,
    this.gradientColors = const [Colors.blue, Colors.purple],
  });
}

class ScoreEffect {
  final String id;
  final Offset position;
  final int score;
  final DateTime createdAt;

  ScoreEffect({
    required this.id,
    required this.position,
    required this.score,
  }) : createdAt = DateTime.now();
}

class GameLogic {
  final Random _random = Random();

  int score = 0;
  int lives = 3;
  int level = 1;
  int timeLeft = 30;
  bool isGameActive = false;

  List<Spot> spots = [];
  List<ScoreEffect> scoreEffects = [];

  final List<Color> gradientColors = [
    Colors.deepPurple,
    Colors.purple,
    Colors.pink,
    Colors.blue,
  ];

  int get maxLevels => 10;
  int get spotsCount => min(level + 2, 8);
  int get spawnSpeed => max(1500 - level * 100, 800);
  int get spotDuration => 1500;
  int get levelTime => 30;

  void reset() {
    score = 0;
    lives = 3;
    level = 1;
    timeLeft = levelTime;
    isGameActive = true;
    spots.clear();
    scoreEffects.clear();
  }

  void startGame() {
    isGameActive = true;
  }

  void stopGame() {
    isGameActive = false;
  }

  Spot spawnSpot(double left, double top, double size) {
    final newSpot = Spot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: Offset(left, top),
      color: Colors.primaries[_random.nextInt(Colors.primaries.length)]
          .withOpacity(0.9),
      shape: _random.nextBool() ? BoxShape.circle : BoxShape.rectangle,
      size: size,
      gradientColors: [
        gradientColors[_random.nextInt(gradientColors.length)],
        gradientColors[_random.nextInt(gradientColors.length)],
      ],
    );

    if (spots.length >= spotsCount) {
      spots.removeAt(0);
    }
    spots.add(newSpot);

    return newSpot;
  }

  void tapSpot(String spotId) {
    final spotIndex = spots.indexWhere((spot) => spot.id == spotId);
    if (spotIndex == -1) return;

    final spot = spots[spotIndex];
    final points = 10 * level;

    score += points;
    spots.removeAt(spotIndex);

    // Add score effect
    final effect = ScoreEffect(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: spot.position,
      score: points,
    );
    scoreEffects.add(effect);
  }

  void missSpot(String spotId) {
    spots.removeWhere((spot) => spot.id == spotId);
    if (spots.isEmpty) return;

    lives--;
  }

  void nextLevel() {
    level++;
    spots.clear();
    timeLeft = levelTime;
  }

  void updateTime() {
    timeLeft--;
  }

  void addScoreEffect(Offset position, int points) {
    scoreEffects.add(ScoreEffect(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: position,
      score: points,
    ));
  }

  void cleanupOldScoreEffects() {
    final now = DateTime.now();
    scoreEffects.removeWhere((effect) {
      return now.difference(effect.createdAt).inMilliseconds > 1000;
    });
  }

  bool get hasLivesLeft => lives > 0;
  bool get isMaxLevel => level >= maxLevels;
  bool get isTimeUp => timeLeft <= 0;
}