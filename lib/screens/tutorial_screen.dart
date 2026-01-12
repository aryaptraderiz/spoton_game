import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<TutorialPage> _tutorialPages = [
    TutorialPage(
      title: "Welcome to SpotOn!",
      description: "A reflex-testing game where you tap colored spots before they disappear.",
      icon: Icons.gamepad_rounded,
      color: Colors.deepPurple,
      image: "🎮",
    ),
    TutorialPage(
      title: "How to Play",
      description: "Tap the colored spots that appear on screen. Each tap gives you points!",
      icon: Icons.touch_app_rounded,
      color: Colors.pink,
      image: "👆",
      steps: [
        "Spots appear randomly on screen",
        "Tap them before they vanish",
        "Score points for each successful tap",
      ],
    ),
    TutorialPage(
      title: "Game Rules",
      description: "Understand the game mechanics to improve your score.",
      icon: Icons.rule_rounded,
      color: Colors.blue,
      image: "📋",
      steps: [
        "You have 3 lives at the start",
        "Lose a life when you miss a spot",
        "Game ends when lives reach zero",
        "Level up every 30 seconds",
      ],
    ),
    TutorialPage(
      title: "Scoring System",
      description: "Earn more points with these strategies.",
      icon: Icons.emoji_events_rounded,
      color: Colors.amber,
      image: "🏆",
      steps: [
        "Each tap: +10 points × current level",
        "Higher levels = more points per tap",
        "Faster taps = better reaction time",
        "Save high scores to leaderboard",
      ],
    ),
    TutorialPage(
      title: "Level Progression",
      description: "The game gets more challenging as you progress.",
      icon: Icons.trending_up_rounded,
      color: Colors.green,
      image: "📈",
      steps: [
        "Start at Level 1 with slow spots",
        "Each level increases difficulty",
        "More spots appear simultaneously",
        "Spots disappear faster",
      ],
    ),
    TutorialPage(
      title: "Tips & Tricks",
      description: "Become a SpotOn master with these tips!",
      icon: Icons.lightbulb_rounded,
      color: Colors.orange,
      image: "💡",
      steps: [
        "Focus on the center of the screen",
        "Use peripheral vision to spot targets",
        "Stay calm under time pressure",
        "Practice improves reaction time",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.withOpacity(0.8),
                    Colors.purple.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Game Tutorial",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(width: 48),
                ],
              ),
            ),

            // Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _tutorialPages.length,
                      (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.deepPurple
                          : Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),


            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _tutorialPages.length,
                itemBuilder: (context, index) {
                  return _buildTutorialPage(_tutorialPages[index]);
                },
              ),
            ),


            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  if (_currentPage > 0)
                    ElevatedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Previous",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(width: 100),


                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _tutorialPages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      children: [
                        Text(
                          _currentPage < _tutorialPages.length - 1
                              ? "Next"
                              : "Let's Play!",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentPage < _tutorialPages.length - 1
                              ? Icons.arrow_forward
                              : Icons.play_arrow_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialPage(TutorialPage page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [

          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  page.color,
                  page.color.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                page.image,
                style: const TextStyle(fontSize: 60),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Title
          Text(
            page.title,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 15),

          // Description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              page.description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 20),


          if (page.steps != null && page.steps!.isNotEmpty) ...[
            Column(
              children: page.steps!.map((step) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: page.color.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: page.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          step,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],


          if (page.title == "How to Play") ...[
            const SizedBox(height: 30),
            _buildDemoSpot(context),
          ],

          if (page.title == "Level Progression") ...[
            const SizedBox(height: 30),
            _buildLevelProgression(),
          ],
        ],
      ),
    );
  }

  Widget _buildDemoSpot(BuildContext context) {
    return Column(
      children: [
        Text(
          "Try tapping this spot:",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Great! +100 points",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.pink, Colors.purple],
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: const Icon(
              Icons.circle_rounded,
              color: Colors.white,
              size: 60,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelProgression() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Level", style: TextStyle(color: Colors.white70)),
              Text("Spots", style: TextStyle(color: Colors.white70)),
              Text("Speed", style: TextStyle(color: Colors.white70)),
            ],
          ),
          const Divider(color: Colors.white24, height: 20),
          _buildLevelRow(level: 1, spots: 3, speed: "Slow", color: Colors.green),
          _buildLevelRow(level: 3, spots: 5, speed: "Medium", color: Colors.amber),
          _buildLevelRow(level: 6, spots: 7, speed: "Fast", color: Colors.orange),
          _buildLevelRow(level: 10, spots: 10, speed: "Extreme", color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildLevelRow({
    required int level,
    required int spots,
    required String speed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Lv. $level",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: List.generate(spots, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          Text(
            speed,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class TutorialPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String image;
  final List<String>? steps;

  TutorialPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.image,
    this.steps,
  });
}