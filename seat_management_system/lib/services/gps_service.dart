import 'package:geolocator/geolocator.dart';

class GpsService {
  // 열람실 중심 좌표와 반경을 상수로 정의
  static const double libraryLatitude = 37.555123;
  static const double libraryLongitude = 127.123456;
  static const double libraryRadius = 50; // 반경 50m

  // 사용자가 열람실 영역 내에 있는지 확인하는 메서드
  Future<bool> isUserInLibraryArea() async {
    // 위치 권한 확인
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 사용 가능 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 비활성화된 경우 처리
      return Future.error('Location services are disabled.');
    }

    // 위치 권한 상태 확인 및 요청
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 권한이 거부된 경우 처리
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 영구적으로 권한이 거부된 경우 처리
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 현재 위치와 열람실 좌표 사이의 거리 계산
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      libraryLatitude,
      libraryLongitude,
    );

    // 열람실 반경 내에 있는지 여부 반환
    return distance < libraryRadius;
  }
}
