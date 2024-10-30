import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  Timer? _awayTimer;
  Timer? _locationTimer;
  bool _isInside = true;

  User? get user => _user;
  bool get isInside => _isInside;

  void startLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition();
        bool currentlyInside = isInValidLocation(position);

        if (currentlyInside != _isInside) {
          _isInside = currentlyInside;
          if (!_isInside) {
            startAwayTracking();
          } else {
            stopAwayTracking();
          }
          notifyListeners();
        }
      } catch (e) {
        print('Location check error: $e');
      }
    });
  }

  void stopLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  bool isInValidLocation(Position position) {
    const double targetLat = 37.551646;
    const double targetLng = 127.074346;
    const double allowedDistance = 60;

    double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        targetLat,
        targetLng
    );

    return distance <= allowedDistance;
  }

  void startAwayTracking() {
    _awayTimer?.cancel();
    _awayTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_user != null && _user!.hasReservation) {
        _user!.incrementAwayTime();
        if (_user!.checkAndUpdateAwayStatus()) {
          clearReservation();
        }
        notifyListeners();
      }
    });
  }

  void stopAwayTracking() {
    _awayTimer?.cancel();
    _user?.resetAwayTime();
    notifyListeners();
  }

  void setCustomAwayDuration(Duration duration) {
    _user?.setCustomAwayDuration(duration);
    notifyListeners();
  }
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void updateReservation({
    required String floor,
    required String roomType,
    required String seatNumber,
  }) {
    _user?.reserveSeat(
      floor: floor,
      roomType: roomType,
      seatNumber: seatNumber,
    );
    notifyListeners();
  }

  void clearReservation() {
    _user?.cancelReservation();
    notifyListeners();
  }

  void setAwayStatus(Duration duration) {
    _user?.setCustomAwayDuration(duration);
    notifyListeners();
  }

  void clearAwayStatus() {
    _user?.resetAwayTime();
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _awayTimer?.cancel();
    _locationTimer?.cancel();
    super.dispose();
  }
}