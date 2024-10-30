import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seat_management_system/providers/user_provider.dart';
import 'package:seat_management_system/widgets/gps_permission_handler.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/seat_selection_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/gps_check_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const GPSPermissionHandler(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seat Management System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF990000)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/seatSelection': (context) => const SeatSelectionScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/gpsCheck': (context) => const GpsCheckScreen(),
      },
    );
  }
}
