import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'web_cache.dart';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/audio_engine.dart';
import 'models/beat_clock.dart';
import 'models/game_stats.dart';
import 'models/harmonic_palette.dart';
import 'models/multiplayer_engine.dart';
import 'models/sieve_engine.dart';
import 'l10n/l10n_extension.dart';
import 'widgets/about_dialog.dart';
import 'models/theme_controller.dart';
import 'widgets/factor_inspector.dart';
import 'widgets/game_help_dialog.dart';
import 'widgets/multiplayer_dialog.dart';
import 'widgets/multiplayer_scoreboard.dart';
import 'widgets/number_grid.dart';
import 'widgets/proximity_dashboard.dart';
import 'widgets/stats_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    unawaited(() async {
      try {
        final info = await PackageInfo.fromPlatform();
        final ver = info.buildNumber.isNotEmpty
            ? '${info.version}+${info.buildNumber}'
            : info.version;
        await checkServerVersionAndReload(ver);
      } catch (_) {}
    }());
  }
  await LocaleController.initialize();
  await ThemeController.initialize();
  runApp(const SieveApp());
}

class SieveApp extends StatelessWidget {
  const SieveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocaleController.currentLocale,
      builder: (context, locale, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeController.themeMode,
          builder: (context, themeMode, _) {
            return MaterialApp(
              locale: locale,
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                if (deviceLocale != null) {
                  for (final supported in supportedLocales) {
                    if (supported.languageCode == deviceLocale.languageCode) {
                      return supported;
                    }
                  }
                }
                return const Locale('en');
              },
              onGenerateTitle: (context) => context.l10n.appTitle,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              themeMode: themeMode,
              theme: ThemeData(
                brightness: Brightness.light,
                scaffoldBackgroundColor: const Color(0xFFF7F5FA),
                primaryColor: const Color(0xFF7B2CBF),
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF7B2CBF),
                  secondary: Color(0xFFD97706),
                  surface: Colors.white,
                ),
                textTheme: GoogleFonts.interTextTheme(
                  ThemeData.light().textTheme,
                ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF0F071D),
                primaryColor: const Color(0xFF9D4EDD),
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFD4C2FC),
                  secondary: Color(0xFFFFD166),
                  surface: Color(0xFF1E152A),
                ),
                textTheme: GoogleFonts.interTextTheme(
                  ThemeData.dark().textTheme,
                ),
              ),
              home: const SieveHomeScreen(),
            );
          },
        );
      },
    );
  }
}

class SieveHomeScreen extends StatefulWidget {
  const SieveHomeScreen({super.key});

  @override
  State<SieveHomeScreen> createState() => _SieveHomeScreenState();
}

class _SieveHomeScreenState extends State<SieveHomeScreen>
    with SingleTickerProviderStateMixin {
  late final SieveEngine _engine;
  late final BeatClock _clock;
  final ScrollController _gridScrollController = ScrollController();
  double _fractionalN = 0.0;
  SieveNumber? _currentSieveNumber;
  int? _flashNumber;

  // --- Game Reflex Challenge State ---
  late GameStats _stats;
  int _score = 0;
  int? _pendingGuessNumber; // The number the user guessed is prime
  final Map<int, bool> _userGuesses =
      {}; // number -> true (correct) / false (wrong)
  String? _scoreFeedbackText;
  Color? _scoreFeedbackColor;

  @override
  void initState() {
    super.initState();
    _engine = SieveEngine();
    _currentSieveNumber = _engine.getPlayedNumber(0);
    _stats = GameStats();
    GameStats.load().then((loaded) {
      if (mounted) {
        setState(() {
          _stats = loaded;
        });
      }
    });
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
    _subscribeToMultiplayerRoom();

    // Initialize multiplayer & check for URL ?room=CODE parameter
    MultiplayerEngine.instance
        .initialize()
        .then((_) {
          if (mounted) {
            _checkUrlRoomCode();
          }
        })
        .catchError((_) {});
  }

  StreamSubscription<RoomState?>? _multiplayerSub;

  void _checkUrlRoomCode() {
    final roomParam = Uri.base.queryParameters['room'];
    if (roomParam != null && roomParam.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showMultiplayerDialog(
            context,
            initialRoomCode: roomParam.trim().toUpperCase(),
          );
        }
      });
    }
  }

  void _subscribeToMultiplayerRoom() {
    _multiplayerSub?.cancel();
    _multiplayerSub = MultiplayerEngine.instance.roomStream.listen((room) {
      if (!mounted) return;
      if (room != null) {
        // Synchronize tempo from host
        if ((_clock.speedHz - room.tempoHz).abs() > 0.01) {
          setState(() {
            _clock.speedHz = room.tempoHz;
          });
        }

        if (room.isPlaying) {
          final now = MultiplayerEngine.instance.synchronizedServerTimeMs;
          final expectedFracN = room.computeExpectedFracN(now);
          if (!_clock.isPlaying) {
            AudioEngine.instance.initOrResume();
            setState(() {
              _clock.speedHz = room.tempoHz;
              if (now >= room.startServerTime) {
                _clock.syncTo(expectedFracN);
              }
              _clock.start();
            });
          } else {
            // Check drift (> 1.5 beats) for guest
            if (!MultiplayerEngine.instance.isHost &&
                (_clock.currentFractionalN - expectedFracN).abs() > 1.5) {
              _clock.syncTo(expectedFracN);
            }
          }
        } else if (room.isPaused) {
          if (_clock.isPlaying) {
            setState(() {
              _clock.pause();
              if (room.pausedAtFracN != null) {
                _clock.syncTo(room.pausedAtFracN!);
              }
            });
          }
        } else if (room.isWaiting) {
          if (_clock.isPlaying || _engine.currentNumber > 0) {
            _clock.reset();
            _currentSieveNumber = _engine.getPlayedNumber(0);
            _score = 0;
            _pendingGuessNumber = null;
            _userGuesses.clear();
            _scoreFeedbackText = null;
            _scoreFeedbackColor = null;
            _stats.resetSession();
          }
        }
        setState(() {});
      } else {
        setState(() {});
      }
    });
  }

  void _togglePlayPause() {
    if (MultiplayerEngine.instance.isInRoom) {
      if (!MultiplayerEngine.instance.isHost) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.playbackControlledByHost),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
      AudioEngine.instance.initOrResume();
      if (_clock.isPlaying) {
        MultiplayerEngine.instance.pauseMatch(
          currentFracN: _clock.currentFractionalN,
        );
        setState(() {
          _clock.pause();
        });
      } else {
        MultiplayerEngine.instance.resumeMatch(
          resumeFromFracN: _clock.currentFractionalN,
          tempoHz: _clock.speedHz,
        );
        setState(() {
          _clock.start();
        });
      }
      return;
    }

    AudioEngine.instance.initOrResume();
    setState(() {
      _clock.toggle();
    });
  }

  void _resetSieve() {
    if (MultiplayerEngine.instance.isInRoom) {
      if (!MultiplayerEngine.instance.isHost) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.soloOnlyHostReset),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
      MultiplayerEngine.instance.resetMatch();
    }

    AudioEngine.instance.initOrResume();
    setState(() {
      _clock.reset();
      _currentSieveNumber = _engine.getPlayedNumber(0);
      _score = 0;
      _pendingGuessNumber = null;
      if (MultiplayerEngine.instance.isInRoom) {
        MultiplayerEngine.instance.updateScore(
          score: _score,
          streak: _stats.currentStreak,
        );
      }
      _userGuesses.clear();
      _scoreFeedbackText = null;
      _scoreFeedbackColor = null;
      _stats.resetSession();
    });
  }

  void _stepForward() {
    if (MultiplayerEngine.instance.isInRoom &&
        !MultiplayerEngine.instance.isHost) {
      return;
    }
    AudioEngine.instance.initOrResume();
    setState(() {
      _clock.stepForward();
    });
  }

  void _updateTempo(double newSpeed) {
    if (MultiplayerEngine.instance.isInRoom &&
        !MultiplayerEngine.instance.isHost) {
      return;
    }
    final speed = double.parse(newSpeed.clamp(0.2, 5.0).toStringAsFixed(1));
    setState(() {
      _clock.speedHz = speed;
    });
    if (MultiplayerEngine.instance.isInRoom &&
        MultiplayerEngine.instance.isHost) {
      MultiplayerEngine.instance.updateTempo(
        speed,
        currentFracN: _clock.currentFractionalN,
      );
    }
  }

  Future<void> _leaveMultiplayerRoom() async {
    final wasHost = MultiplayerEngine.instance.isHost;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? const Color(0xFF1E1035) : Colors.white,
        title: Text(
          wasHost
              ? l10n.leaveMultiplayerTitleHost
              : l10n.leaveMultiplayerTitleGuest,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E152A),
          ),
        ),
        content: Text(
          wasHost
              ? l10n.leaveMultiplayerContentHost
              : l10n.leaveMultiplayerContentGuest,
          style: TextStyle(
            color: isDark ? const Color(0xFFD4C2FC) : const Color(0xFF4B5563),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: isDark ? Colors.white70 : const Color(0xFF6B7280),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE63946),
              foregroundColor: Colors.white,
            ),
            child: Text(wasHost ? l10n.endMatch : l10n.leaveRoom),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      if (_clock.isPlaying) {
        _clock.pause();
      }
      await MultiplayerEngine.instance.leaveRoom();
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              wasHost
                  ? l10n.roomDismantledHostSnackbar
                  : l10n.roomLeftGuestSnackbar,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (!mounted) return false;
    // Do not intercept if a modal route (dialog or bottom sheet) is active
    if (ModalRoute.of(context)?.isCurrent != true) return false;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.keyP) {
      _togglePlayPause();
      return true;
    } else if (key == LogicalKeyboardKey.space) {
      _onGuessPressed();
      return true;
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      if (!MultiplayerEngine.instance.isInRoom ||
          MultiplayerEngine.instance.isHost) {
        _updateTempo(_clock.speedHz - 0.2);
      }
      return true;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      if (!MultiplayerEngine.instance.isInRoom ||
          MultiplayerEngine.instance.isHost) {
        _updateTempo(_clock.speedHz + 0.2);
      }
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
      _stats.recordGuess(isCorrect: isCorrect);
      if (isCorrect) {
        _score += 1;
        _scoreFeedbackText = '+1';
        _scoreFeedbackColor = const Color(0xFF06D6A0);
        _stats.checkHighScore(_score);
      } else {
        _score -= 1;
        _scoreFeedbackText = '-1';
        _scoreFeedbackColor = const Color(0xFFEF476F);
      }
      _pendingGuessNumber = null;
      if (MultiplayerEngine.instance.isInRoom) {
        MultiplayerEngine.instance.updateScore(
          score: _score,
          streak: _stats.currentStreak,
        );
      }

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
        if (MultiplayerEngine.instance.isInRoom) {
          MultiplayerEngine.instance.submitGuess(guess: false);
        }
      } else {
        _pendingGuessNumber = targetNextInt;
        if (MultiplayerEngine.instance.isInRoom) {
          MultiplayerEngine.instance.submitGuess(guess: true);
        }
      }
    });
  }

  @override
  void dispose() {
    _multiplayerSub?.cancel();
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _gridScrollController.dispose();
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentInt = _fractionalN.floor();
    final activeNumber =
        _currentSieveNumber ?? _engine.getPlayedNumber(currentInt);
    final isFlashing = _flashNumber == currentInt;

    String heroTitle;
    if (currentInt == 0) {
      heroTitle = l10n.heroReady;
    } else if (currentInt == 1) {
      heroTitle = l10n.heroGo;
    } else if (activeNumber?.isPrime == true) {
      heroTitle = l10n.heroPrime(currentInt);
    } else if (activeNumber != null) {
      heroTitle = '$currentInt - ${activeNumber.factorizationDisplay}';
    } else {
      heroTitle = '$currentInt';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF160B29) : const Color(0xFFEDE7F6),
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/icon.png', width: 30, height: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.appTitle,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.5,
                  color: isDark
                      ? const Color(0xFFE0D0FF)
                      : const Color(0xFF2E1065),
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (MediaQuery.sizeOf(context).width >= 650)
            Tooltip(
              message: AudioEngine.instance.playHarmonics
                  ? l10n.harmonicsOffTooltip
                  : l10n.harmonicsOnTooltip,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  AudioEngine.instance.initOrResume();
                  setState(() {
                    AudioEngine.instance.toggleHarmonics();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        semanticLabel: l10n.harmonicsLabel,
                        value: AudioEngine.instance.playHarmonics,
                        activeColor: const Color(0xFF9D4EDD),
                        checkColor: Colors.white,
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFFD4C2FC)
                              : const Color(0xFF7B2CBF),
                          width: 1.5,
                        ),
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
                      Text(
                        l10n.harmonicsLabel,
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFD4C2FC)
                              : const Color(0xFF5B21B6),
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
              AudioEngine.instance.isMuted || AudioEngine.instance.volume == 0
                  ? Icons.volume_off
                  : (AudioEngine.instance.volume < 0.5
                        ? Icons.volume_down
                        : Icons.volume_up),
              color: isDark
                  ? const Color(0xFFD4C2FC)
                  : const Color(0xFF5B21B6),
            ),
            tooltip: AudioEngine.instance.isMuted
                ? l10n.unmuteAudioTooltip
                : l10n.muteAudioTooltip,
            onPressed: () {
              AudioEngine.instance.initOrResume();
              setState(() {
                AudioEngine.instance.toggleMute();
              });
            },
          ),
          if (MediaQuery.sizeOf(context).width >= 650)
            // Master Volume Slider
            Tooltip(
              message: l10n.volumeTooltip(
                (AudioEngine.instance.isMuted
                        ? 0
                        : (AudioEngine.instance.volume * 100))
                    .round(),
              ),
              child: SizedBox(
                width: 74,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3.5,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                    activeTrackColor: isDark
                        ? const Color(0xFF9D4EDD)
                        : const Color(0xFF7B2CBF),
                    inactiveTrackColor: isDark
                        ? const Color(0xFF380C59)
                        : const Color(0xFFD1C4E9),
                    thumbColor: isDark
                        ? const Color(0xFFD4C2FC)
                        : const Color(0xFF5B21B6),
                  ),
                  child: Slider(
                    value: AudioEngine.instance.isMuted
                        ? 0.0
                        : AudioEngine.instance.volume,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (val) {
                      AudioEngine.instance.initOrResume();
                      setState(() {
                        AudioEngine.instance.setVolume(val);
                      });
                    },
                  ),
                ),
              ),
            ),
          IconButton(
            icon: Icon(
              Icons.groups_rounded,
              color: isDark
                  ? const Color(0xFF00B4D8)
                  : const Color(0xFF0284C7),
            ),
            tooltip: l10n.multiplayerMatchTooltip,
            onPressed: () => showMultiplayerDialog(
              context,
              onStartGame: () {
                AudioEngine.instance.initOrResume();
                setState(() {
                  _clock.start();
                });
              },
            ),
          ),
          if (MultiplayerEngine.instance.isInRoom) ...[
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF476F)),
              tooltip: MultiplayerEngine.instance.isHost
                  ? l10n.quitDisbandTooltip
                  : l10n.quitLeaveTooltip,
              onPressed: _leaveMultiplayerRoom,
            ),
          ],
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: isDark
                  ? const Color(0xFFD4C2FC)
                  : const Color(0xFF5B21B6),
            ),
            tooltip: isDark ? l10n.themeLightTooltip : l10n.themeDarkTooltip,
            onPressed: () => ThemeController.toggleTheme(),
          ),
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: isDark
                  ? const Color(0xFFD4C2FC)
                  : const Color(0xFF5B21B6),
            ),
            tooltip: l10n.aboutAndHelpTooltip,
            onPressed: () => showSieveAboutDialog(context),
          ),
          PopupMenuButton<Locale>(
            icon: Icon(
              Icons.language_rounded,
              color: isDark
                  ? const Color(0xFFD4C2FC)
                  : const Color(0xFF5B21B6),
            ),
            tooltip: l10n.switchLanguageTooltip,
            initialValue:
                LocaleController.currentLocale.value ??
                LocaleController.autoLocale,
            onSelected: (loc) => LocaleController.setLocale(loc),
            itemBuilder: (context) => [
              CheckedPopupMenuItem<Locale>(
                value: LocaleController.autoLocale,
                checked: LocaleController.currentLocale.value == null,
                child: Text(l10n.languageAuto),
              ),
              for (final locale in LocaleController.supportedLocales)
                CheckedPopupMenuItem<Locale>(
                  value: locale,
                  checked:
                      LocaleController.currentLocale.value?.languageCode ==
                      locale.languageCode,
                  child: Text(LocaleController.languageDisplayName(locale)),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textScale = MediaQuery.textScalerOf(context).scale(1.0);
            final isTall = constraints.maxHeight >= (650 * textScale);

            final heroSpotlight = AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isFlashing
                      ? [
                          activeNumber?.isPrime == true
                              ? (isDark
                                    ? const Color(0xFF6A040F)
                                    : const Color(0xFFFFD5D9))
                              : (isDark
                                    ? const Color(0xFF380C59)
                                    : const Color(0xFFE2D6F5)),
                          isDark ? const Color(0xFF1E152A) : Colors.white,
                        ]
                      : (isDark
                            ? [
                                const Color(0xFF240046),
                                const Color(0xFF140824),
                              ]
                            : [
                                const Color(0xFFF3E8FF),
                                const Color(0xFFEADBFF),
                              ]),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: activeNumber?.isPrime == true
                      ? (isDark
                            ? const Color(0xFFFFD166)
                            : const Color(0xFFD97706))
                      : (isFlashing
                            ? (isDark
                                  ? const Color(0xFFD4C2FC)
                                  : const Color(0xFF7B2CBF))
                            : (isDark
                                  ? const Color(0xFF380C59)
                                  : const Color(0xFFD1C4E9))),
                  width: isFlashing ? 2.5 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: activeNumber?.isPrime == true
                        ? (isDark
                              ? const Color(0xFFFFD166).withValues(alpha: 0.3)
                              : const Color(0xFFD97706).withValues(alpha: 0.25))
                        : (isDark
                              ? const Color(0xFF9D4EDD).withValues(alpha: 0.2)
                              : const Color(
                                  0xFF7B2CBF,
                                ).withValues(alpha: 0.12)),
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
                          ? (isDark
                                ? const Color(0xFFFFD166)
                                : const Color(0xFFB45309))
                          : (currentInt < 2
                                ? (isDark
                                      ? const Color(0xFFD4C2FC)
                                      : const Color(0xFF5B21B6))
                                : (isDark
                                      ? Colors.white
                                      : const Color(0xFF1E152A))),
                      shadows: [
                        Shadow(
                          color: activeNumber?.isPrime == true
                              ? (isDark
                                    ? const Color(
                                        0xFFFFD166,
                                      ).withValues(alpha: 0.8)
                                    : const Color(0xFFFDE68A))
                              : (isDark ? Colors.black54 : Colors.transparent),
                          blurRadius: isDark ? 12 : 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (currentInt == 0) ...[
                    Text(
                      l10n.countingBeginsAtZero,
                      style: TextStyle(
                        color:
                            isDark ? Colors.white60 : const Color(0xFF4B5563),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ] else if (currentInt == 1) ...[
                    Text(
                      l10n.nextNumberIsTwo,
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFF06D6A0)
                            : const Color(0xFF059669),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ] else if (activeNumber != null && activeNumber.isPrime) ...[
                    Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFFFFD166)
                                : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            l10n.primeNumberBadge,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.black
                                  : const Color(0xFF92400E),
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        Chip(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: HarmonicPalette.getColor(
                            currentInt,
                            isDark: isDark,
                          ).withValues(alpha: isDark ? 0.25 : 0.15),
                          side: BorderSide(
                            color: HarmonicPalette.getColor(
                              currentInt,
                              isDark: isDark,
                            ),
                          ),
                          avatar: CircleAvatar(
                            backgroundColor: HarmonicPalette.getColor(
                              currentInt,
                              isDark: isDark,
                            ),
                            child: Text(
                              '$currentInt',
                              style: TextStyle(
                                color: isDark ? Colors.black : Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          label: Builder(
                            builder: (context) {
                              final note =
                                  HarmonicPalette.getNote(currentInt);
                              final freq =
                                  note.frequency.toStringAsFixed(1);
                              return Text(
                                'Note: ${note.noteName} ($freq Hz)',
                                style: TextStyle(
                                  color: HarmonicPalette.getColor(
                                    currentInt,
                                    isDark: isDark,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ] else if (activeNumber != null &&
                      activeNumber.factors.isNotEmpty) ...[
                    // Show factor composition chips if there is room
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      alignment: WrapAlignment.center,
                      children: activeNumber.factors.map((f) {
                        final color = HarmonicPalette.getColor(
                          f.prime,
                          isDark: isDark,
                        );
                        final note = HarmonicPalette.getNote(f.prime);
                        return Chip(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: color.withValues(
                            alpha: isDark ? 0.2 : 0.12,
                          ),
                          side: BorderSide(color: color),
                          avatar: CircleAvatar(
                            backgroundColor: color,
                            child: Text(
                              '${f.prime}',
                              style: TextStyle(
                                color: isDark ? Colors.black : Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          label: Text(
                            '${f.toSuperscript()} (${note.noteName})',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            );

            final numberGridHeader = Row(
              children: [
                Icon(
                  Icons.grid_view_rounded,
                  color: isDark
                      ? const Color(0xFFA08FC2)
                      : const Color(0xFF6B7280),
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.numberStreamGrid,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFA08FC2)
                          : const Color(0xFF6B7280),
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
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
                color: isDark ? const Color(0xFF1A0E2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF380C59)
                      : const Color(0xFFE5E7EB),
                ),
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
                      if (MultiplayerEngine.instance.isInRoom &&
                          !MultiplayerEngine.instance.isHost) ...[
                        // Guest view: host controls playback & tempo
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FilledButton.icon(
                              onPressed: _leaveMultiplayerRoom,
                              icon: const Icon(Icons.logout_rounded, size: 16),
                              label: Text(
                                l10n.leaveRoom,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFE63946),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF240046)
                                    : const Color(0xFFEDE7F6),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF00B4D8)
                                      : const Color(0xFF0284C7),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sync_lock_rounded,
                                    size: 14,
                                    color: isDark
                                        ? const Color(0xFF00B4D8)
                                        : const Color(0xFF0284C7),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.hostControls(
                                      MultiplayerEngine
                                              .instance
                                              .currentRoomCode ??
                                          '',
                                    ),
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color(0xFF00B4D8)
                                          : const Color(0xFF0284C7),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        // Solo or Host transport controls
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton.filled(
                              onPressed: _resetSieve,
                              icon: const Icon(Icons.replay),
                              tooltip: MultiplayerEngine.instance.isInRoom
                                  ? l10n.resetMatchHostTooltip
                                  : l10n.resetSieveScoreTooltip,
                              style: IconButton.styleFrom(
                                backgroundColor: isDark
                                    ? const Color(0xFF380C59)
                                    : const Color(0xFFEDE7F6),
                                foregroundColor: isDark
                                    ? Colors.white70
                                    : const Color(0xFF5B21B6),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton.filled(
                              iconSize: 34,
                              onPressed: _togglePlayPause,
                              icon: Icon(
                                _clock.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              tooltip: _clock.isPlaying
                                  ? l10n.pauseTooltip
                                  : l10n.playTooltip,
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF7B2CBF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(10),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton.filled(
                              onPressed: _stepForward,
                              icon: const Icon(Icons.skip_next),
                              tooltip: l10n.stepForwardTooltip,
                              style: IconButton.styleFrom(
                                backgroundColor: isDark
                                    ? const Color(0xFF380C59)
                                    : const Color(0xFFEDE7F6),
                                foregroundColor: isDark
                                    ? Colors.white70
                                    : const Color(0xFF5B21B6),
                              ),
                            ),
                            if (MultiplayerEngine.instance.isInRoom &&
                                MultiplayerEngine.instance.isHost) ...[
                              const SizedBox(width: 10),
                              IconButton.filled(
                                onPressed: _leaveMultiplayerRoom,
                                icon: const Icon(Icons.logout_rounded),
                                tooltip: l10n.endMatchDisbandTooltip,
                                style: IconButton.styleFrom(
                                  backgroundColor: const Color(0xFFE63946),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // "Guess" Button: tests reflexes on next number
                            Tooltip(
                              message: isGuessedForNext
                                  ? l10n.cancelGuessTooltip(targetNextInt)
                                  : l10n.guessNextTooltip(targetNextInt),
                              child: FilledButton.icon(
                                onPressed: _onGuessPressed,
                                icon: Icon(
                                  isGuessedForNext
                                      ? Icons.check_circle_outline
                                      : Icons.bolt,
                                  size: 17,
                                ),
                                label: Text(
                                  isGuessedForNext
                                      ? l10n.guessButtonActive(targetNextInt)
                                      : l10n.guessButtonInactive(targetNextInt),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: _scoreFeedbackColor != null
                                    ? _scoreFeedbackColor!.withValues(
                                        alpha: 0.25,
                                      )
                                    : (isDark
                                          ? const Color(0xFF240046)
                                          : const Color(0xFFEDE7F6)),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:
                                      _scoreFeedbackColor ??
                                      (isDark
                                          ? const Color(0xFF7B2CBF)
                                          : const Color(0xFFD1C4E9)),
                                  width: _scoreFeedbackColor != null
                                      ? 2.0
                                      : 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.stars_rounded,
                                    size: 16,
                                    color: isDark
                                        ? const Color(0xFFFFD166)
                                        : const Color(0xFFD97706),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    l10n.scoreDisplay(_score),
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1E152A),
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
                                  if (_stats.highScore > 0) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 1,
                                      height: 14,
                                      color: isDark
                                          ? Colors.white24
                                          : const Color(0xFFD1C4E9),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.military_tech_rounded,
                                      size: 15,
                                      color: isDark
                                          ? const Color(0xFFFFD166)
                                          : const Color(0xFFD97706),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      l10n.scoreBest(_stats.highScore),
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFFFFD166)
                                            : const Color(0xFFD97706),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                  if (_stats.isNewHighScore) ...[
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFFFFD166)
                                            : const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        l10n.newHighScoreBadge,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.black
                                              : const Color(0xFF92400E),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (_stats.currentStreak > 1) ...[
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF8500),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        '${_stats.currentStreak}x',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Player Stats & Records Dialog Button
                            IconButton(
                              icon: Icon(
                                Icons.leaderboard_rounded,
                                color: isDark
                                    ? const Color(0xFFD4C2FC)
                                    : const Color(0xFF5B21B6),
                                size: 20,
                              ),
                              tooltip: l10n.statsDialogTooltip,
                              onPressed: () => showGameStatsDialog(
                                context,
                                _stats,
                                onStatsReset: () => setState(() {}),
                              ),
                            ),
                            // Game Explanation & Rules Help Button
                            IconButton(
                              icon: Icon(
                                Icons.help_outline,
                                color: isDark
                                    ? const Color(0xFFD4C2FC)
                                    : const Color(0xFF5B21B6),
                                size: 20,
                              ),
                              tooltip: l10n.gameHelpTooltip,
                              onPressed: () => showGameRulesDialog(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.speed,
                            size: 18,
                            color: isDark
                                ? const Color(0xFFD4C2FC)
                                : const Color(0xFF5B21B6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Tooltip(
                              message:
                                  (MultiplayerEngine.instance.isInRoom &&
                                      !MultiplayerEngine.instance.isHost)
                                  ? l10n.tempoSyncTooltip
                                  : l10n.tempoTooltip,
                              child: Builder(
                                builder: (context) {
                                  final isGuest =
                                      MultiplayerEngine.instance.isInRoom &&
                                      !MultiplayerEngine.instance.isHost;
                                  final hzStr =
                                      _clock.speedHz.toStringAsFixed(1);
                                  final bpm = (_clock.speedHz * 60).toInt();
                                  final base = l10n.tempoDisplay(hzStr, bpm);
                                  final suffix =
                                      isGuest ? l10n.tempoHostSuffix : '';
                                  return Text(
                                    '$base$suffix',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? const Color(0xFFD4C2FC)
                                          : const Color(0xFF5B21B6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _clock.speedHz,
                        min: 0.2,
                        max: 5.0,
                        divisions: 24,
                        activeColor:
                            (MultiplayerEngine.instance.isInRoom &&
                                !MultiplayerEngine.instance.isHost)
                            ? Colors.white30
                            : (isDark
                                  ? const Color(0xFF9D4EDD)
                                  : const Color(0xFF7B2CBF)),
                        inactiveColor: isDark
                            ? const Color(0xFF380C59)
                            : const Color(0xFFD1C4E9),
                        onChanged:
                            (MultiplayerEngine.instance.isInRoom &&
                                !MultiplayerEngine.instance.isHost)
                            ? null
                            : (val) => _updateTempo(val),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    heroSpotlight,
                    if (MultiplayerEngine.instance.isInRoom) ...[
                      const MultiplayerScoreboard(),
                      const SizedBox(height: 8),
                    ],
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    heroSpotlight,
                    if (MultiplayerEngine.instance.isInRoom) ...[
                      const MultiplayerScoreboard(),
                      const SizedBox(height: 8),
                    ],
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
