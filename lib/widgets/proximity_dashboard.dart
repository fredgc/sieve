import 'package:flutter/material.dart';

import '../models/harmonic_palette.dart';
import '../models/sieve_engine.dart';
import '../l10n/l10n_extension.dart';

/// Renders the continuous triangle wave proximity dashboard
/// for discovered primes.
class ProximityDashboard extends StatelessWidget {
  final List<int> discoveredPrimes;
  final double fractionalN;
  final Function(int prime)? onPrimeSelected;

  const ProximityDashboard({
    super.key,
    required this.discoveredPrimes,
    required this.fractionalN,
    this.onPrimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Proximity waves do not appear until after at least
    // one prime has been discovered
    if (discoveredPrimes.isEmpty) {
      return const SizedBox.shrink();
    }

    // Strictly only display bars for primes that have already been discovered!
    final visiblePrimes = discoveredPrimes.toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF140824) : const Color(0xFFFAF7FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF380C59) : const Color(0xFFE2D9F3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : const Color(0xFF9D4EDD).withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.graphic_eq,
                    color: isDark
                        ? const Color(0xFFD4C2FC)
                        : const Color(0xFF6B21A8),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    context.l10n.proximityWaves,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFFD4C2FC)
                          : const Color(0xFF6B21A8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              Text(
                context.l10n.primesDiscovered(discoveredPrimes.length),
                style: TextStyle(
                  color: isDark ? Colors.white54 : const Color(0xFF5A4974),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              const double spacing = 5.0;
              const double runSpacing = 4.0;
              const double targetTightWidth = 104.0;

              // Tight width: enough for 5-digit prime, note name, and percent
              int columns =
                  ((constraints.maxWidth + spacing) /
                          (targetTightWidth + spacing))
                      .floor();
              if (columns < 2) columns = 2;

              final itemWidth =
                  (constraints.maxWidth - ((columns - 1) * spacing)) / columns;
              const double itemHeight = 24.0;

              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 125),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: runSpacing,
                    children: visiblePrimes.map((prime) {
                      final proximity = SieveEngine.getProximity(
                        prime,
                        fractionalN,
                      );
                      final color = HarmonicPalette.getColor(
                        prime,
                        isDark: isDark,
                      );
                      final note = HarmonicPalette.getNote(prime);
                      final isPeak = proximity > 0.95;
                      // Stop displaying chord for six digit primes (>= 100,000)
                      final showChord = prime < 100000;

                      return GestureDetector(
                        onTap: () => onPrimeSelected?.call(prime),
                        child: Container(
                          width: itemWidth,
                          height: itemHeight,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF220D3D)
                                : const Color(0xFFF3EDFC),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isPeak
                                  ? (isDark
                                      ? Colors.white
                                      : const Color(0xFF6B21A8))
                                  : color.withValues(
                                      alpha: isDark ? 0.5 : 0.6,
                                    ),
                              width: isPeak ? 1.5 : 1.0,
                            ),
                            boxShadow: isPeak
                                ? [
                                    BoxShadow(
                                      color: color.withValues(
                                        alpha: isDark ? 0.6 : 0.4,
                                      ),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Stack(
                            children: [
                              // Animated fill gauge
                              FractionallySizedBox(
                                widthFactor: proximity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color.withValues(
                                      alpha: isPeak
                                          ? (isDark ? 0.75 : 0.35)
                                          : (isDark ? 0.4 : 0.2),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              // Label & info - tight single row
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 3.5,
                                            vertical: 1,
                                          ),
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(
                                              3,
                                            ),
                                          ),
                                          child: Text(
                                            '$prime',
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9.5,
                                              height: 1.1,
                                            ),
                                          ),
                                        ),
                                        if (showChord) ...[
                                          const SizedBox(width: 3),
                                          Text(
                                            note.noteName,
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white.withValues(
                                                      alpha: 0.9,
                                                    )
                                                  : const Color(0xFF1F1135),
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w600,
                                              height: 1.1,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Text(
                                      '${(proximity * 100).toInt()}%',
                                      style: TextStyle(
                                        color: isPeak
                                            ? (isDark
                                                ? Colors.white
                                                : const Color(0xFF6B21A8))
                                            : (isDark
                                                ? Colors.white70
                                                : const Color(0xFF5A4974)),
                                        fontSize: 9.0,
                                        fontWeight: isPeak
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
