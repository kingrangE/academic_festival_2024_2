import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // 클래스 생성자가 정의되어 있는지 확인

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seat Management Home'),
          backgroundColor: const Color.fromRGBO(195, 22, 50, 1.0),
          foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/seatSelection');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(195, 22, 50, 1.0),
                foregroundColor: Colors.white,
                // 수정된 속성명
              ),
              child: const Text('Select Seat'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/gpsCheck');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(195, 22, 50, 1.0),
                foregroundColor: Colors.white,
                // 수정된 속성명
              ),
              child: const Text('GPS Check'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(195, 22, 50, 1.0),
                foregroundColor: Colors.white,
                // 수정된 속성명
              ),
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
