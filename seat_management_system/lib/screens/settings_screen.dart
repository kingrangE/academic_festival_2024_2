import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF990000),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Set Maximum Seat Absence Time',
              style: TextStyle(fontSize: 20),
            ),
            // 자리 비움 시간 설정 관련 위젯 추가
          ],
        ),
      ),
    );
  }
}
