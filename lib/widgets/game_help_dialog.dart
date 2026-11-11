import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/'
    'flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n_extension.dart';

/// Shows an explanatory dialog describing how to play
/// the Prime Reflex Challenge.
void showGameRulesDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => const GameRulesDialog());
}

/// Helper to open external links safely.
Future<void> _launchExternalUrl(String? url) async {
  if (url == null || url.isEmpty) return;
  final uri = Uri.tryParse(url);
  if (uri != null && await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class GameRulesDialog extends StatelessWidget {
  const GameRulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = (screenSize.width * 0.85).clamp(320.0, 620.0);
    final dialogHeight = (screenSize.height * 0.70).clamp(280.0, 520.0);

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E152A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? const Color(0xFF531183) : const Color(0xFFC7B7E5),
          width: 1.5,
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      title: Row(
        children: [
          Icon(
            Icons.sports_esports_rounded,
            color: isDark ? const Color(0xFFFFD166) : const Color(0xFFD97706),
            size: 26,
          ),
          const SizedBox(width: 10),
          Text(
            context.l10n.gameHelpTitle,
            style: TextStyle(
              color: isDark ? const Color(0xFFE0D0FF) : const Color(0xFF2E1065),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: FutureBuilder<String>(
          future: loadLocalizedHtmlAsset(context, 'how_to_play'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF9D4EDD)),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Text(
                  context.l10n.gameHelpError,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF5A4974),
                  ),
                ),
              );
            }

            return SelectionArea(
              child: SingleChildScrollView(
                child: HtmlWidget(
                  snapshot.data!,
                  textStyle: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF2A1E3D),
                    fontSize: 13,
                    height: 1.45,
                  ),
                  onTapUrl: (url) async {
                    await _launchExternalUrl(url);
                    return true;
                  },
                  customWidgetBuilder: (element) {
                    if (element.id == 'title-block-header' ||
                        (element.localName == 'h1' &&
                            element.classes.contains('title'))) {
                      return const SizedBox.shrink();
                    }
                    return null;
                  },
                  customStylesBuilder: (element) {
                    if (element.localName == 'a') {
                      return {
                        'color': isDark ? '#00B4D8' : '#0284C7',
                        'text-decoration': 'underline',
                      };
                    }
                    if (element.localName == 'h1') {
                      return {
                        'color': isDark ? '#E0D0FF' : '#2E1065',
                        'font-size': '16px',
                        'font-weight': 'bold',
                      };
                    }
                    if (element.localName == 'h2') {
                      return {
                        'color': isDark ? '#D4C2FC' : '#5B21B6',
                        'font-size': '14.5px',
                        'font-weight': 'bold',
                      };
                    }
                    return null;
                  },
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          style: FilledButton.styleFrom(
            backgroundColor: isDark
                ? const Color(0xFF7B2CBF)
                : const Color(0xFF6B21A8),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            context.l10n.gameHelpClose,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
