
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_iot/monitoring/presentation/tank_events_screen.dart';
import 'package:mobile_iot/analytics/presentation/water_supply_request_screen.dart';
import 'package:mobile_iot/iam/presentation/login_screen.dart';
import 'package:mobile_iot/analytics/presentation/dashboard_screen.dart';
import 'package:mobile_iot/profiles/presentation/profile_edition_screen.dart';
import 'package:mobile_iot/profiles/presentation/profile_screen.dart';
import 'package:mobile_iot/analytics/presentation/reports_screen.dart';
import 'package:mobile_iot/shared/helpers/splash_screen.dart';
import 'package:mobile_iot/analytics/presentation/report_creation_screen.dart';
import 'iam/presentation/bloc/login_bloc.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_iot/iam/application/sign_in_use_case.dart';
import 'package:mobile_iot/iam/infrastructure/repositories/auth_repository_impl.dart';
import 'package:mobile_iot/iam/infrastructure/service/auth_api_service.dart';
import 'package:mobile_iot/shared/helpers/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This file initializes the Flutter app, sets up localization, theme, and routing.
/// It defines the [AquaConectaApp] widget, which manages the app's locale, theme,
/// and navigation structure. The app uses BLoC for authentication and supports
/// multiple screens, including dashboard, reports, profile, and more.
///
void main() {
  runApp(const AquaConectaApp());
}

/// Creates the main application widget for AquaConecta.
///
/// This widget manages the app's state, including locale and navigation.
class AquaConectaApp extends StatefulWidget {
  /// Provides access to the [AquaConectaAppState] from a [BuildContext].
  static AquaConectaAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<AquaConectaAppState>();

  /// Creates the main application widget for AquaConecta.
  const AquaConectaApp({Key? key}) : super(key: key);

  @override
  State<AquaConectaApp> createState() => AquaConectaAppState();
}

/// State class for [AquaConectaApp].
///
/// Handles locale management, theme configuration, and routing.
class AquaConectaAppState extends State<AquaConectaApp> {
  Locale? _locale;

  static AquaConectaAppState? _instance;

  @override
  void initState() {
    super.initState();
    _instance = this;
    _loadSavedLocale();
  }

  /// Loads the saved locale from persistent storage (SharedPreferences).
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale');
    if (savedLocale != null) {
      setState(() {
        _locale = Locale(savedLocale);
      });
    }
  }

  @override
  void dispose() {
    if (_instance == this) {
      _instance = null;
    }
    super.dispose();
  }

  /// Sets the app's locale and saves it to persistent storage.
  void setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  /// Changes the app's locale from anywhere in the widget tree.
  static void changeLocale(Locale locale) {
    _instance?.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    // Configure the system status bar appearance
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'AquaConecta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Main theme configuration
        primarySwatch: MaterialColor(
          0xFF3498DB,
          <int, Color>{
            50: const Color(0xFFE3F2FD),
            100: const Color(0xFFBBDEFB),
            200: const Color(0xFF90CAF9),
            300: const Color(0xFF64B5F6),
            400: const Color(0xFF42A5F5),
            500: const Color(0xFF3498DB), // Primary color
            600: const Color(0xFF1E88E5),
            700: const Color(0xFF1976D2),
            800: const Color(0xFF1565C0),
            900: const Color(0xFF0D47A1),
          },
        ),
        
        // Color configuration
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3498DB),
          secondary: Color(0xFF2C3E50),
          background: Color(0xFFF8F9FA),
          surface: Color(0xFFFFFFFF),
          onPrimary: Color(0xFFFFFFFF),
          onSecondary: Color(0xFFFFFFFF),
          onBackground: Color(0xFF2C3E50),
          onSurface: Color(0xFF2C3E50),
        ),

        // Font configuration
        fontFamily: 'System',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF2C3E50),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF6C757D),
          ),
        ),

        // AppBar configuration
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3498DB),
          foregroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
          ),
        ),

        // ElevatedButton configuration
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3498DB),
            foregroundColor: const Color(0xFFFFFFFF),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // TextField configuration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF3498DB),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF3498DB),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF3498DB),
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF6C757D),
            fontSize: 16,
          ),
        ),

        // Scaffold configuration
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),

        // SnackBar configuration
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF3498DB),
          contentTextStyle: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      // Initial screen
      home: const SplashScreen(),
      
      // Named routes
      routes: {
        '/login': (context) => BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(
            signInUseCase: SignInUseCase(AuthRepositoryImpl(AuthApiService())),
            secureStorage: SecureStorageService(),
          ),
          child: const LoginScreen(),
        ),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const ProfileEditionScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/history': (context) => const TankEventsScreen(),
        '/request-history': (context) => const WaterSupplyRequestScreen(),
        '/create-report': (context) => const ReportCreationScreen(),
      },
      
      // Default route when a route is not found
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(
              signInUseCase: SignInUseCase(AuthRepositoryImpl(AuthApiService())),
              secureStorage: SecureStorageService(),
            ),
            child: const LoginScreen(),
          ),
        );
      },
    );
  }
}
