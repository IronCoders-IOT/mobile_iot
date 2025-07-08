import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_iot/analytics/presentation/tank_events_screen.dart';
import 'package:mobile_iot/analytics/presentation/water_supply_request_screen.dart';
import 'package:mobile_iot/iam/presentation/login_screen.dart';
import 'package:mobile_iot/analytics/presentation/dashboard_screen.dart';
import 'package:mobile_iot/profiles/presentation/profile_edition_screen.dart';
import 'package:mobile_iot/profiles/presentation/profile_screen.dart';
import 'package:mobile_iot/analytics/presentation/reports_screen.dart';
import 'package:mobile_iot/shared/helpers/splash_screen.dart';
import 'package:mobile_iot/analytics/presentation/report_creation_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';


void main() {
  runApp(const AquaConectaApp());
}

class AquaConectaApp extends StatefulWidget {
  const AquaConectaApp({Key? key}) : super(key: key);

  static AquaConectaAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<AquaConectaAppState>();

  @override
  State<AquaConectaApp> createState() => AquaConectaAppState();
}

class AquaConectaAppState extends State<AquaConectaApp> {
  Locale? _locale;

  static AquaConectaAppState? _instance;

  @override
  void initState() {
    super.initState();
    _instance = this;
  }

  @override
  void dispose() {
    if (_instance == this) {
      _instance = null;
    }
    super.dispose();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  static void changeLocale(Locale locale) {
    _instance?.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    // Configurar la barra de estado
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
        // Tema principal
        primarySwatch: MaterialColor(
          0xFF3498DB,
          <int, Color>{
            50: const Color(0xFFE3F2FD),
            100: const Color(0xFFBBDEFB),
            200: const Color(0xFF90CAF9),
            300: const Color(0xFF64B5F6),
            400: const Color(0xFF42A5F5),
            500: const Color(0xFF3498DB), // Color principal
            600: const Color(0xFF1E88E5),
            700: const Color(0xFF1976D2),
            800: const Color(0xFF1565C0),
            900: const Color(0xFF0D47A1),
          },
        ),
        
        // Configuración de colores
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

        // Configuración de fuentes
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

        // Configuración de AppBar
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

        // Configuración de botones elevados
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

        // Configuración de campos de texto
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

        // Configuración del Scaffold
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),

        // Configuración de SnackBar
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
      // Pantalla inicial
      home: const SplashScreen(),
      
      // Rutas nombradas
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const ProfileEditionScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/history': (context) => const TankEventsScreen(),
        '/request-history': (context) => const WaterSupplyRequestScreen(),
        '/create-report': (context) => const ReportCreationScreen(),
      },
      
      // Ruta por defecto cuando no se encuentra una ruta
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      },
    );
  }
}
