import 'package:flutter/material.dart';

import '../models/harmonic_palette.dart';
import '../models/sieve_engine.dart';
import '../l10n/l10n_extension.dart';

/// Interactive modal sheet to inspect the prime factorization
/// and harmonic notes of any number.
void showFactorInspector(BuildContext context, int number, SieveEngine engine) {
  final isPlayed = engine.isNumberPlayed(number);
  final sieveNum =
      engine.getPlayedNumber(number) ?? SieveEngine.factorizeStatic(number);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    backgroundColor: isDark ? const Color(0xFF1E152A) : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      side: BorderSide(
        color: isDark ? const Color(0xFF531183) : const Color(0xFFC7B7E5),
        width: 1.5,
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1F1135),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: sieveNum.isPrime
                            ? (isDark
                                ? const Color(0xFFFFD166)
                                : const Color(0xFFF59E0B))
                            : (isDark
                                ? const Color(0xFF380C59)
                                : const Color(0xFFEDE7F6)),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: sieveNum.isPrime
                              ? Colors.transparent
                              : (isDark
                                  ? const Color(0xFF9D4EDD)
                                  : const Color(0xFF7B2CBF)),
                        ),
                      ),
                      child: Text(
                        number < 2
                            ? context.l10n.startLabel
                            : (sieveNum.isPrime
                                  ? context.l10n.gridPrime
                                  : context.l10n.compositeLabel),
                        style: TextStyle(
                          color: (number >= 2 && sieveNum.isPrime)
                              ? (isDark ? Colors.black : Colors.white)
                              : (isDark
                                    ? const Color(0xFFD4C2FC)
                                    : const Color(0xFF6B21A8)),
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    if (!isPlayed && number >= 2) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.black12,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          context.l10n.upcomingLabel,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF5A4974),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  sieveNum.factorizationDisplay,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFD4C2FC)
                        : const Color(0xFF6B21A8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              color: isDark ? const Color(0xFF380C59) : const Color(0xFFE2D9F3),
            ),
            const SizedBox(height: 12),
            Text(
              'HARMONIC FACTOR DECOMPOSITION',
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFA08FC2)
                    : const Color(0xFF5A4974),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            if (sieveNum.isPrime)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: HarmonicPalette.getColor(
                    number,
                    isDark: isDark,
                  ),
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  'Atomic Tone (${HarmonicPalette.getNote(number).noteName})',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F1135),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Builder(
                  builder: (context) {
                    final freq = HarmonicPalette.getNote(number)
                        .frequency
                        .toStringAsFixed(2);
                    return Text(
                      'Frequency: $freq Hz',
                      style: TextStyle(
                        color:
                            isDark ? Colors.white60 : const Color(0xFF5A4974),
                      ),
                    );
                  },
                ),
              )
            else
              ...sieveNum.factors.map((f) {
                final color = HarmonicPalette.getColor(f.prime, isDark: isDark);
                final note = HarmonicPalette.getNote(f.prime);
                final freq = HarmonicPalette.getFrequencyWithPower(
                  f.prime,
                  f.power,
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF140824)
                        : const Color(0xFFF7F5FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          f.toSuperscript(),
                          style: TextStyle(
                            color: isDark ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prime ${f.prime} (${note.noteName})',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1F1135),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              f.power > 1
                                  ? 'Multiplicity ${f.power} (Harmonic '
                                      '${freq.toStringAsFixed(1)} Hz)'
                                  : 'Fundamental ${freq.toStringAsFixed(1)} Hz',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xFF5A4974),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
