import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sieve/main.dart';
import 'package:sieve/models/theme_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Theme cleanup tests', () {
    testWidgets('Dark mode uses ColorScheme.fromSeed and primaryContainer buttons', (
      WidgetTester tester,
    ) async {
      await ThemeController.setThemeMode(ThemeMode.dark);

      await tester.pumpWidget(const SieveApp());
      await tester.pumpAndSettle();

      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final expectedScheme = ColorScheme.fromSeed(
        seedColor: kSieveSeedColor,
        brightness: Brightness.dark,
      );
      final theme = Theme.of(tester.element(scaffoldFinder));
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.surface, expectedScheme.surface);
      expect(theme.scaffoldBackgroundColor, expectedScheme.surface);

      final buttonStyle = theme.elevatedButtonTheme.style!;
      expect(
        buttonStyle.backgroundColor?.resolve({}),
        theme.colorScheme.primaryContainer,
      );
      expect(
        buttonStyle.foregroundColor?.resolve({}),
        theme.colorScheme.onPrimaryContainer,
      );
    });

    testWidgets('Light mode uses ColorScheme.fromSeed and primaryContainer buttons', (
      WidgetTester tester,
    ) async {
      await ThemeController.setThemeMode(ThemeMode.light);

      await tester.pumpWidget(const SieveApp());
      await tester.pumpAndSettle();

      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final expectedScheme = ColorScheme.fromSeed(
        seedColor: kSieveSeedColor,
        brightness: Brightness.light,
      );
      final theme = Theme.of(tester.element(scaffoldFinder));
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.surface, expectedScheme.surface);
      expect(theme.scaffoldBackgroundColor, expectedScheme.surface);

      final buttonStyle = theme.elevatedButtonTheme.style!;
      expect(
        buttonStyle.backgroundColor?.resolve({}),
        theme.colorScheme.primaryContainer,
      );
      expect(
        buttonStyle.foregroundColor?.resolve({}),
        theme.colorScheme.onPrimaryContainer,
      );

      // Reset to default dark mode.
      await ThemeController.setThemeMode(ThemeMode.dark);
    });
  });
}
