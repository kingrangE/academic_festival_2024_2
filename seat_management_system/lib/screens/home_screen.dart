// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../widgets/reservation_card.dart';
import '../screens/return_seat_screen.dart';
import '../widgets/animated_percent_indicator.dart';
import '../widgets/animated_away_time_indicator.dart';
import '../widgets/custom_button.dart';
import 'package:seat_management_system/widgets/gps_check_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const buttonHeight = 56.0;
    const Duration currentAwayTime = Duration(minutes: 45);
    const maxAwayTime = Duration(hours: 2);
    final awayTimePercent = currentAwayTime.inMinutes / maxAwayTime.inMinutes;

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
                const SizedBox(height: 16.0),
                const ReservationCard(
                  hasActiveReservation: true,
                  floor: '3',
                  roomName: '제1열람실',
                  seatNumber: '12',
                  awayTime: currentAwayTime,
                ),
                const SizedBox(height: 24.0),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
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
                          label: '개인좌석',
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
                          label: '공유좌석',
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
                          label: '부재시간',
                          awayTime: currentAwayTime,
                          maxTime: maxAwayTime,
                          color: Colors.white,
                          duration: const Duration(seconds: 2),
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
                        _buildButton(context, '좌석 선택', '/seatSelection',
                            size.width - 64, buttonHeight),
                        _buildButton(context, '좌석 반납', '/returnSeat',
                            size.width - 64, buttonHeight),
                        const GPSCheckButton(),
                        _buildButton(
                            context, '설정', '/settings', size.width - 64,
                            buttonHeight),
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
