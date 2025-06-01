import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:villanakey/components/bottom_bar.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';

class BcaPaymentPage extends StatefulWidget {
  final int amountToPay;
  final DateTime? checkIn;
  final DateTime? checkOut;

  const BcaPaymentPage({
    super.key,
    required this.amountToPay,
    this.checkIn,
    this.checkOut,
  });

  @override
  State<BcaPaymentPage> createState() => _BcaPaymentPageState();
}

class _BcaPaymentPageState extends State<BcaPaymentPage> {
  bool _loading = false;

  final String rekening = '4600351864';

  Future<void> _onSudahBayarPressed() async {
    setState(() => _loading = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel? user = userProvider.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data user tidak ditemukan, silakan login terlebih dahulu.',
          ),
        ),
      );
      setState(() => _loading = false);
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('reservations').add({
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'checkIn': widget.checkIn?.toIso8601String() ?? '',
        'checkOut': widget.checkOut?.toIso8601String() ?? '',
        'amount': widget.amountToPay,
        'status': 'Pembayaran berhasil',
        'paymentMethod': 'Transfer BCA',
        'paymentTime': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Pembayaran berhasil!')));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CustomBottomBar(initialIndex: 0),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(widget.amountToPay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panduan Transfer'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total yang harus dibayar:',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              formattedAmount,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF819766),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Instruksi Transfer:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              '1. Buka aplikasi m-BCA atau ATM BCA\n'
              '2. Pilih menu Transfer > ke Rek BCA\n'
              '3. Masukkan nomor rekening tujuan berikut:',
              style: TextStyle(fontSize: 16),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F0FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                rekening,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF819766),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Text(
              '4. Masukkan jumlah transfer sesuai total pembayaran\n'
              '5. Selesaikan pembayaran\n',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF819766),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _loading ? null : _onSudahBayarPressed,
                child:
                    _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'KONFIRMASI PEMBAYARAN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
