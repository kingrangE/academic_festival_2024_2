// lib/screens/home_screen.dart

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:seat_management_system/widgets/animated_away_time_indicator.dart';
import '../providers/user_provider.dart';
import '../widgets/reservation_card.dart';
import '../widgets/animated_percent_indicator.dart';
import '../widgets/custom_button.dart';
import 'package:seat_management_system/widgets/gps_check_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().startLocationTracking();
    });
  }

  bool hasReservation = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const buttonHeight = 56.0;
    const Duration currentAwayTime = Duration(minutes: 45);
    final user = context.watch<UserProvider>().user;

    if (user?.hasReservation ?? false) {
      hasReservation = true;
    } else {
      hasReservation = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seat Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFC31632),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFC31632),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFC31632),
              const Color(0xFFC31632).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Visibility(
                    visible: hasReservation,
                    child: Column(
                      children: [
                        const SizedBox(height: 16.0),
                        ReservationCard(
                          hasActiveReservation: true,
                          floor: user?.floor ?? '',
                          // null 일 경우 빈 문자열 반환
                          roomName: user?.roomType ?? '',
                          seatNumber: user?.seatNumber ?? '',
                          awayTime: Duration(minutes: user?.awayMinutes ?? 0),
                        ),
                      ],
                    )),
                const SizedBox(height: 24.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Expanded(
                        child: AnimatedPercentIndicator(
                          label: 'Personal\nSeats',
                          percent: 0.75,
                          color: Colors.white,
                          duration: Duration(seconds: 2),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      const Expanded(
                        child: AnimatedPercentIndicator(
                          label: 'Shared\nSeats',
                          percent: 0.85,
                          color: Colors.white,
                          duration: Duration(seconds: 2),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      Expanded(
                        child: AnimatedAwayTimeIndicator(
                          label: 'Away Time\n(Max 2h)',
                          color: Colors.white,
                          duration: const Duration(seconds: 2),
                          awayTime:Duration(minutes: user?.awayMinutes ?? 0 ) ,
                          maxTime: user?.customAwayDuration ?? const Duration(minutes: 30),
                          // awayTime:Duration(minutes: 30 ) ,
                          // maxTime: Duration(minutes: 120),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton(context, 'Select Seat', '/seatSelection',
                            size.width - 64, buttonHeight),
                        _buildButton(context, 'Return Seat', '/returnSeat',
                            size.width - 64, buttonHeight),
                        const GPSCheckButton(),
                        _buildButton(context, 'Settings', '/settings',
                            size.width - 64, buttonHeight),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, String route,
      double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomButton(
        text: label,
        onPressed: () => Navigator.pushNamed(context, route),
        backgroundColor: Colors.white,
        textColor: const Color(0xFFC31632),
        borderRadius: 12.0,
      ),
    );
  }
}
