import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sieve/main.dart';
import 'package:sieve/l10n/l10n_extension.dart';
import 'package:sieve/models/audio_engine.dart';
import 'package:sieve/models/multiplayer_engine.dart';
import 'package:sieve/models/theme_controller.dart';

void main() {
  testWidgets(
    'SieveApp smoke test starts at 0 - Ready... with harmonics off by default',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SieveApp());
      expect(find.text('Sieve of Eratosthenes'), findsOneWidget);
      expect(find.text('0 - Ready...'), findsOneWidget);
      expect(find.text('NUMBER STREAM GRID'), findsOneWidget);
      expect(find.text('Score: 0'), findsOneWidget);
      expect(find.text('Guess Next (#1)'), findsOneWidget);
      expect(AudioEngine.instance.playHarmonics, isFalse);
    },
  );

  testWidgets(
    'Next-number prime guessing evaluates correctly on step forward',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SieveApp());

      // Initially at 0, target is 1
      expect(find.text('Guess Next (#1)'), findsOneWidget);
      expect(find.text('Score: 0'), findsOneWidget);

      // Toggle guess for #1
      await tester.tap(find.text('Guess Next (#1)'));
      await tester.pump();
      expect(find.text('Guessed #1'), findsOneWidget);

      // Step forward to 1 (1 is not prime -> wrong guess: score drops to -1)
      await tester.tap(find.byTooltip('Step Forward'));
      await tester.pump();
      expect(find.text('Score: -1'), findsOneWidget);
      expect(find.text('-1'), findsOneWidget);

      // Target is now 2
      expect(find.text('Guess Next (#2)'), findsOneWidget);

      // Toggle guess for #2
      await tester.tap(find.text('Guess Next (#2)'));
      await tester.pump();
      expect(find.text('Guessed #2'), findsOneWidget);

      // Step forward to 2 (2 is prime -> correct guess: -1 + 1 = 0)
      await tester.tap(find.byTooltip('Step Forward'));
      await tester.pump();
      expect(find.text('Score: 0'), findsOneWidget);
      expect(find.text('+1'), findsOneWidget);

      // Let feedback timers finish
      await tester.pump(const Duration(seconds: 1));
    },
  );

  testWidgets('Keyboard shortcuts: P, Space, Left/Right arrow, Up/Down arrow', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SieveApp());

    // 1. P = play/pause
    expect(find.byTooltip('Play (P)'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyP);
    await tester.pump();
    expect(find.byTooltip('Pause (P)'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyP);
    await tester.pump();
    expect(find.byTooltip('Play (P)'), findsOneWidget);

    // 2. Space = guess next
    expect(find.text('Guess Next (#1)'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(find.text('Guessed #1'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(find.text('Guess Next (#1)'), findsOneWidget);

    // 3. Left / Right arrow = slows or increases tempo
    expect(find.textContaining('Tempo: 1.0 Hz'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(find.textContaining('Tempo: 1.2 Hz'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(find.textContaining('Tempo: 1.0 Hz'), findsOneWidget);

    // 4. Up / Down arrow = scrolls grid 1/2 box
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump(const Duration(milliseconds: 150));
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump(const Duration(milliseconds: 150));
  });

  testWidgets('Player stats dialog opens and displays records', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SieveApp());
    await tester.pumpAndSettle();

    // Tap the Leaderboard / Stats button
    final statsButton = find.byTooltip('Player Stats & Records');
    expect(statsButton, findsOneWidget);
    await tester.tap(statsButton);
    await tester.pumpAndSettle();

    expect(find.text('Player Stats & Records'), findsOneWidget);
    expect(find.text('HIGH SCORE'), findsOneWidget);
    expect(find.text('BEST STREAK'), findsOneWidget);
    expect(find.text('ALL-TIME ACCURACY'), findsOneWidget);

    // Close the dialog
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Player Stats & Records'), findsNothing);
  });

  testWidgets('Volume slider and mute button update audio volume', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SieveApp());
    await tester.pumpAndSettle();

    // Volume slider exists
    expect(find.byTooltip('Volume: 80%'), findsOneWidget);
    expect(AudioEngine.instance.isMuted, isFalse);

    // Tap mute button
    await tester.tap(find.byTooltip('Mute Audio'));
    await tester.pumpAndSettle();
    expect(AudioEngine.instance.isMuted, isTrue);
    expect(find.byTooltip('Volume: 0%'), findsOneWidget);

    // Tap unmute
    await tester.tap(find.byTooltip('Unmute Audio'));
    await tester.pumpAndSettle();
    expect(AudioEngine.instance.isMuted, isFalse);
    expect(find.byTooltip('Volume: 80%'), findsOneWidget);
  });

  testWidgets(
    'About dialog displays Privacy Policy button and opens Privacy Policy modal',
    (WidgetTester tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'sieve',
        packageName: 'com.example.sieve',
        version: '3.0.5',
        buildNumber: '1',
        buildSignature: '',
      );
      await tester.pumpWidget(const SieveApp());
      await tester.pumpAndSettle();

      // Open About dialog
      await tester.tap(find.byTooltip('About & Help'));
      await tester.pumpAndSettle();
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Harmonic Analogy'), findsOneWidget);
      expect(find.byType(SelectionArea), findsAtLeast(1));
      expect(find.textContaining('About Sieve of Eratosthenes (v'), findsNothing);

      // Tap Harmonic Analogy button (opens Audio-Visual Analogy dialog)
      final harmonicsButton = find.text('Harmonic Analogy');
      await tester.ensureVisible(harmonicsButton);
      await tester.pumpAndSettle();
      await tester.tap(harmonicsButton);
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('1. Primes as Atomic Tones'),
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('2. Composites as Harmonic Chords'),
        ),
        findsOneWidget,
      );

      // Close Analogy modal
      await tester.tap(find.text('Close').last);
      await tester.pumpAndSettle();

      // Tap Privacy Policy button
      final privacyButton = find.text('Privacy Policy');
      await tester.ensureVisible(privacyButton);
      await tester.pumpAndSettle();
      await tester.tap(privacyButton);
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('Zero-PII & Privacy by Design'),
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('Children & Classroom Safe'),
        ),
        findsOneWidget,
      );

      // Close Privacy Policy modal
      await tester.tap(find.text('Close').last);
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText &&
              w.text.toPlainText().contains('Zero-PII & Privacy by Design'),
        ),
        findsNothing,
      );
    },
  );

  testWidgets('How to Play dialog loads markdown rules and dismisses', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SieveApp());
    await tester.pumpAndSettle();

    // Open How to Play dialog
    await tester.tap(find.byTooltip('How to Play (Game Rules)'));
    await tester.pumpAndSettle();
    expect(find.text('How to Play'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('Objective'),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is RichText &&
            w.text.toPlainText().contains('How to Predict the Next Prime'),
      ),
      findsOneWidget,
    );

    // Dismiss with Got it! Let's Play button
    await tester.tap(find.text("Got it! Let's Play"));
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('Objective'),
      ),
      findsNothing,
    );
  });

  testWidgets(
    'Multiplayer dialog opens and allows switching between Join and Host tabs',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SieveApp());
      await tester.pumpAndSettle();

      // Open Multiplayer dialog
      await tester.tap(find.byTooltip('Multiplayer Match'));
      await tester.pumpAndSettle();
      expect(find.text('Multiplayer Challenge'), findsOneWidget);
      expect(find.text('Join Room'), findsOneWidget);
      expect(find.text('Host Room'), findsOneWidget);

      // Switch to Host tab
      await tester.tap(find.text('Host Room'));
      await tester.pumpAndSettle();
      expect(find.text('Create New Room'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Multiplayer Challenge'), findsNothing);
    },
  );

  testWidgets(
    'Guest in multiplayer room sees Leave Room button and disabled transport controls',
    (WidgetTester tester) async {
      await tester.pumpWidget(const SieveApp());
      await tester.pumpAndSettle();

      // Verify solo transport controls exist
      expect(find.byIcon(Icons.replay), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.skip_next), findsOneWidget);
      expect(find.text('Leave Room'), findsNothing);

      // Simulate joining room as guest with waiting status
      MultiplayerEngine.instance.setTestState(
        roomCode: '7K3W',
        playerId: 'guest_1',
        isHost: false,
        roomState: const RoomState(
          code: '7K3W',
          status: 'waiting',
          hostId: 'host_1',
          tempoHz: 1.0,
          startServerTime: 0,
          createdAt: 0,
          lastActivity: 0,
          players: {},
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Now transport buttons are replaced with Leave Room button & host controls badge
      expect(find.text('Leave Room'), findsAtLeast(1));
      expect(find.text('Host Controls (Room 7K3W)'), findsOneWidget);
      expect(find.byIcon(Icons.replay), findsNothing);
      expect(find.byIcon(Icons.skip_next), findsNothing);
      expect(find.text('7K3W'), findsOneWidget); // Leaderboard room code header

      // Clean up / quit game and leave room back to solo mode
      MultiplayerEngine.instance.setTestState(
        roomCode: null,
        playerId: null,
        isHost: false,
        roomState: null,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byIcon(Icons.replay), findsOneWidget);
      // Leaderboard should no longer be displayed
      expect(find.text('7K3W'), findsNothing);
      expect(find.text('Leave Room'), findsNothing);
    },
  );

  testWidgets('SieveApp renders in Spanish locale', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SieveHomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Criba de Eratóstenes'), findsOneWidget);
    expect(find.text('0 - Listo...'), findsOneWidget);
    expect(find.text('CUADRÍCULA DE NÚMEROS'), findsOneWidget);
    expect(find.text('Puntos: 0'), findsOneWidget);
    expect(find.text('Adivinar Siguiente (#1)'), findsOneWidget);
    expect(find.text('Armónicos'), findsOneWidget);
  });

  testWidgets('Language dropdown menu toggles application locale', (
    WidgetTester tester,
  ) async {
    LocaleController.currentLocale.value = null;

    await tester.pumpWidget(const SieveApp());
    await tester.pumpAndSettle();

    // Initially in English
    expect(find.text('NUMBER STREAM GRID'), findsOneWidget);

    // Tap language switcher button
    final languageButton = find.byTooltip('Switch Language');
    expect(languageButton, findsOneWidget);
    await tester.tap(languageButton);
    await tester.pumpAndSettle();

    // Dropdown contains options
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Español'), findsOneWidget);

    // Select Español
    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();

    // Now app is in Spanish
    expect(find.text('CUADRÍCULA DE NÚMEROS'), findsOneWidget);
    expect(find.text('NUMBER STREAM GRID'), findsNothing);

    // Clean up
    LocaleController.currentLocale.value = null;
  });

  testWidgets(
    'About dialog loads Spanish documentation when locale is Spanish',
    (WidgetTester tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'sieve',
        packageName: 'com.example.sieve',
        version: '3.0.5',
        buildNumber: '1',
        buildSignature: '',
      );
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SieveHomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Open About dialog
      await tester.tap(find.byTooltip('Acerca de y Ayuda'));
      await tester.pumpAndSettle();

      // Tap Privacy Policy button
      final privacyButton = find.text('Política de Privacidad');
      await tester.ensureVisible(privacyButton);
      await tester.pumpAndSettle();
      await tester.tap(privacyButton);
      await tester.pumpAndSettle();

      // Verify Spanish Privacy text is loaded
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Zero-PII'),
        ),
        findsAtLeast(1),
      );
    },
  );

  test('All supported locales have valid translations in sieve', () {
    for (final locale in LocaleController.supportedLocales) {
      final l10n = lookupAppLocalizations(locale);
      expect(l10n.appTitle.isNotEmpty, isTrue);
      expect(l10n.switchLanguageTooltip.isNotEmpty, isTrue);
      expect(l10n.primeNumberBadge.isNotEmpty, isTrue);
    }
  });

  test('All localized ARB files maintain key parity with app_en.arb', () {
    final enContent = File('lib/l10n/app_en.arb').readAsStringSync();
    final enJson = jsonDecode(enContent) as Map<String, dynamic>;
    final enKeys = enJson.keys.where((k) => !k.startsWith('@')).toSet();

    final targetArbFiles = [
      'app_de.arb',
      'app_es.arb',
      'app_fr.arb',
      'app_ja.arb',
      'app_lt.arb',
      'app_pt.arb',
      'app_zh.arb',
    ];

    for (final file in targetArbFiles) {
      final content = File('lib/l10n/$file').readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      for (final key in enKeys) {
        expect(
          json.containsKey(key),
          isTrue,
          reason: 'ARB file $file is missing key "$key"',
        );
      }
    }
  });

  testWidgets(
    'Theme toggle button switches between dark and light modes',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      await ThemeController.initialize();
      expect(ThemeController.themeMode.value, ThemeMode.dark);

      await tester.pumpWidget(const SieveApp());
      await tester.pumpAndSettle();

      final themeButton = find.byWidgetPredicate(
        (w) =>
            w is IconButton &&
            (w.tooltip == 'Switch to Light Mode' ||
                w.tooltip == 'Switch to Dark Mode'),
      );
      expect(themeButton, findsOneWidget);

      await tester.tap(themeButton);
      await tester.pumpAndSettle();

      expect(ThemeController.themeMode.value, ThemeMode.light);

      await tester.tap(themeButton);
      await tester.pumpAndSettle();

      expect(ThemeController.themeMode.value, ThemeMode.dark);
    },
  );
}
