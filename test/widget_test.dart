import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sieve/main.dart';
import 'package:sieve/models/audio_engine.dart';

void main() {
  testWidgets('SieveApp smoke test starts at 0 - Ready... with harmonics off by default', (WidgetTester tester) async {
    await tester.pumpWidget(const SieveApp());
    expect(find.text('Sieve of Eratosthenes'), findsOneWidget);
    expect(find.text('0 - Ready...'), findsOneWidget);
    expect(find.text('NUMBER STREAM GRID'), findsOneWidget);
    expect(find.text('Score: 0'), findsOneWidget);
    expect(find.text('Guess Next (#1)'), findsOneWidget);
    expect(AudioEngine.instance.playHarmonics, isFalse);
  });

  testWidgets('Next-number prime guessing evaluates correctly on step forward', (WidgetTester tester) async {
    await tester.pumpWidget(const SieveApp());

    // Initially at 0, target is 1
    expect(find.text('Guess Next (#1)'), findsOneWidget);
    expect(find.text('Score: 0'), findsOneWidget);

    // Toggle guess for #1
    await tester.tap(find.text('Guess Next (#1)'));
    await tester.pump();
    expect(find.text('Guessed #1'), findsOneWidget);

    // Step forward to 1 (1 is not prime -> wrong guess)
    await tester.tap(find.byTooltip('Step Forward'));
    await tester.pump();
    expect(find.text('Score: 0'), findsOneWidget);
    expect(find.text('-1'), findsOneWidget);

    // Target is now 2
    expect(find.text('Guess Next (#2)'), findsOneWidget);

    // Toggle guess for #2
    await tester.tap(find.text('Guess Next (#2)'));
    await tester.pump();
    expect(find.text('Guessed #2'), findsOneWidget);

    // Step forward to 2 (2 is prime -> correct guess)
    await tester.tap(find.byTooltip('Step Forward'));
    await tester.pump();
    expect(find.text('Score: 1'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);

    // Let feedback timers finish
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('Keyboard shortcuts: P, Space, Left/Right arrow, Up/Down arrow', (WidgetTester tester) async {
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
}
