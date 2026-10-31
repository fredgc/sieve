import 'package:flutter/material.dart';
import '../models/harmonic_palette.dart';
import '../models/sieve_engine.dart';

/// Renders the continuous triangle wave proximity dashboard for discovered primes.
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
    // Proximity waves do not appear until after at least one prime has been discovered
    if (discoveredPrimes.isEmpty) {
      return const SizedBox.shrink();
    }

    // Strictly only display bars for primes that have already been discovered!
    final visiblePrimes = discoveredPrimes.toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF140824),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF380C59), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
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
              const Row(
                children: [
                  Icon(Icons.graphic_eq, color: Color(0xFFD4C2FC), size: 16),
                  SizedBox(width: 6),
                  Text(
                    'PROXIMITY WAVES',
                    style: TextStyle(
                      color: Color(0xFFD4C2FC),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              Text(
                '${discoveredPrimes.length} Primes Discovered',
                style: const TextStyle(color: Colors.white54, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              const double spacing = 5.0;
              const double runSpacing = 4.0;
              const double targetTightWidth = 104.0;

              // Tight width: just a little wider than needed for a 5-digit prime, note name, and percentage
              int columns = ((constraints.maxWidth + spacing) / (targetTightWidth + spacing)).floor();
              if (columns < 2) columns = 2;

              final itemWidth = (constraints.maxWidth - ((columns - 1) * spacing)) / columns;
              const double itemHeight = 24.0;

              return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 125),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: runSpacing,
                    children: visiblePrimes.map((prime) {
                      final proximity = SieveEngine.getProximity(prime, fractionalN);
                      final color = HarmonicPalette.getColor(prime);
                      final note = HarmonicPalette.getNote(prime);
                      final isPeak = proximity > 0.95;
                      // Stop displaying the chord/note for six digit primes (>= 100,000)
                      final showChord = prime < 100000;

                      return GestureDetector(
                        onTap: () => onPrimeSelected?.call(prime),
                        child: Container(
                          width: itemWidth,
                          height: itemHeight,
                          decoration: BoxDecoration(
                            color: const Color(0xFF220D3D),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isPeak ? Colors.white : color.withValues(alpha: 0.5),
                              width: isPeak ? 1.5 : 1.0,
                            ),
                            boxShadow: isPeak
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.6),
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
                                    color: color.withValues(alpha: isPeak ? 0.75 : 0.4),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              // Label & info - tight single row
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            '$prime',
                                            style: const TextStyle(
                                              color: Colors.black,
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
                                              color: Colors.white.withValues(alpha: 0.9),
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
                                        color: isPeak ? Colors.white : Colors.white70,
                                        fontSize: 9.0,
                                        fontWeight: isPeak ? FontWeight.bold : FontWeight.normal,
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
