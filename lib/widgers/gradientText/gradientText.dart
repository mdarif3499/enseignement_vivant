import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const GradientText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFFB900), Color(0xFFFF6900)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          fontFamily: 'SFPro',
          color: Colors.white,
        ),
      ),
    );
  }
}
