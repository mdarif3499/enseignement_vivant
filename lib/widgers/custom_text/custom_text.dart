import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String title;
  final Color textColor;
  final FontWeight? fontWeight;
  final double textSize;
  final double top;
  final double right;
  final double left;
  final double bottom;
  final TextAlign textAlign;
  final int maxLine;
  final double? textHeight;
  final bool underline;
  final Color? underlineColor;
  final double underlineThickness;
  final FontStyle? fontStyle;

  const CustomText({
    super.key,
    required this.title,
    this.textColor = const Color(0xFF363636),
    this.fontWeight,
    this.textSize = 14,
    this.top = 0,
    this.right = 0,
    this.left = 0,
    this.bottom = 0,
    this.textAlign = TextAlign.left,
    this.maxLine = 2,
    this.textHeight,
    this.underline = false,
    this.underlineColor,
    this.underlineThickness = 1.0,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
      ),
      child: Text(
        title,
        textAlign: textAlign,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          height: textHeight,
          fontFamily: 'SFPro',
          fontSize: textSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle ?? FontStyle.normal,
          color: textColor,
          decoration: underline ? TextDecoration.underline : TextDecoration.none,
          decorationColor: underlineColor ?? textColor,
          decorationThickness: underlineThickness,
        ),
      ),
    );
  }
}
