// lib/screens/return_seat_screen.dart
import 'package:flutter/material.dart';
import 'dart:async'; // 타이머를 사용하기 위해 필요

class ReturnSeatScreen extends StatefulWidget {
  const ReturnSeatScreen({super.key});

  @override
  _ReturnSeatScreenState createState() => _ReturnSeatScreenState();
}

class _ReturnSeatScreenState extends State<ReturnSeatScreen>
    with SingleTickerProviderStateMixin {
  bool isReturning = false;
  bool isCompleted = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int remainingSeconds = 3; // 카운트다운을 위한 상태 변수

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleReturn() async {
    setState(() {
      isReturning = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isReturning = false;
      isCompleted = true;
    });

    // 카운트다운 타이머 시작
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 1) {
          remainingSeconds--;
        } else {
          timer.cancel();
          if (mounted) {
            // 홈화면으로 돌아가면서 스택을 초기화
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // '<' 아이콘 모양 사용
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Return Seat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFC31632),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFC31632),
      body: Container(
        height: size.height,
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
        child: SingleChildScrollView(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: size.width - 40,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '현재 예약 정보',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC31632),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('층:', style: TextStyle(fontSize: 16)),
                              Text('3층',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('열람실:', style: TextStyle(fontSize: 16)),
                              Text('제1열람실',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('좌석 번호:', style: TextStyle(fontSize: 16)),
                              Text('12',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 30),
                          if (!isCompleted)
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: isReturning ? null : _handleReturn,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFFC31632),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isReturning
                                    ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                                    : const Text(
                                  '좌석 반납하기',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (isCompleted)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: size.width - 40,
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                '좌석 반납이 완료되었습니다',
                                style: TextStyle(
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
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
