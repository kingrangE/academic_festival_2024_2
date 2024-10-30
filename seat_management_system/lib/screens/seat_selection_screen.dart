import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatelessWidget {
  const SeatSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Seat'),
          backgroundColor: const Color.fromRGBO(195, 22, 50, 1.0),
          foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Choose an available seat below:',
              style: TextStyle(fontSize: 20),
            ),
            // 좌석 선택 관련 위젯들 추가
          ],
        ),
      ),
    );
  }
}
