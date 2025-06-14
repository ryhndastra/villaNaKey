import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qris_nominal_input_page.dart';

class QrisScannerPage extends StatefulWidget {
  final int expectedAmount;
  final DateTime checkIn;
  final DateTime checkOut;
  final int harga;

  const QrisScannerPage({
    super.key,
    required this.expectedAmount,
    required this.checkIn,
    required this.checkOut,
    required this.harga,
  });

  @override
  State<QrisScannerPage> createState() => _QrisScannerPageState();
}

class _QrisScannerPageState extends State<QrisScannerPage> {
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canLeave = await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Keluar Scan?'),
                content: const Text('Apakah kamu yakin ingin kembali?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Tidak'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Ya'),
                  ),
                ],
              ),
        );
        return canLeave;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Scan QR'), centerTitle: true),
        body: MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.normal,
          ),
          onDetect: (capture) {
            if (_isScanned) return;

            final barcode = capture.barcodes.first;
            final code = barcode.rawValue;

            if (code == null) return;

            if (code.startsWith('https://example.com/payment')) {
              _isScanned = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => QrisNominalInputPage(
                        expectedAmount: widget.expectedAmount,
                        checkIn: widget.checkIn,
                        checkOut: widget.checkOut,
                        harga: widget.harga,
                      ),
                ),
              ).then((value) {
                setState(() {
                  _isScanned = false;
                });
              });
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('QR tidak valid.')));
            }
          },
        ),
      ),
    );
  }
}
