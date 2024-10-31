import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class GPSCheckButton extends StatefulWidget {
  final Function(Position)? onLocationObtained;

  const GPSCheckButton({super.key, this.onLocationObtained});

  @override
  _GPSCheckButtonState createState() => _GPSCheckButtonState();
}

class _GPSCheckButtonState extends State<GPSCheckButton> {
  bool _isLoading = false;
  String? _error;
  final buttonHeight = 56.0;

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

  Future<void> _checkGPS() async {
    print("GPS 검사");
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw '위치 권한이 거부되었습니다';
        }
      }

      // GPS 활성화 확인
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'GPS를 활성화해주세요';
      }

      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 위치 확인 및 상태 업데이트
      final userProvider = context.read<UserProvider>();
      bool isInside = isInValidLocation(position);

      if (isInside) {
        userProvider.stopAwayTracking();
        setState(() {
          _error = '지정된 위치 내에 있습니다.';
        });
        print("지정된 위치에 있습니다.");
      } else {
        userProvider.startAwayTracking();
        setState(() {
          _error = '지정된 위치를 벗어났습니다.';
        });
        print("지정된 위치에 없습니다.");
      }

      if (widget.onLocationObtained != null) {
        widget.onLocationObtained!(position);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size.width - 64,
          height: buttonHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading ? null : _checkGPS,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Center(
                  child: _isLoading
                      ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFC31632),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '위치 확인 중...',
                        style: TextStyle(
                          color: Color(0xFFC31632),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                      : const Text(
                    'GPS 수동 확인',
                    style: TextStyle(
                      color: Color(0xFFC31632),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(
            _error!,
            style: TextStyle(
              color: _error!.contains('내에 있습니다') ? Colors.green : Colors.red[700],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}