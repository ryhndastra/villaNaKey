import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:villanakey/components/bottom_bar.dart';

import '../providers/user_provider.dart';

class QrisNominalInputPage extends StatefulWidget {
  final int expectedAmount;
  final DateTime checkIn;
  final DateTime checkOut;
  final int harga;

  const QrisNominalInputPage({
    super.key,
    required this.expectedAmount,
    required this.checkIn,
    required this.checkOut,
    required this.harga,
  });

  @override
  State<QrisNominalInputPage> createState() => _QrisNominalInputPageState();
}

class _QrisNominalInputPageState extends State<QrisNominalInputPage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    final inputAmount = int.tryParse(
      _controller.text.replaceAll('.', '').replaceAll(',', ''),
    );
    if (inputAmount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nominal tidak valid.')));
      return;
    }

    if (inputAmount == widget.expectedAmount) {
      setState(() => _loading = true);

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      try {
        await FirebaseFirestore.instance.collection('reservations').add({
          'name': user?.name,
          'email': user?.email,
          'phone': user?.phone,
          'checkIn': widget.checkIn.toIso8601String(),
          'checkOut': widget.checkOut.toIso8601String(),
          'amount': widget.harga,
          'status': 'Pembayaran berhasil',
          'paymentMethod': 'Qris',
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
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nominal tidak sesuai!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final expectedFormatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(widget.expectedAmount);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Konfirmasi Pembayaran'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Tagihan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              expectedFormatted,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF819766),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Masukkan nominal yang Anda bayar:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Contoh: ${widget.expectedAmount}',
                      filled: true,
                      fillColor: const Color(0xFFF9F9F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF819766),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                      onPressed: _loading ? null : _submit,
                      child:
                          _loading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                              : const Text(
                                'KONFIRMASI PEMBAYARAN',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
