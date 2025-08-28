import 'package:flutter/material.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';


class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onSuffixIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: const TextStyle(
        //     fontSize: 14,
        //     fontWeight: FontWeight.w500,
        //     color: AppColors.primaryText,
        //   ),
        // ),
        // const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          cursorColor: AppColors.primary,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ), // Enhanced text style
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 15,
            ),
            prefixIcon: Icon(prefixIcon, color: AppColors.secondaryText),
            suffixIcon: suffixIcon != null
                ? InkWell(
                    onTap: onSuffixIconPressed,
                    child: Icon(suffixIcon, color: AppColors.secondaryText),
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textFieldBorder, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.textFieldBorder, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}