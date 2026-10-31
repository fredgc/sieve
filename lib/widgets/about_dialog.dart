import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows the About & Help dialog for the Sieve of Eratosthenes app.
void showSieveAboutDialog(BuildContext context) async {
  String version = '3.0.0+4';
  try {
    final info = await PackageInfo.fromPlatform();
    version = '${info.version}+${info.buildNumber}';
  } catch (_) {}

  if (!context.mounted) return;

  showDialog(
    context: context,
    builder: (context) => SieveAboutDialog(version: version),
  );
}

class SieveAboutDialog extends StatelessWidget {
  final String version;

  const SieveAboutDialog({super.key, required this.version});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: const Color(0xFF1E152A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF531183), width: 1.5),
      ),
      title: Row(
        children: [
          Image.asset('assets/icons/icon.png', width: 36, height: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sieve of Eratosthenes',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE0D0FF),
                  ),
                ),
                Text(
                  'v$version',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFA08FC2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'An interactive rhythm game and audio-visual mathematical demonstration of prime number discovery.',
              style: TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 16),
            const Text(
              'How It Works',
              style: TextStyle(
                color: Color(0xFFD4C2FC),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '• Every prime number generates its own atomic tone and color.\n'
              '• Composite numbers sound all their prime factors simultaneously as a musical chord.\n'
              '• Prime powers (like 4 = 2², 8 = 2³) trigger higher octave harmonics.\n'
              '• Bottom proximity bars measure how close the beat is to each prime multiple.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF380C59)),
            const SizedBox(height: 10),
            const Text(
              'About & More Apps',
              style: TextStyle(
                color: Color(0xFFD4C2FC),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Visit www.gchouse.org to explore other interactive math, physics, and science apps created by Fred Gylys-Colwell (including CAT Scan, Polytope, Spacetime, and Daylight).',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            const Text(
              'Source Code & Bugs',
              style: TextStyle(
                color: Color(0xFFD4C2FC),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Source code and issue tracking are hosted on GitHub at fredgc/sieve.',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _launchUrl('https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes'),
                  icon: const Icon(Icons.school, size: 16),
                  label: const Text('Wikipedia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF380C59),
                    foregroundColor: const Color(0xFFD4C2FC),
                    side: const BorderSide(color: Color(0xFF9D4EDD)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _launchUrl('https://github.com/fredgc/sieve'),
                  icon: const Icon(Icons.code, size: 16),
                  label: const Text('GitHub (fredgc/sieve)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF240046),
                    foregroundColor: const Color(0xFFE0D0FF),
                    side: const BorderSide(color: Color(0xFF7B2CBF)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _launchUrl('http://www.gchouse.org'),
                  icon: const Icon(Icons.public, size: 16),
                  label: const Text('www.gchouse.org'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1035),
                    foregroundColor: const Color(0xFF06D6A0),
                    side: const BorderSide(color: Color(0xFF06D6A0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close', style: TextStyle(color: Color(0xFFD4C2FC))),
        ),
      ],
    );
  }
}
