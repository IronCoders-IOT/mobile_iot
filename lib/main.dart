import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_iot/analytics/presentation/tank_events_screen.dart';
import 'package:mobile_iot/analytics/presentation/water_supply_requests.dart';
import 'package:mobile_iot/iam/presentation/auth/login_screen.dart';
import 'package:mobile_iot/analytics/presentation/dashboard_screen.dart';
import 'package:mobile_iot/profiles/presentation/profile/profile_screen.dart';
import 'package:mobile_iot/analytics/presentation/reports_screen.dart';
import 'package:mobile_iot/iam/presentation/auth/splash_screen.dart';
import 'package:mobile_iot/analytics/presentation/report_creation_screen.dart';


void main() {
  runApp(const AquaConectaApp());
}

class AquaConectaApp extends StatelessWidget {
  const AquaConectaApp({Key? key}) : super(key: key);

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
      
      // Pantalla inicial
      home: const SplashScreen(),
      
      // Rutas nombradas (para navegación futura)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/history': (context) => const HistoryScreen(),
        '/request-history': (context) => const RequestHistoryScreen(),
        '/create-report': (context) => const CreateReportScreen(),
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

// Clase para mantener las rutas organizadas
class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String reports = '/reports';
  
  // Método helper para navegación
  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }
  
  static void navigateToDashboard(BuildContext context) {
    Navigator.pushReplacementNamed(context, dashboard);
  }
  
  static void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, profile);
  }
  
  static void navigateToReports(BuildContext context) {
    Navigator.pushNamed(context, reports);
  }
  
  static void navigateToEditProfile(BuildContext context) {
    Navigator.pushNamed(context, editProfile);
  }
}