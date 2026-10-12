import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  final double height;
  final double width;

  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final TextStyle? textStyle;

  final List<Color>? gradientColors;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;

  final bool hasBorder;
  final Color? borderColor;
  final double borderWidth;

  final List<Color>? borderGradientColors;
  final AlignmentGeometry borderGradientBegin;
  final AlignmentGeometry borderGradientEnd;

  final Widget? icon;
  final double iconSize;
  final double iconSpacing;

  final double fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;

  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.height = 52,
    this.width = double.infinity,
    this.backgroundColor = ConstColor.primaryTeal,
    this.textColor = ConstColor.white,
    this.borderRadius = 16,
    this.textStyle,
    this.gradientColors,
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
    this.hasBorder = false,
    this.borderColor,
    this.borderWidth = 1.5,
    this.borderGradientColors,
    this.borderGradientBegin = Alignment.centerLeft,
    this.borderGradientEnd = Alignment.centerRight,
    this.icon,
    this.iconSize = 24,
    this.iconSpacing = 10,
    this.fontSize = 18,
    this.fontWeight = FontWeight.bold,
    this.padding = EdgeInsets.zero,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool useGradientBorder =
        hasBorder && borderGradientColors != null && borderGradientColors!.isNotEmpty;

    final Color effectiveBgColor = (gradientColors != null && gradientColors!.isNotEmpty)
        ? gradientColors!.first
        : backgroundColor;

    if (isLoading) {
      final Color baseShimmerColor = effectiveBgColor;
      final Color highlightShimmerColor = (effectiveBgColor == Colors.white)
          ? Colors.grey.shade200
          : Color.alphaBlend(Colors.white.withAlpha(100), effectiveBgColor);

      return Padding(
        padding: padding!,
        child: Shimmer.fromColors(
          baseColor: baseShimmerColor,
          highlightColor: highlightShimmerColor,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: effectiveBgColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      );
    }

    final Widget innerContent = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: gradientColors == null ? backgroundColor : null,
        gradient: gradientColors != null
            ? LinearGradient(
                colors: gradientColors!,
                begin: gradientBegin,
                end: gradientEnd,
              )
            : null,
        borderRadius: BorderRadius.circular(
          useGradientBorder ? borderRadius - borderWidth : borderRadius,
        ),
        border: hasBorder && !useGradientBorder
            ? Border.all(
                color: borderColor ?? backgroundColor,
                width: borderWidth,
              )
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (icon != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: icon,
                ),
              ),
            ),
          Center(
            child: Text(
              text,
              style: textStyle ??
                  TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    fontFamily: "SFPro",
                  ),
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding!,
        child: useGradientBorder
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    colors: borderGradientColors!,
                    begin: borderGradientBegin,
                    end: borderGradientEnd,
                  ),
                ),
                padding: EdgeInsets.all(borderWidth),
                child: innerContent,
              )
            : innerContent,
      ),
    );
  }
}
