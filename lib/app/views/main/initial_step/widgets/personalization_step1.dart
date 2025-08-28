import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_inventory/app/widgets/custom_textfeild.dart';

class PersonalizationStep1 extends StatelessWidget {
  const PersonalizationStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Hi there, \n What should we call you?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w400)),
                    SizedBox(height: 10.h),
                    CustomTextField(label: '', hint: 'Enter your nickname',
                    controller: TextEditingController(), prefixIcon: Icons.person),
                    SizedBox(height: 10.h),
                    CustomTextField(label: '', hint: 'Enter your nickname',
                    controller: TextEditingController(), prefixIcon: Icons.email_outlined),
      ],
    );
  }
}
