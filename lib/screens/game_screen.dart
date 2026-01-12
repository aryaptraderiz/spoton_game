import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/score_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  final ScoreService _scoreService = ScoreService();

  int score = 0;
  int lives = 3;
  int level = 1;
  int timeLeft = 30;
  bool isGameActive = true;

  List<_Spot> spots = [];
  List<Color> gradientColors = [
    Colors.deepPurple,
    Colors.purple,
    Colors.pink,
    Colors.blue,
  ];

  Timer? spawnTimer;
  Timer? levelTimer;

  int get maxLevels => 10;
  int get spotsCount => min(level + 2, 8);
  int get spawnSpeed => max(1500 - level * 100, 800);
  int get spotDuration => 1500;
  int get levelTime => 30;

  // Area untuk munculkan spot supaya tidak melebihi ui
  late double safeAreaTop;
  late double safeAreaBottom;
  late double safeAreaLeft;
  late double safeAreaRight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateSafeArea();
      _startGame();
    });
  }

  void _calculateSafeArea() {

    safeAreaTop = 220.0;
    safeAreaBottom = 80.0;
    safeAreaLeft = 20.0;
    safeAreaRight = 20.0;
  }

  @override
  void dispose() {
    _cleanupTimers();
    super.dispose();
  }

  void _cleanupTimers() {
    spawnTimer?.cancel();
    levelTimer?.cancel();
    isGameActive = false;
  }

  void _startGame() {
    setState(() {
      isGameActive = true;
      spots.clear();
      timeLeft = levelTime;
    });

    spawnTimer?.cancel();
    levelTimer?.cancel();

    // Timer untuk level
    levelTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !isGameActive) return;
      setState(() {
        timeLeft--;
      });

      if (timeLeft <= 0) {
        _nextLevel();
      }
    });

    // Timer untuk spawn spot
    _scheduleSpotSpawn();
  }

  void _scheduleSpotSpawn() {
    spawnTimer = Timer.periodic(
      Duration(milliseconds: spawnSpeed),
          (_) {
        if (!mounted || !isGameActive) return;
        _spawnSpot();
      },
    );
  }

  void _spawnSpot() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final safeWidth = screenWidth - safeAreaLeft - safeAreaRight;
    final safeHeight = screenHeight - safeAreaTop - safeAreaBottom;


    double maxSpotSize = min(safeWidth, safeHeight) * 0.3;
    double spotSize = 60.0 + _random.nextDouble() * 40.0;
    spotSize = min(spotSize, maxSpotSize);

    double left = safeAreaLeft + _random.nextDouble() * (safeWidth - spotSize);
    double top = safeAreaTop + _random.nextDouble() * (safeHeight - spotSize);


    double uiBuffer = 20.0;
    left = left.clamp(safeAreaLeft + uiBuffer, screenWidth - safeAreaRight - spotSize - uiBuffer);
    top = top.clamp(safeAreaTop + uiBuffer, screenHeight - safeAreaBottom - spotSize - uiBuffer);

    final newSpot = _Spot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: Offset(left, top),
      color: Colors.primaries[_random.nextInt(Colors.primaries.length)]
          .withOpacity(0.9),
      shape: _random.nextBool() ? BoxShape.circle : BoxShape.rectangle,
      size: spotSize,
      gradientColors: [
        gradientColors[_random.nextInt(gradientColors.length)],
        gradientColors[_random.nextInt(gradientColors.length)],
      ],
    );

    setState(() {
      if (spots.length >= spotsCount) {
        spots.removeAt(0);
      }
      spots.add(newSpot);
    });

    Future.delayed(Duration(milliseconds: spotDuration), () {
      if (mounted && isGameActive && spots.any((spot) => spot.id == newSpot.id)) {
        _missSpot(newSpot.id);
      }
    });
  }

  void _tapSpot(String id) {
    if (!mounted || !isGameActive) return;

    setState(() {
      score += 10 * level;
      spots.removeWhere((spot) => spot.id == id);

      // Animation effect
      _showScorePopup(id);
    });
  }

  void _showScorePopup(String id) {
    final spot = spots.firstWhere((s) => s.id == id);

    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: spot.position.dx + spot.size / 2 - 30,
        top: spot.position.dy - 30,
        child: Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                "+${10 * level}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    Future.delayed(const Duration(milliseconds: 500), () {
      overlayEntry?.remove();
    });
  }

  void _missSpot(String id) {
    if (!mounted || !isGameActive) return;

    setState(() {
      spots.removeWhere((spot) => spot.id == id);
      if (spots.isEmpty) return;

      lives--;
    });

    if (lives <= 0 && isGameActive) {
      _endGame();
    }
  }

  void _nextLevel() {
    if (level < maxLevels && isGameActive) {
      setState(() {
        level++;
        spots.clear();
        timeLeft = levelTime;
      });

      _showLevelUpAnimation();
    } else if (isGameActive) {
      _endGame();
    }
  }

  void _showLevelUpAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.stars_rounded,
                color: Colors.amber,
                size: 60,
              ),
              const SizedBox(height: 20),
              Text(
                "LEVEL UP!",
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Now Level $level",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "CONTINUE",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _endGame() async {
    _cleanupTimers();

    await _scoreService.saveScore(score);

    if (!mounted) return;

    _showGameOverDialog();
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1F38), Color(0xFF0A0E21)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.deepPurple.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Game Over Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.pink.shade400],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sports_esports_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 20),


                Text(
                  "GAME OVER",
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 5),
                Text(
                  "Great effort!",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

                // Stats Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildStatRow(
                        icon: Icons.emoji_events_rounded,
                        label: "FINAL SCORE",
                        value: "$score",
                        color: Colors.amber,
                      ),
                      const Divider(color: Colors.white24),
                      _buildStatRow(
                        icon: Icons.stacked_line_chart_rounded,
                        label: "LEVEL REACHED",
                        value: "Level $level",
                        color: Colors.green,
                      ),
                      const Divider(color: Colors.white24),
                      _buildStatRow(
                        icon: Icons.favorite_rounded,
                        label: "LIVES LEFT",
                        value: lives.toString(),
                        color: Colors.pink,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Success Message
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Score saved to leaderboard!",
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: const BorderSide(color: Colors.deepPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.home_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "HOME",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    // Play Again Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            score = 0;
                            lives = 3;
                            level = 1;
                            spots.clear();
                            isGameActive = true;
                          });
                          _startGame();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.restart_alt_rounded,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "PLAY AGAIN",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Stack(
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


          ...List.generate(15, (index) {
            final left = safeAreaLeft + _random.nextDouble() *
                (MediaQuery.of(context).size.width - safeAreaLeft - safeAreaRight);
            final top = safeAreaTop + _random.nextDouble() *
                (MediaQuery.of(context).size.height - safeAreaTop - safeAreaBottom);

            return Positioned(
              left: left,
              top: top,
              child: Container(
                width: _random.nextDouble() * 3 + 1,
                height: _random.nextDouble() * 3 + 1,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_random.nextDouble() * 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),

          // Game Spots
          ...spots.map((spot) {
            return Positioned(
              left: spot.position.dx,
              top: spot.position.dy,
              child: GestureDetector(
                onTap: () => _tapSpot(spot.id),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: spot.size,
                    height: spot.size,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: spot.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: spot.shape,
                      borderRadius: spot.shape == BoxShape.rectangle
                          ? BorderRadius.circular(20)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: spot.gradientColors[0].withOpacity(0.5),
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
                      child: AnimatedRotation(
                        duration: const Duration(seconds: 2),
                        turns: _random.nextDouble(),
                        child: Icon(
                          spot.shape == BoxShape.circle
                              ? Icons.circle_rounded
                              : Icons.square_rounded,
                          color: Colors.white.withOpacity(0.2),
                          size: spot.size * 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.withOpacity(0.9),
                    Colors.purple.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Game Info Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Level Card
                      _buildInfoCard(
                        icon: Icons.stacked_line_chart_rounded,
                        title: "LEVEL",
                        value: "$level",
                        color: Colors.deepPurple,
                      ),

                      // Score Card
                      _buildInfoCard(
                        icon: Icons.emoji_events_rounded,
                        title: "SCORE",
                        value: "$score",
                        color: Colors.amber,
                      ),

                      // Time Card
                      _buildInfoCard(
                        icon: Icons.timer_rounded,
                        title: "TIME",
                        value: "${timeLeft}s",
                        color: timeLeft < 10 ? Colors.red : Colors.blue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Lives and Progress
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Lives
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                                (index) => AnimatedScale(
                              duration: const Duration(milliseconds: 300),
                              scale: index < lives ? 1.0 : 0.8,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: index < lives
                                      ? Colors.pink.shade400
                                      : Colors.grey.shade700,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Custom Progress Bar
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: level / maxLevels,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.deepPurple, Colors.purple],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Progress: Level $level/$maxLevels",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


          Positioned(
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
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),


          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                _cleanupTimers();
                Navigator.pop(context);
              },
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
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Spot {
  final String id;
  final Offset position;
  final Color color;
  final BoxShape shape;
  final double size;
  final List<Color> gradientColors;

  _Spot({
    required this.id,
    required this.position,
    required this.color,
    required this.shape,
    required this.size,
    this.gradientColors = const [Colors.blue, Colors.purple],
  });
}