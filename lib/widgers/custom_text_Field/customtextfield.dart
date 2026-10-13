import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? labelText;
  final String? hintText;
  final Color? textColor;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final double? prefixIconSize;
  final Color? prefixIconColor;
  final Widget? suffixIcon;
  final double? suffixIconSize;
  final Color? suffixIconColor;
  final VoidCallback? onSuffixTap;
  final String? suffixText;
  final TextStyle? suffixTextStyle;

  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;

  final bool isOptional;
  final bool isEmail;
  final bool isPassWord;
  final bool isPassWordSecondValidation;
  final TextEditingController? isPassWordSecondValidationController;

  final EdgeInsets? contentPadding;
  final double? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double? height;
  final double? width;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;

  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.textColor = const Color(0xFF222222),
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.prefixIconSize,
    this.prefixIconColor = const Color(0xFF8E8E93),
    this.suffixIcon,
    this.suffixIconSize,
    this.suffixIconColor = const Color(0xFF8E8E93),
    this.onSuffixTap,
    this.suffixText,
    this.suffixTextStyle,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.isOptional = false,
    this.isEmail = false,
    this.isPassWord = false,
    this.isPassWordSecondValidation = false,
    this.isPassWordSecondValidationController,
    this.contentPadding,
    this.borderRadius = 25,
    this.fillColor = ConstColor.fieldBg,
    this.borderColor = Colors.transparent,
    this.focusedBorderColor = ConstColor.primaryTeal,
    this.errorBorderColor,
    this.height,
    this.width,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
  });

  bool isValidEmail(String? email) {
    if (email == null) return false;
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        inputFormatters: maxLength != null
            ? [LengthLimitingTextInputFormatter(maxLength)]
            : null,
        style: TextStyle(
          fontSize: 15.sp,
          color: textColor,
          fontFamily: 'SFPro',
        ),
        validator: validator ??
            (value) {
              if (isOptional) return null;
              if (value == null || value.trim().isEmpty) {
                return "This field is required";
              }
              if (isEmail) {
                if (isValidEmail(value.trim())) return null;
                return "Please provide a valid email address";
              }
              if (isPassWord && isPassWordSecondValidation) {
                final originalPass = isPassWordSecondValidationController?.text;
                if (originalPass != null && value != originalPass) {
                  return "Passwords do not match";
                }
              }
              if (isPassWord && value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: labelStyle ??
              TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 14.sp,
              ),
          floatingLabelStyle: TextStyle(
            color: focusedBorderColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          hintText: hintText,
          hintStyle: hintStyle ??
              TextStyle(
                color: const Color(0xFFA2A2A8),
                fontSize: 14.sp,
                fontFamily: "SFPro",
              ),
          helperText: helperText,
          errorText: errorText,
          errorStyle: errorStyle ?? TextStyle(color: theme.colorScheme.error),
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          filled: true,
          fillColor: fillColor,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 10.w),
                  child: prefixIcon,
                )
              : null,
          prefixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 24.h,
          ),
          suffixIcon: (suffixIcon != null || suffixText != null)
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (suffixIcon != null) suffixIcon!,
                        if (suffixText != null)
                          Text(
                            suffixText!,
                            style: suffixTextStyle ??
                                TextStyle(
                                  color: const Color(0xFF8E8E93),
                                  fontSize: 14.sp,
                                  fontFamily: "SFPro",
                                ),
                          ),
                      ],
                    ),
                  ),
                )
              : null,
          suffixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 24.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(
              color: borderColor!,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(
              color: borderColor!,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(
              color: focusedBorderColor!,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(
              color: errorBorderColor ?? theme.colorScheme.error,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
            borderSide: BorderSide(
              color: errorBorderColor ?? theme.colorScheme.error,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
