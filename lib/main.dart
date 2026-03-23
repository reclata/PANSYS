import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const PanSysApp(),
    ),
  );
}

class PanSysApp extends StatefulWidget {
  const PanSysApp({super.key});

  @override
  State<PanSysApp> createState() => _PanSysAppState();
}

class _PanSysAppState extends State<PanSysApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Injeta o Router com o RefreshListenable do AuthProvider
    final authProvider = context.read<AuthProvider>();

    _router = GoRouter(
      initialLocation: '/login',
      refreshListenable: authProvider,
      redirect: (context, state) {
        // Redirecionamento de segurança (Guard)
        final bool isLoggedIn = authProvider.isAuthenticated;
        final bool isLoggingIn = state.matchedLocation == '/login';

        // Aguarda a verificação inicial
        if (authProvider.isLoading) return null;

        // Se o usuário não está logado e NÃO está na página de Login -> Envia pra Login
        if (!isLoggedIn && !isLoggingIn) return '/login';

        // Se o usuário já está logado e tenta ir pra tela de Login -> Dashboard
        if (isLoggedIn && isLoggingIn) return '/dashboard';

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PanSys - Gestão Inteligente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD97736), // Laranja/Tostado rico
          primary: const Color(0xFFD97736),
          secondary: const Color(0xFF2B2D42),
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
