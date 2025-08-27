import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/utils/routes/app_pages.dart';
import 'package:qr_code_inventory/app/widgets/primary_button.dart';


class PasswordChangedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green.shade100,
              child: Icon(Icons.check, color: Colors.green, size: 60),
            ),
            SizedBox(height: 32),
            Text(
              'Password Changed!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your password has been changed successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Spacer(),
            PrimaryButton(
              text: 'Back to Login',
              // Use offAllNamed to clear the navigation stack and go to login
              onPressed: () => Get.offAllNamed(Routes.LOGIN),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}