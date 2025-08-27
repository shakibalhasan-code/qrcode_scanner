import 'package:flutter/material.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';

class PasswordRequirement extends StatelessWidget {
  final String text;
  const PasswordRequirement({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.check, color: AppColors.success, size: 18),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(color: AppColors.secondaryText, fontSize: 13)),
        ],
      ),
    );
  }
}
