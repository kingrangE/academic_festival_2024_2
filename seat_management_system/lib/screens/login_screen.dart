import 'package:flutter/material.dart';
import 'home_screen.dart'; // 로그인 성공 시 이동할 화면 import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // 간단한 인증 로직 (서버 연동 또는 데이터베이스와의 연동 필요)
    final studentId = _studentIdController.text;
    final password = _passwordController.text;

    if (studentId == '21011702' && password == '10141116') {
      // 학번과 비밀번호가 일치할 경우 메인 화면으로 이동 일단 내 생일 !
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // 인증 실패 시 경고 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Student ID or Password'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color.fromRGBO(195, 22, 50, 1.0),
        foregroundColor: Colors.white,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _studentIdController,
              decoration: const InputDecoration(
                labelText: 'Student ID',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(195, 22, 50, 1.0),
                foregroundColor: Colors.white, // Login 텍스트 색상 화이트로 설정
                textStyle: const TextStyle(
                  fontSize: 16.0, //텍스트 크기 설정 (필요 시)
                )
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
