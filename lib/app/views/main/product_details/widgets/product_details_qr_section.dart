import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsQRSection extends StatelessWidget {
  const ProductDetailsQRSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Center(
        child: Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // QR Code placeholder
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: CustomPaint(
                  painter: QRCodePainter(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1565C0)
      ..style = PaintingStyle.fill;

    final double cellSize = size.width / 8;
    
    // Draw QR code pattern
    final List<List<bool>> pattern = [
      [true, true, true, false, false, true, true, true],
      [true, false, true, false, false, true, false, true],
      [true, false, true, false, false, true, false, true],
      [false, false, false, true, true, false, false, false],
      [false, false, false, true, true, false, false, false],
      [true, false, true, false, false, true, false, true],
      [true, false, true, false, false, true, false, true],
      [true, true, true, false, false, true, true, true],
    ];

    for (int i = 0; i < pattern.length; i++) {
      for (int j = 0; j < pattern[i].length; j++) {
        if (pattern[i][j]) {
          canvas.drawRect(
            Rect.fromLTWH(
              j * cellSize,
              i * cellSize,
              cellSize,
              cellSize,
            ),
            paint,
          );
        }
      }
    }

    // Draw corner squares
    final cornerPaint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Top-left corner
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, cellSize * 3, cellSize * 3),
        Radius.circular(4.r),
      ),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cellSize * 5, 0, cellSize * 3, cellSize * 3),
        Radius.circular(4.r),
      ),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, cellSize * 5, cellSize * 3, cellSize * 3),
        Radius.circular(4.r),
      ),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
