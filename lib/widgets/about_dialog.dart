import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/'
    'flutter_widget_from_html_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n_extension.dart';

/// Shows the About & Help dialog for the Sieve of Eratosthenes app.
void showSieveAboutDialog(BuildContext context) async {
  String version = '3.0.5+1';
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

/// Helper to open external links safely or route internal docs to modals.
Future<void> _handleLinkTap(BuildContext context, String? href) async {
  if (href == null || href.isEmpty) return;
  if (href.contains('analogy')) {
    showAnalogyDialog(context);
    return;
  }
  if (href.contains('privacy')) {
    showPrivacyPolicyDialog(context);
    return;
  }
  if (href.contains('terms')) {
    showTermsOfServiceDialog(context);
    return;
  }
  final uri = Uri.tryParse(href);
  if (uri != null && await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/// Helper to open external links safely.
Future<void> _launchExternalUrl(String? url) async {
  if (url == null || url.isEmpty) return;
  final uri = Uri.tryParse(url);
  if (uri != null && await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class SieveAboutDialog extends StatelessWidget {
  final String version;

  const SieveAboutDialog({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = (screenSize.width * 0.85).clamp(320.0, 620.0);
    final dialogHeight = (screenSize.height * 0.70).clamp(280.0, 520.0);

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E152A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
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
          Image.asset('assets/icons/icon.png', width: 36, height: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.appTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFE0D0FF)
                        : const Color(0xFF2E1065),
                  ),
                ),
                Text(
                  context.l10n.aboutDialogVersion(version),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? const Color(0xFFA08FC2)
                        : const Color(0xFF5A4974),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: FutureBuilder<String>(
          future: loadLocalizedHtmlAsset(context, 'about'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF9D4EDD)),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(
                child: Text(
                  'Unable to load about documentation.',
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
                    await _handleLinkTap(context, url);
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
        ElevatedButton.icon(
          onPressed: () => showAnalogyDialog(context),
          icon: const Icon(Icons.graphic_eq_rounded, size: 16),
          label: Text(context.l10n.aboutDialogHarmonicAnalogy),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark
                ? const Color(0xFF240046)
                : const Color(0xFFF3EDFC),
            foregroundColor: const Color(0xFF0284C7),
            side: const BorderSide(color: Color(0xFF0284C7)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => showPrivacyPolicyDialog(context),
          icon: const Icon(Icons.privacy_tip_outlined, size: 16),
          label: Text(context.l10n.aboutDialogPrivacyPolicy),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark
                ? const Color(0xFF240046)
                : const Color(0xFFFEF3C7),
            foregroundColor: isDark
                ? const Color(0xFFFFD166)
                : const Color(0xFFB45309),
            side: BorderSide(
              color: isDark ? const Color(0xFFFFD166) : const Color(0xFFD97706),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => showTermsOfServiceDialog(context),
          icon: const Icon(Icons.gavel_outlined, size: 16),
          label: Text(context.l10n.aboutDialogTermsOfService),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark
                ? const Color(0xFF240046)
                : const Color(0xFFF3EDFC),
            foregroundColor: const Color(0xFF0284C7),
            side: const BorderSide(color: Color(0xFF0284C7)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            context.l10n.aboutDialogClose,
            style: TextStyle(
              color: isDark ? const Color(0xFFD4C2FC) : const Color(0xFF6B21A8),
            ),
          ),
        ),
      ],
    );
  }
}

/// Modal dialog displaying the Audio-Visual Analogy documentation.
void showAnalogyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final screenSize = MediaQuery.of(context).size;
      final dialogWidth = (screenSize.width * 0.85).clamp(320.0, 620.0);
      final dialogHeight = (screenSize.height * 0.70).clamp(280.0, 520.0);

      return AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E152A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
            const Icon(
              Icons.graphic_eq_rounded,
              color: Color(0xFF00B4D8),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              context.l10n.analogyDialogTitle,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFE0D0FF)
                    : const Color(0xFF2E1065),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: FutureBuilder<String>(
            future: loadLocalizedHtmlAsset(context, 'analogy'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF9D4EDD)),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Text(
                    'Unable to load analogy documentation.',
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.l10n.aboutDialogClose,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFD4C2FC)
                    : const Color(0xFF6B21A8),
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// Modal dialog displaying the App's Zero-PII, COPPA-compliant Privacy Policy.
void showPrivacyPolicyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final screenSize = MediaQuery.of(context).size;
      final dialogWidth = (screenSize.width * 0.85).clamp(320.0, 620.0);
      final dialogHeight = (screenSize.height * 0.70).clamp(280.0, 520.0);

      return AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E152A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
            const Icon(
              Icons.privacy_tip_rounded,
              color: Color(0xFFFFD166),
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              context.l10n.privacyPolicyDialogTitle,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFE0D0FF)
                    : const Color(0xFF2E1065),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: FutureBuilder<String>(
            future: loadLocalizedHtmlAsset(context, 'privacy'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF9D4EDD)),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Text(
                    'Unable to load privacy policy.',
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.l10n.aboutDialogClose,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFD4C2FC)
                    : const Color(0xFF6B21A8),
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// Modal dialog displaying the Terms of Service.
void showTermsOfServiceDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final screenSize = MediaQuery.of(context).size;
      final dialogWidth = (screenSize.width * 0.85).clamp(320.0, 620.0);
      final dialogHeight = (screenSize.height * 0.70).clamp(280.0, 520.0);

      return AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E152A) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
            const Icon(Icons.gavel_rounded, color: Color(0xFF00B4D8), size: 24),
            const SizedBox(width: 10),
            Text(
              context.l10n.termsOfServiceDialogTitle,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFE0D0FF)
                    : const Color(0xFF2E1065),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: FutureBuilder<String>(
            future: loadLocalizedHtmlAsset(context, 'terms'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF9D4EDD)),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Text(
                    'Unable to load terms of service.',
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.l10n.aboutDialogClose,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFD4C2FC)
                    : const Color(0xFF6B21A8),
              ),
            ),
          ),
        ],
      );
    },
  );
}
