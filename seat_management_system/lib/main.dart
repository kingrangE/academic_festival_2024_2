import 'package:flutter/material.dart';
import 'package:seat_management_system/widgets/gps_permission_handler.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/return_seat_screen.dart';
import 'screens/seat_selection_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/gps_check_screen.dart';

void main() {
  runApp(const GPSPermissionHandler(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seat Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC31632),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFC31632),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC31632),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _buildPageRoute(const SplashScreen(), settings);
          case '/login':
            return _buildPageRoute(const LoginScreen(), settings);
          case '/home':
            return _buildPageRoute(const HomeScreen(), settings);
          case '/seatSelection':
            return _buildPageRoute(const SeatSelectionScreen(), settings);
          case '/settings':
            return _buildPageRoute(const SettingsScreen(), settings);
          case '/gpsCheck':
            return _buildPageRoute(const GpsCheckScreen(), settings);
          case '/returnSeat':
            return _buildPageRoute(const ReturnSeatScreen(), settings);
          default:
            return null;
        }
      },
    );
  }

  PageRoute _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var slideAnimation = Tween(
          begin: begin,
          end: end,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        var fadeAnimation = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        ));

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}

// Extension for consistent app colors
extension AppColors on BuildContext {
  Color get primaryColor => const Color(0xFFC31632);
  Color get primaryLightColor => const Color(0xFFF8D7DA);
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
}

// Extension for consistent text styles
extension AppTextStyles on BuildContext {
  TextStyle get headlineStyle => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFFC31632),
  );

  TextStyle get titleStyle => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  TextStyle get bodyStyle => const TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
}