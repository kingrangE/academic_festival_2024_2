import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final EdgeInsets padding;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFC31632), // 기본 배경색: 세종대학교 색상
    this.textColor = Colors.white, // 기본 텍스트 색상: 흰색
    this.fontSize = 16.0,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // 배경색 설정
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius), // 둥근 모서리 설정
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor, // 텍스트 색상 설정
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
