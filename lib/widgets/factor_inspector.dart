import 'package:flutter/material.dart';
import '../models/harmonic_palette.dart';
import '../models/sieve_engine.dart';

/// Interactive modal sheet to inspect the prime factorization and harmonic notes of any number.
void showFactorInspector(BuildContext context, int number, SieveEngine engine) {
  final isPlayed = engine.isNumberPlayed(number);
  final sieveNum = engine.getPlayedNumber(number) ?? SieveEngine.factorizeStatic(number);

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1E152A),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      side: BorderSide(color: Color(0xFF531183), width: 1.5),
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
                  color: Colors.white24,
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
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: sieveNum.isPrime ? const Color(0xFFFFD166) : const Color(0xFF380C59),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: sieveNum.isPrime ? Colors.transparent : const Color(0xFF9D4EDD),
                        ),
                      ),
                      child: Text(
                        number < 2
                            ? 'START'
                            : (sieveNum.isPrime ? 'PRIME' : 'COMPOSITE'),
                        style: TextStyle(
                          color: (number >= 2 && sieveNum.isPrime) ? Colors.black : const Color(0xFFD4C2FC),
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    if (!isPlayed && number >= 2) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'UPCOMING',
                          style: TextStyle(
                            color: Colors.white54,
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD4C2FC),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF380C59)),
            const SizedBox(height: 12),
            const Text(
              'HARMONIC FACTOR DECOMPOSITION',
              style: TextStyle(
                color: Color(0xFFA08FC2),
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
                  backgroundColor: HarmonicPalette.getColor(number),
                  child: Text(
                    '$number',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  'Atomic Tone (${HarmonicPalette.getNote(number).noteName})',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Frequency: ${HarmonicPalette.getNote(number).frequency.toStringAsFixed(2)} Hz',
                  style: const TextStyle(color: Colors.white60),
                ),
              )
            else
              ...sieveNum.factors.map((f) {
                final color = HarmonicPalette.getColor(f.prime);
                final note = HarmonicPalette.getNote(f.prime);
                final freq = HarmonicPalette.getFrequencyWithPower(f.prime, f.power);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF140824),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          f.toSuperscript(),
                          style: const TextStyle(
                            color: Colors.black,
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              f.power > 1
                                  ? 'Multiplicity ${f.power} (Harmonic ${freq.toStringAsFixed(1)} Hz)'
                                  : 'Fundamental ${freq.toStringAsFixed(1)} Hz',
                              style: const TextStyle(color: Colors.white60, fontSize: 12),
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
