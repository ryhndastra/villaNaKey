import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:villanakey/pages/qr_scanner_page.dart';

class QrisPaymentPage extends StatelessWidget {
  final int amountToPay;
  final DateTime? checkIn;
  final DateTime? checkOut;

  const QrisPaymentPage({
    super.key,
    required this.amountToPay,
    this.checkIn,
    this.checkOut,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = NumberFormat('#,###', 'id_ID').format(amountToPay);
    final qrData =
        'https://example.com/payment?id=TXN${DateTime.now().millisecondsSinceEpoch}';

    final formattedCheckIn = _formatDate(checkIn);
    final formattedCheckOut = _formatDate(checkOut);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Pembayaran QRIS'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Booking: Check-in $formattedCheckIn - Check-out $formattedCheckOut',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              'Silakan scan kode QR di bawah ini untuk melanjutkan pembayaran.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rp $formattedAmount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF819766),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF819766),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => QrisScannerPage(
                            expectedAmount: amountToPay,
                            checkIn: checkIn!,
                            checkOut: checkOut!,
                            harga: amountToPay,
                          ),
                    ),
                  );
                },
                child: const Text(
                  'BAYAR SEKARANG',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
