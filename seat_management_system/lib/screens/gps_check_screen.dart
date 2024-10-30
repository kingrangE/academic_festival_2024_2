import 'package:flutter/material.dart';
import '../services/gps_service.dart'; // gps_service import

class GpsCheckScreen extends StatefulWidget {
  const GpsCheckScreen({super.key});

  @override
  _GpsCheckScreenState createState() => _GpsCheckScreenState();
}

class _GpsCheckScreenState extends State<GpsCheckScreen> {
  final GpsService _gpsService = GpsService();
  bool _isInLibrary = false;

  Future<void> _checkUserLocation() async {
    bool isInLibrary = await _gpsService.isUserInLibraryArea();
    setState(() {
      _isInLibrary = isInLibrary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS Seat Check'),
        backgroundColor: const Color(0xFF990000),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isInLibrary ? 'You are in the library area' : 'You are outside the library area',
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: _checkUserLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF990000), // 수정된 부분
              ),
              child: const Text('Check My Location'),
            ),
          ],
        ),
      ),
    );
  }
}
