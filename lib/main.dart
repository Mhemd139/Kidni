import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'models/models.dart';

// ============================================
// Kidni App Color Palette
// ============================================
class KidniColors {
  // Primary colors
  static const Color primary = Color(0xFFFF7F50); // Soft Coral
  static const Color primaryLight = Color(0xFFFFAB91);
  static const Color primaryDark = Color(0xFFE65100);

  // Background colors
  static const Color background = Color(0xFFFFFDD0); // Cream/Off-White
  static const Color surface = Color(0xFFFFFFF8); // Slightly warm white
  static const Color cardBackground = Colors.white;

  // Feedback colors
  static const Color success = Color(0xFF98FF98); // Mint Green
  static const Color successDark = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFA8072); // Soft Red (Salmon)
  static const Color errorDark = Color(0xFFE53935);

  // Text colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFF6C7880); // 4.7:1 on cream — meets WCAG AA

  // Level colors (kept for variety)
  static const Color level1 = Color(0xFF4CAF50); // Green
  static const Color level2 = Color(0xFF2196F3); // Blue
  static const Color level3 = Color(0xFFFF9800); // Orange
  static const Color level4 = Color(0xFF9C27B0); // Purple
  static const Color level5 = Color(0xFFE91E63); // Pink
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Portrait-only — the layout is designed vertically; avoids stretched landscape on tablets
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize LevelManager before app starts
  await LevelManager().init();

  runApp(const KidniApp());
}

class KidniApp extends StatelessWidget {
  const KidniApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Varela Round for a friendly Hebrew look
    final textTheme = GoogleFonts.varelaRoundTextTheme(
      Theme.of(context).textTheme,
    );

    return MaterialApp(
      title: 'קידני',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: KidniColors.primary,
          brightness: Brightness.light,
          primary: KidniColors.primary,
          onPrimary: Colors.white,
          secondary: KidniColors.primaryLight,
          surface: KidniColors.surface,
          background: KidniColors.background,
          error: KidniColors.errorDark,
        ),
        scaffoldBackgroundColor: KidniColors.background,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: KidniColors.primary,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.varelaRound(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: KidniColors.cardBackground,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: KidniColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            textStyle: GoogleFonts.varelaRound(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: KidniColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: KidniColors.cardBackground,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
