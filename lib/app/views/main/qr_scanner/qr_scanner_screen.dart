import 'dart:convert';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  dynamic scannedData;

  @override
  Widget build(BuildContext context) {
    return AiBarcodeScanner(
      onDetect: (data) async {
        setState(() {
          scannedData = data;
          final decodedData = jsonDecode(scannedData);
          scannedData = decodedData['displayValue'];
        });
        // Handle the detected QR code data
        print('Detected QR Code: $scannedData');
      },

      onDetectError: (context, error) {
        // Handle detection errors
        print('Error detecting QR Code: $error');
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 0.75),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  scannedData != null
                      ? 'Scanned Data: $scannedData'
                      : 'Scanning for QR Code...',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
