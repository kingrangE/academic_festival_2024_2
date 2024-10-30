import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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
  Future<void> _checkGPS() async {
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
                child:
                Center(
                  child: Text(
                    _isLoading ? '위치 확인 중...' : 'GPS 수동 확인',
                    style: const TextStyle(
                      color: const Color(0xFFC31632),
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
              color: Colors.red[700],
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}