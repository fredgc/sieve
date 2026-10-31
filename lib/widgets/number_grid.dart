import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/harmonic_palette.dart';
import '../models/sieve_engine.dart';

/// 2D number grid where numbers flow left-to-right and top-to-bottom.
/// Shows 4 rows of fixed-size boxes in the viewport.
/// Includes a continuous playhead token/line that glides along the grid and strikes each box.
class NumberGrid extends StatefulWidget {
  final SieveEngine engine;
  final double fractionalN;
  final Function(int number)? onNumberTapped;
  final Map<int, bool> userGuesses;
  final int? pendingGuessNumber;
  final ScrollController? scrollController;

  const NumberGrid({
    super.key,
    required this.engine,
    required this.fractionalN,
    this.onNumberTapped,
    this.userGuesses = const {},
    this.pendingGuessNumber,
    this.scrollController,
  });

  @override
  State<NumberGrid> createState() => _NumberGridState();
}

class _NumberGridState extends State<NumberGrid> {
  late final ScrollController _scrollController;
  bool _ownsScrollController = false;
  int _lastAutoScrolledRow = -1;
  int _actualCrossAxisCount = 10;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController!;
    } else {
      _scrollController = ScrollController();
      _ownsScrollController = true;
    }
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(NumberGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldInt = oldWidget.fractionalN.floor();
    final newInt = widget.fractionalN.floor();
    if (newInt != oldInt) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAutoScroll(newInt);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (_ownsScrollController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  int _getCrossAxisCount(double availableWidth, int currentInt) {
    // Boxes do not change size until reaching 3 digits (100+),
    // at which point rows can have slightly fewer wider boxes if needed.
    final double targetBoxWidth = currentInt >= 100 ? 68.0 : 54.0;
    int count = (availableWidth / targetBoxWidth).floor();
    if (count < 4) count = 4;
    if (count > 10) count = 10;
    return count;
  }

  void _checkAutoScroll(int currentInt) {
    if (!_scrollController.hasClients) return;

    if (currentInt == 0) {
      _lastAutoScrolledRow = 0;
      if (_scrollController.offset > 0) {
        _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
      return;
    }

    final currentRow = currentInt ~/ _actualCrossAxisCount;

    if (currentRow == _lastAutoScrolledRow) return;
    _lastAutoScrolledRow = currentRow;

    const double rowHeight = 62.0;
    const double rowSpacing = 6.0;
    const double rowStep = rowHeight + rowSpacing;

    // Center active row in viewport dynamically
    final viewportHeight = _scrollController.position.viewportDimension;
    final activeRowTop = currentRow * rowStep;
    final double targetOffset = math.max(0.0, activeRowTop - (viewportHeight / 2) + (rowHeight / 2));

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentInt = widget.fractionalN.floor();
    // Render at least 120 numbers, and always plenty of rows ahead
    final totalNumbers = math.max(120, ((currentInt + 59) ~/ 10) * 10);

    const double cellHeight = 62.0;
    const double spacing = 6.0;
    const double padding = 10.0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF130722),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF380C59), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth - (padding * 2);
            final crossAxisCount = _getCrossAxisCount(availableWidth, currentInt);
            _actualCrossAxisCount = crossAxisCount;
            final cellWidth = (availableWidth - ((crossAxisCount - 1) * spacing)) / crossAxisCount;

            return Stack(
              children: [
                // Scrollable Grid of Numbers
                Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(padding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: spacing,
                      crossAxisSpacing: spacing,
                      mainAxisExtent: cellHeight, // Fixed height: never changes size
                    ),
                    itemCount: totalNumbers,
                    itemBuilder: (context, index) {
                      final n = index;
                      final isPlayed = widget.engine.isNumberPlayed(n);
                      final isCurrent = n == currentInt;
                      final isPrimeDiscovered = widget.engine.discoveredPrimes.contains(n);
                      final guessCorrect = widget.userGuesses[n];
                      final isPendingGuess = widget.pendingGuessNumber == n;

                      return _GridCell(
                        number: n,
                        isPlayed: isPlayed,
                        isCurrent: isCurrent,
                        isPrimeDiscovered: isPrimeDiscovered,
                        guessCorrect: guessCorrect,
                        isPendingGuess: isPendingGuess,
                        cellWidth: cellWidth,
                        cellHeight: cellHeight,
                        sieveNumber: isPlayed ? widget.engine.getPlayedNumber(n) : null,
                        onTap: () => widget.onNumberTapped?.call(n),
                      );
                    },
                  ),
                ),

                // Smooth Gliding Cursor / Playhead Line Overlay
                IgnorePointer(
                  child: CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: _PlayheadCursorPainter(
                      fractionalN: widget.fractionalN,
                      crossAxisCount: crossAxisCount,
                      cellWidth: cellWidth,
                      cellHeight: cellHeight,
                      spacing: spacing,
                      padding: padding,
                      scrollOffset: _scrollController.hasClients ? _scrollController.offset : 0.0,
                      engine: widget.engine,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Custom painter that draws a vertical line/token moving along the active box as fractional time elapses.
class _PlayheadCursorPainter extends CustomPainter {
  final double fractionalN;
  final int crossAxisCount;
  final double cellWidth;
  final double cellHeight;
  final double spacing;
  final double padding;
  final double scrollOffset;
  final SieveEngine engine;

  _PlayheadCursorPainter({
    required this.fractionalN,
    required this.crossAxisCount,
    required this.cellWidth,
    required this.cellHeight,
    required this.spacing,
    required this.padding,
    required this.scrollOffset,
    required this.engine,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final currentInt = fractionalN.floor();
    final fraction = (fractionalN - currentInt).clamp(0.0, 1.0);

    final col = currentInt % crossAxisCount;
    final row = currentInt ~/ crossAxisCount;

    final cellLeft = padding + (col * (cellWidth + spacing));
    final cellTop = padding + (row * (cellHeight + spacing)) - scrollOffset;

    // Only draw if within visible viewport
    if (cellTop + cellHeight < 0 || cellTop > size.height) return;

    final isPrime = engine.discoveredPrimes.contains(currentInt);
    final Color cursorColor = currentInt < 2
        ? const Color(0xFF00B4D8)
        : (isPrime ? const Color(0xFFFFD166) : const Color(0xFFE0D0FF));

    // Active box highlight outline
    final cellRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cellLeft, cellTop, cellWidth, cellHeight),
      const Radius.circular(8),
    );
    final highlightPaint = Paint()
      ..color = cursorColor.withValues(alpha: 0.25 + (0.2 * (1.0 - fraction)))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(cellRect, highlightPaint);

    // Moving vertical cursor line: sweeps from left to right across the box
    final cursorX = cellLeft + (fraction * cellWidth);

    // Cursor line
    final linePaint = Paint()
      ..color = cursorColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          cursorColor.withValues(alpha: 0.2),
          cursorColor,
          cursorColor,
          cursorColor.withValues(alpha: 0.2),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(cursorX, cellTop, 3, cellHeight));

    canvas.drawLine(
      Offset(cursorX, cellTop + 1),
      Offset(cursorX, cellTop + cellHeight - 1),
      linePaint,
    );

    // Top pointer token (small glowing diamond indicator)
    final tokenPaint = Paint()
      ..color = cursorColor
      ..style = PaintingStyle.fill;

    final tokenPath = Path()
      ..moveTo(cursorX, cellTop + 1)
      ..lineTo(cursorX - 3.5, cellTop - 4)
      ..lineTo(cursorX, cellTop - 8)
      ..lineTo(cursorX + 3.5, cellTop - 4)
      ..close();

    canvas.drawPath(tokenPath, tokenPaint);
  }

  @override
  bool shouldRepaint(covariant _PlayheadCursorPainter oldDelegate) {
    return oldDelegate.fractionalN != fractionalN ||
        oldDelegate.scrollOffset != scrollOffset ||
        oldDelegate.crossAxisCount != crossAxisCount;
  }
}

class _GridCell extends StatelessWidget {
  final int number;
  final bool isPlayed;
  final bool isCurrent;
  final bool isPrimeDiscovered;
  final bool? guessCorrect; // true = green, false = red, null = no guess
  final bool isPendingGuess; // true = amber pending outline
  final double cellWidth;
  final double cellHeight;
  final SieveNumber? sieveNumber;
  final VoidCallback? onTap;

  const _GridCell({
    required this.number,
    required this.isPlayed,
    required this.isCurrent,
    required this.isPrimeDiscovered,
    this.guessCorrect,
    this.isPendingGuess = false,
    required this.cellWidth,
    required this.cellHeight,
    required this.sieveNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color textColor;
    double borderWidth = 1.0;

    if (!isPlayed) {
      // Unplayed: neutral, plain integer only, no prime or factor info revealed
      bgColor = const Color(0xFF180E28);
      borderColor = const Color(0xFF28143F);
      textColor = const Color(0xFF75658E);
    } else if (isCurrent) {
      // Current active number: highlighted
      bgColor = isPrimeDiscovered ? const Color(0xFF4A1800) : const Color(0xFF380C59);
      borderColor = isPrimeDiscovered ? const Color(0xFFFFD166) : const Color(0xFFE0D0FF);
      textColor = Colors.white;
      borderWidth = 2.0;
    } else {
      // Already played number
      if (number == 0 || number == 1) {
        bgColor = const Color(0xFF1E1035);
        borderColor = const Color(0xFF4B2375);
        textColor = const Color(0xFFD4C2FC);
      } else if (isPrimeDiscovered) {
        bgColor = const Color(0xFF2B1300);
        borderColor = const Color(0xFFFFD166).withValues(alpha: 0.8);
        textColor = const Color(0xFFFFD166);
      } else {
        bgColor = const Color(0xFF1A0B2C);
        borderColor = const Color(0xFF3E1463);
        textColor = const Color(0xFFE2D6F5);
      }
    }

    // Border and shadow override for player guesses:
    List<BoxShadow>? shadows;
    if (guessCorrect == true) {
      // Correct guess: Vibrant Green border
      borderColor = const Color(0xFF06D6A0);
      borderWidth = 2.5;
      shadows = [
        BoxShadow(
          color: const Color(0xFF06D6A0).withValues(alpha: 0.45),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ];
    } else if (guessCorrect == false) {
      // Incorrect guess: Vibrant Red border
      borderColor = const Color(0xFFEF476F);
      borderWidth = 2.5;
      shadows = [
        BoxShadow(
          color: const Color(0xFFEF476F).withValues(alpha: 0.45),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ];
    } else if (isPendingGuess && !isPlayed) {
      // Pending active guess for next number: Golden amber glow
      borderColor = const Color(0xFFFFD166);
      borderWidth = 2.0;
      shadows = [
        BoxShadow(
          color: const Color(0xFFFFD166).withValues(alpha: 0.35),
          blurRadius: 6,
          spreadRadius: 1,
        ),
      ];
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cellWidth,
        height: cellHeight,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: shadows,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The number itself (never changes size)
            Text(
              '$number',
              style: TextStyle(
                color: textColor,
                fontSize: number >= 100 ? 13 : 15,
                fontWeight: (isCurrent || isPrimeDiscovered || guessCorrect != null)
                    ? FontWeight.bold
                    : FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            // Subtitle / composition area: strictly revealed only after played
            if (isPendingGuess && !isPlayed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD166).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Text(
                  'GUESS',
                  style: TextStyle(
                    color: Color(0xFFFFD166),
                    fontSize: 7.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
              )
            else if (!isPlayed)
              const SizedBox(height: 14)
            else if (number == 0)
              const Text(
                'Ready',
                style: TextStyle(color: Color(0xFFA08FC2), fontSize: 9, fontWeight: FontWeight.bold),
              )
            else if (number == 1)
              const Text(
                'Go!',
                style: TextStyle(color: Color(0xFF06D6A0), fontSize: 9, fontWeight: FontWeight.bold),
              )
            else if (isPrimeDiscovered)
              // ONLY show "PRIME" if the prime has already been discovered!
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD166),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  'PRIME',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
              )
            else if (sieveNumber != null && sieveNumber!.factors.isNotEmpty)
              // Composite: show factor composition (e.g. 2², 2·3, 2²·3)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _buildCompositionSpans(sieveNumber!),
                ),
              )
            else
              const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCompositionSpans(SieveNumber sn) {
    final widgets = <Widget>[];
    for (int i = 0; i < sn.factors.length; i++) {
      final f = sn.factors[i];
      final color = HarmonicPalette.getColor(f.prime);
      widgets.add(
        Text(
          f.toSuperscript(),
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      if (i < sn.factors.length - 1) {
        widgets.add(
          const Text(
            '·',
            style: TextStyle(color: Colors.white38, fontSize: 8),
          ),
        );
      }
    }
    return widgets;
  }
}
