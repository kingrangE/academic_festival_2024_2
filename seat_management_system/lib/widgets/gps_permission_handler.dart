import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GPSPermissionHandler extends StatefulWidget {
  final Widget child;

  const GPSPermissionHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<GPSPermissionHandler> createState() => _GPSPermissionHandlerState();
}

class _GPSPermissionHandlerState extends State<GPSPermissionHandler> {
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스 활성화 요청
      return Future.error('위치 서비스가 비활성화되어 있습니다.');
    }

    // 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 최초 권한 요청
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 권한이 거부되었습니다.');
      }
    }

    // 영구적으로 권한 거부됨
    if (permission == LocationPermission.deniedForever) {
      return Future.error('위치 권한이 영구적으로 거부되었습니다. 설정에서 변경해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}