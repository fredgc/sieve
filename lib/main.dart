import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/audio_engine.dart';
import 'models/beat_clock.dart';
import 'models/harmonic_palette.dart';
import 'models/sieve_engine.dart';
import 'widgets/about_dialog.dart';
import 'widgets/factor_inspector.dart';
import 'widgets/game_help_dialog.dart';
import 'widgets/number_grid.dart';
import 'widgets/proximity_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SieveApp());
}

class SieveApp extends StatelessWidget {
  const SieveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sieve of Eratosthenes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F071D),
        primaryColor: const Color(0xFF9D4EDD),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4C2FC),
          secondary: Color(0xFFFFD166),
          surface: Color(0xFF1E152A),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const SieveHomeScreen(),
    );
  }
}

class SieveHomeScreen extends StatefulWidget {
  const SieveHomeScreen({super.key});

  @override
  State<SieveHomeScreen> createState() => _SieveHomeScreenState();
}

class _SieveHomeScreenState extends State<SieveHomeScreen> with SingleTickerProviderStateMixin {
  late final SieveEngine _engine;
  late final BeatClock _clock;
  final ScrollController _gridScrollController = ScrollController();
  double _fractionalN = 0.0;
  SieveNumber? _currentSieveNumber;
  int? _flashNumber;

  // --- Game Reflex Challenge State ---
  int _score = 0;
  int? _pendingGuessNumber; // The number the user guessed is prime
  final Map<int, bool> _userGuesses = {}; // number -> true (correct) / false (wrong)
  String? _scoreFeedbackText;
  Color? _scoreFeedbackColor;

  @override
  void initState() {
    super.initState();
    _engine = SieveEngine();
    _currentSieveNumber = _engine.getPlayedNumber(0);
    _clock = BeatClock(
      engine: _engine,
      vsync: this,
      onBeat: _onBeatTriggered,
      onTick: (frac) {
        setState(() {
          _fractionalN = frac;
        });
      },
    );
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (!mounted) return false;
    // Do not intercept if a modal route (dialog or bottom sheet) is active
    if (ModalRoute.of(context)?.isCurrent != true) return false;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.keyP) {
      AudioEngine.instance.initOrResume();
      setState(() {
        _clock.toggle();
      });
      return true;
    } else if (key == LogicalKeyboardKey.space) {
      _onGuessPressed();
      return true;
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      setState(() {
        final newSpeed = (_clock.speedHz - 0.2).clamp(0.2, 5.0);
        _clock.speedHz = double.parse(newSpeed.toStringAsFixed(1));
      });
      return true;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      setState(() {
        final newSpeed = (_clock.speedHz + 0.2).clamp(0.2, 5.0);
        _clock.speedHz = double.parse(newSpeed.toStringAsFixed(1));
      });
      return true;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _scrollGridBy(-34.0);
      return true;
    } else if (key == LogicalKeyboardKey.arrowDown) {
      _scrollGridBy(34.0);
      return true;
    }
    return false;
  }

  void _scrollGridBy(double delta) {
    if (!_gridScrollController.hasClients) return;
    final maxExtent = _gridScrollController.position.maxScrollExtent;
    final current = _gridScrollController.position.pixels;
    final target = (current + delta).clamp(0.0, maxExtent);
    _gridScrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  void _onBeatTriggered(SieveNumber number) {
    AudioEngine.instance.playNumber(number);

    // Evaluate pending guess for this number as it arrives to play
    if (_pendingGuessNumber == number.number) {
      final isCorrect = number.isPrime;
      _userGuesses[number.number] = isCorrect;
      if (isCorrect) {
        _score += 1;
        _scoreFeedbackText = '+1';
        _scoreFeedbackColor = const Color(0xFF06D6A0);
      } else {
        _score = math.max(0, _score - 1);
        _scoreFeedbackText = '-1';
        _scoreFeedbackColor = const Color(0xFFEF476F);
      }
      _pendingGuessNumber = null;

      // Clear feedback after 900ms
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted && _scoreFeedbackText != null) {
          setState(() {
            _scoreFeedbackText = null;
            _scoreFeedbackColor = null;
          });
        }
      });
    }

    setState(() {
      _currentSieveNumber = number;
      _flashNumber = number.number;
    });

    // Clear flash highlight after 200ms
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && _flashNumber == number.number) {
        setState(() {
          _flashNumber = null;
        });
      }
    });
  }

  /// Toggles player's guess for the next number without making any sound.
  void _onGuessPressed() {
    final currentInt = _fractionalN.floor();
    final targetNextInt = currentInt + 1;

    setState(() {
      if (_pendingGuessNumber == targetNextInt) {
        _pendingGuessNumber = null;
      } else {
        _pendingGuessNumber = targetNextInt;
      }
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _gridScrollController.dispose();
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentInt = _fractionalN.floor();
    final activeNumber = _currentSieveNumber ?? _engine.getPlayedNumber(currentInt);
    final isFlashing = _flashNumber == currentInt;

    String heroTitle;
    if (currentInt == 0) {
      heroTitle = '0 - Ready...';
    } else if (currentInt == 1) {
      heroTitle = '1 - Go!';
    } else if (activeNumber?.isPrime == true) {
      heroTitle = '$currentInt - Prime!';
    } else if (activeNumber != null) {
      heroTitle = '$currentInt - ${activeNumber.factorizationDisplay}';
    } else {
      heroTitle = '$currentInt';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF160B29),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/icon.png', width: 30, height: 30),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Sieve of Eratosthenes',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.5,
                  color: Color(0xFFE0D0FF),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Tooltip(
            message: AudioEngine.instance.playHarmonics
                ? 'Turn off harmonics (prime powers like 4 and 8 will play a single note)'
                : 'Turn on harmonics (prime powers like 4 and 8 will play multiple octave notes)',
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                AudioEngine.instance.initOrResume();
                setState(() {
                  AudioEngine.instance.toggleHarmonics();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: AudioEngine.instance.playHarmonics,
                      activeColor: const Color(0xFF9D4EDD),
                      checkColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFD4C2FC), width: 1.5),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      onChanged: (val) {
                        AudioEngine.instance.initOrResume();
                        setState(() {
                          AudioEngine.instance.playHarmonics = val ?? true;
                        });
                      },
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      'Harmonics',
                      style: TextStyle(
                        color: Color(0xFFD4C2FC),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              AudioEngine.instance.isMuted ? Icons.volume_off : Icons.volume_up,
              color: const Color(0xFFD4C2FC),
            ),
            tooltip: AudioEngine.instance.isMuted ? 'Unmute Audio' : 'Mute Audio',
            onPressed: () {
              AudioEngine.instance.initOrResume();
              setState(() {
                AudioEngine.instance.toggleMute();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: Color(0xFFD4C2FC)),
            tooltip: 'About & Help',
            onPressed: () => showSieveAboutDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTall = constraints.maxHeight >= 500;

            final heroSpotlight = AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isFlashing
                        ? [
                            activeNumber?.isPrime == true
                                ? const Color(0xFF6A040F)
                                : const Color(0xFF380C59),
                            const Color(0xFF1E152A),
                          ]
                        : [
                            const Color(0xFF240046),
                            const Color(0xFF140824),
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: activeNumber?.isPrime == true
                        ? const Color(0xFFFFD166)
                        : (isFlashing ? const Color(0xFFD4C2FC) : const Color(0xFF380C59)),
                    width: isFlashing ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: activeNumber?.isPrime == true
                          ? const Color(0xFFFFD166).withValues(alpha: 0.3)
                          : const Color(0xFF9D4EDD).withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      heroTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: activeNumber?.isPrime == true
                            ? const Color(0xFFFFD166)
                            : (currentInt < 2 ? const Color(0xFFD4C2FC) : Colors.white),
                        shadows: [
                          Shadow(
                            color: activeNumber?.isPrime == true
                                ? const Color(0xFFFFD166).withValues(alpha: 0.8)
                                : Colors.black54,
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (currentInt == 0) ...[
                      const Text(
                        'Counting begins at 0. Press Play to start the Sieve of Eratosthenes.',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ] else if (currentInt == 1) ...[
                      const Text(
                        'Next number is 2: The very first prime!',
                        style: TextStyle(color: Color(0xFF06D6A0), fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ] else if (activeNumber != null && activeNumber.isPrime) ...[
                      Wrap(
                        spacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD166),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'PRIME NUMBER',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          Chip(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: HarmonicPalette.getColor(currentInt).withValues(alpha: 0.25),
                            side: BorderSide(color: HarmonicPalette.getColor(currentInt)),
                            avatar: CircleAvatar(
                              backgroundColor: HarmonicPalette.getColor(currentInt),
                              child: Text(
                                '$currentInt',
                                style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            label: Text(
                              'Note: ${HarmonicPalette.getNote(currentInt).noteName} (${HarmonicPalette.getNote(currentInt).frequency.toStringAsFixed(1)} Hz)',
                              style: TextStyle(
                                color: HarmonicPalette.getColor(currentInt),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else if (activeNumber != null && activeNumber.factors.isNotEmpty) ...[
                      // Show factor composition chips if there is room
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        alignment: WrapAlignment.center,
                        children: activeNumber.factors.map((f) {
                          final color = HarmonicPalette.getColor(f.prime);
                          final note = HarmonicPalette.getNote(f.prime);
                          return Chip(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: color.withValues(alpha: 0.2),
                            side: BorderSide(color: color),
                            avatar: CircleAvatar(
                              backgroundColor: color,
                              child: Text(
                                '${f.prime}',
                                style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            label: Text(
                              '${f.toSuperscript()} (${note.noteName})',
                              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              );

              final numberGridHeader = const Row(
                children: [
                  Icon(Icons.grid_view_rounded, color: Color(0xFFA08FC2), size: 14),
                  SizedBox(width: 6),
                  Text(
                    'NUMBER STREAM GRID',
                    style: TextStyle(
                      color: Color(0xFFA08FC2),
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              );

              final gridWidget = NumberGrid(
                engine: _engine,
                fractionalN: _fractionalN,
                userGuesses: _userGuesses,
                pendingGuessNumber: _pendingGuessNumber,
                scrollController: _gridScrollController,
                onNumberTapped: (n) {
                  AudioEngine.instance.initOrResume();
                  final numData = _engine.getPlayedNumber(n);
                  if (numData != null) {
                    AudioEngine.instance.playNumber(numData);
                  }
                  showFactorInspector(context, n, _engine);
                },
              );

              final targetNextInt = currentInt + 1;
              final isGuessedForNext = _pendingGuessNumber == targetNextInt;

              final controlsWidget = Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0E2E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF380C59)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton.filled(
                              onPressed: () {
                                AudioEngine.instance.initOrResume();
                                setState(() {
                                  _clock.reset();
                                  _currentSieveNumber = _engine.getPlayedNumber(0);
                                  _score = 0;
                                  _pendingGuessNumber = null;
                                  _userGuesses.clear();
                                  _scoreFeedbackText = null;
                                  _scoreFeedbackColor = null;
                                });
                              },
                              icon: const Icon(Icons.replay),
                              tooltip: 'Reset Sieve & Score',
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF380C59),
                                foregroundColor: Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton.filled(
                              iconSize: 34,
                              onPressed: () {
                                AudioEngine.instance.initOrResume();
                                setState(() {
                                  _clock.toggle();
                                });
                              },
                              icon: Icon(_clock.isPlaying ? Icons.pause : Icons.play_arrow),
                              tooltip: _clock.isPlaying ? 'Pause (P)' : 'Play (P)',
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF7B2CBF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(10),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton.filled(
                              onPressed: () {
                                AudioEngine.instance.initOrResume();
                                setState(() {
                                  _clock.stepForward();
                                });
                              },
                              icon: const Icon(Icons.skip_next),
                              tooltip: 'Step Forward',
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF380C59),
                                foregroundColor: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // "Guess" Button: tests reflexes on the next number without making noise
                            Tooltip(
                              message: isGuessedForNext
                                  ? 'Cancel Guess for #$targetNextInt (Space)'
                                  : 'Guess Next #$targetNextInt is Prime (Space)',
                              child: FilledButton.icon(
                                onPressed: _onGuessPressed,
                                icon: Icon(
                                  isGuessedForNext ? Icons.check_circle_outline : Icons.bolt,
                                  size: 17,
                                ),
                                label: Text(
                                  isGuessedForNext ? 'Guessed #$targetNextInt' : 'Guess Next (#$targetNextInt)',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: isGuessedForNext
                                      ? const Color(0xFF06D6A0)
                                      : const Color(0xFFFFD166),
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Score Display with feedback
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: _scoreFeedbackColor != null
                                    ? _scoreFeedbackColor!.withValues(alpha: 0.25)
                                    : const Color(0xFF240046),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _scoreFeedbackColor ?? const Color(0xFF7B2CBF),
                                  width: _scoreFeedbackColor != null ? 2.0 : 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.stars_rounded, size: 16, color: Color(0xFFFFD166)),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Score: $_score',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (_scoreFeedbackText != null) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      _scoreFeedbackText!,
                                      style: TextStyle(
                                        color: _scoreFeedbackColor,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Game Explanation & Rules Help Button
                            IconButton(
                              icon: const Icon(Icons.help_outline, color: Color(0xFFD4C2FC), size: 20),
                              tooltip: 'How to Play (Game Rules)',
                              onPressed: () => showGameRulesDialog(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.speed, size: 18, color: Color(0xFFD4C2FC)),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Adjust tempo: Left / Right arrow keys',
                          child: Text(
                            'Tempo: ${_clock.speedHz.toStringAsFixed(1)} Hz (${(_clock.speedHz * 60).toInt()} BPM)',
                            style: const TextStyle(fontSize: 12, color: Color(0xFFD4C2FC), fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _clock.speedHz,
                            min: 0.2,
                            max: 5.0,
                            divisions: 24,
                            activeColor: const Color(0xFF9D4EDD),
                            inactiveColor: const Color(0xFF380C59),
                            onChanged: (val) {
                              setState(() {
                                _clock.speedHz = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );

              final proximityWidget = _engine.discoveredPrimes.isNotEmpty
                  ? ProximityDashboard(
                      discoveredPrimes: _engine.discoveredPrimes,
                      fractionalN: _fractionalN,
                      onPrimeSelected: (p) {
                        AudioEngine.instance.initOrResume();
                        final numData = _engine.getPlayedNumber(p);
                        if (numData != null) {
                          AudioEngine.instance.playNumber(numData);
                        }
                        showFactorInspector(context, p, _engine);
                      },
                    )
                  : null;

              if (isTall) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      heroSpotlight,
                      const SizedBox(height: 8),
                      numberGridHeader,
                      const SizedBox(height: 4),
                      Expanded(child: gridWidget),
                      if (proximityWidget != null) ...[
                        const SizedBox(height: 8),
                        proximityWidget,
                      ],
                      const SizedBox(height: 8),
                      controlsWidget,
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      heroSpotlight,
                      const SizedBox(height: 8),
                      numberGridHeader,
                      const SizedBox(height: 4),
                      SizedBox(height: 260, child: gridWidget),
                      if (proximityWidget != null) ...[
                        const SizedBox(height: 8),
                        proximityWidget,
                      ],
                      const SizedBox(height: 8),
                      controlsWidget,
                    ],
                  ),
                );
              }
            },
          ),
        ),
      );
    }
  }
