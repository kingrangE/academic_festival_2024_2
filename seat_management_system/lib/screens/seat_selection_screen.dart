import 'package:flutter/material.dart';
import 'dart:async'; // 타이머를 사용하기 위해 필요
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen>
    with TickerProviderStateMixin {
  String? selectedFloor;
  String? selectedType;
  String? selectedSeat;
  String? reservationMessage;

  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _reservationController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _reservationAnimation;

  final List<String> floors = ['1', '2', '3', '4'];
  final List<String> seatTypes = ['shared', 'individual'];

  int remainingSeconds = 3; // 카운트다운 상태 변수

  @override
  void initState() {
    super.initState();

    // 슬라이드 애니메이션 설정
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // 스케일 애니메이션 설정
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    );

    // 예약 완료 애니메이션 설정
    _reservationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _reservationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _reservationController,
      curve: Curves.elasticOut,
    ));

    // 초기 애니메이션 실행
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _reservationController.dispose();
    super.dispose();
  }

  void _animateSelection() {
    _scaleController.reset();
    _scaleController.forward();
  }

  void _animateReservation() {
    _reservationController.reset();
    _reservationController.forward();
    _startCountdown(); // 카운트다운 시작
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 1) {
          remainingSeconds--;
        } else {
          timer.cancel();
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Seat',
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
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMainCard(),
                const SizedBox(height: 20),
                if (selectedFloor != null && selectedType != null)
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: _buildSelectionCard(),
                  ),
                const Spacer(),
                if (reservationMessage != null)
                  ScaleTransition(
                    scale: _reservationAnimation,
                    child: _buildReservationCard(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Hero(
      tag: 'seat_selection_card',
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Color(0xFFC31632), Color(0xFF990000)],
                  ).createShader(bounds);
                },
                child: const Text(
                  '좌석 선택',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildAnimatedDropdown(
                value: selectedFloor,
                items: floors,
                label: '층수 선택',
                hint: '층을 선택하세요',
                onChanged: (value) {
                  setState(() {
                    selectedFloor = value;
                    _animateSelection();
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildAnimatedDropdown(
                value: selectedType,
                items: seatTypes,
                label: '좌석 유형',
                hint: '좌석 유형을 선택하세요',
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                    _animateSelection();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: animationValue,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              value: value,
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item == 'shared'
                        ? '공용 좌석'
                        : item == 'individual'
                            ? '개인 좌석'
                            : '$item층',
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            const Text(
              '선택 정보',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC31632),
              ),
            ),
            const SizedBox(height: 12),
            Text('층: $selectedFloor층'),
            Text('유형: ${selectedType == 'shared' ? '공용 좌석' : '개인 좌석'}'),
            const SizedBox(height: 16),
            _buildSelectButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
            scale: value,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFC31632),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              onPressed: () {
                final seatNumber = '${DateTime.now().millisecond % 100 + 1}';
                setState(() {
                  _animateReservation();
                  selectedSeat = seatNumber;
                  reservationMessage =
                      '$selectedFloor층 ${selectedType!.toUpperCase()} 좌석 $seatNumber번 예약 완료';
                  context.read<UserProvider>().updateReservation(
                        floor: selectedFloor!,
                        roomType: selectedType!,
                        seatNumber: seatNumber,
                      );
                });
              },
              child: const Text(
                '좌석 선택하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ));
      },
    );
  }

  Widget _buildReservationCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Column(
                    children: [
                      Text(
                        reservationMessage!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC31632),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$remainingSeconds초 후 홈 화면으로 이동합니다',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
