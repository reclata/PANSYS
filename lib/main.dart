import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const PanSysApp());
}

// Global Router Configuration
final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);

class PanSysApp extends StatelessWidget {
  const PanSysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PanSys - Gestão Inteligente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            0xFFD97736,
          ), // Cor principal: Laranja/Tostado rico
          primary: const Color(0xFFD97736),
          secondary: const Color(0xFF2B2D42), // Escuro elegante para constrate
        ),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme)
            .apply(
              bodyColor: const Color(0xFF2B2D42),
              displayColor: const Color(0xFF2B2D42),
            ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E24),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFFE58C4F),
          primary: const Color(0xFFE58C4F),
          secondary: const Color(0xFFFDE8DF),
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme)
            .apply(
              bodyColor: const Color(0xFFFDE8DF),
              displayColor: const Color(0xFFFDE8DF),
            ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
