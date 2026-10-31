import 'package:flutter/material.dart';

/// Shows an explanatory dialog describing how to play the Prime Reflex Challenge.
void showGameRulesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1E152A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF531183), width: 1.5),
        ),
        title: const Row(
          children: [
            Icon(Icons.sports_esports_rounded, color: Color(0xFFFFD166), size: 26),
            SizedBox(width: 10),
            Text(
              'How to Play',
              style: TextStyle(
                color: Color(0xFFE0D0FF),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRuleSection(
                  icon: Icons.flag_rounded,
                  iconColor: const Color(0xFF00B4D8),
                  title: 'Objective',
                  description:
                      'Predict primes before they arrive! Press the GUESS button to guess that the NEXT number in sequence will be a PRIME number before it plays.',
                ),
                const SizedBox(height: 14),
                _buildRuleSection(
                  icon: Icons.lightbulb_outline,
                  iconColor: const Color(0xFFFFD166),
                  title: 'How to Predict the Next Prime',
                  description:
                      '• Proximity Waves: Look at the wave dashboard. If any wave is approaching 100%, the next number is a multiple of that prime (composite). If all waves stay well below 100%, the next number is prime!\n'
                      '• Silence vs. Chords: Primes are silent when discovered; composites play chord harmonies of their factors.\n'
                      '• Know Your Primes: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47...',
                ),
                const SizedBox(height: 14),
                _buildRuleSection(
                  icon: Icons.stars_rounded,
                  iconColor: const Color(0xFF06D6A0),
                  title: 'Scoring & Guess Tracking',
                  description:
                      '• 1 point is awarded for each correct prime guess.\n'
                      '• Incorrect guesses deduct 1 point.\n'
                      '• Green Border: Appears around boxes where your guess was correct!\n'
                      '• Red Border: Appears around boxes where your guess was incorrect.',
                ),
                const SizedBox(height: 14),
                _buildRuleSection(
                  icon: Icons.keyboard_rounded,
                  iconColor: const Color(0xFFD4C2FC),
                  title: 'Keyboard Shortcuts',
                  description:
                      '• P: Play / Pause\n'
                      '• Left / Right Arrow: Slow down / Speed up tempo\n'
                      '• Up / Down Arrow: Scroll number grid 1/2 box\n'
                      '• Space: Guess next number (#N+1)',
                ),
                const SizedBox(height: 14),
                _buildRuleSection(
                  icon: Icons.speed,
                  iconColor: const Color(0xFF9D4EDD),
                  title: 'Pro Tips',
                  description:
                      '• Use the "Step Forward" button to practice predicting each number one step at a time.\n'
                      '• Controls are anchored at the bottom of the screen so they remain steady as new primes are discovered.',
                ),
              ],
            ),
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF7B2CBF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Got it! Let\'s Play', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}

Widget _buildRuleSection({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String description,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
