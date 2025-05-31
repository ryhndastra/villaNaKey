import 'package:flutter/material.dart';
import 'bca_payment_page.dart';
import 'package:villanakey/pages/qris_payment_page.dart';

enum PaymentMethod { bankTransferBCA, qris }

class PaymentPage extends StatefulWidget {
  final int amountToPay;
  final DateTime? checkIn;
  final DateTime? checkOut;

  const PaymentPage({
    super.key,
    required this.amountToPay,
    this.checkIn,
    this.checkOut,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PaymentMethod selectedMethod = PaymentMethod.bankTransferBCA;

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  void _navigateToPaymentPage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(milliseconds: 600));
    Navigator.pop(context); // tutup loading dialog

    if (selectedMethod == PaymentMethod.bankTransferBCA) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => BcaPaymentPage(
                amountToPay: widget.amountToPay,
                checkIn: widget.checkIn,
                checkOut: widget.checkOut,
              ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => QrisPaymentPage(
                amountToPay: widget.amountToPay,
                checkIn: widget.checkIn,
                checkOut: widget.checkOut,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedCheckIn = _formatDate(widget.checkIn);
    final formattedCheckOut = _formatDate(widget.checkOut);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Payment Method'),
        centerTitle: true,
        leading: const BackButton(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      "Booking Dates",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Check-in: $formattedCheckIn\nCheck-out: $formattedCheckOut",
                    ),
                  ),
                  const Divider(),
                  ExpansionTile(
                    title: Row(
                      children: [
                        Image.asset('assets/icons/trx.png', width: 24),
                        const SizedBox(width: 8),
                        const Text('Transfer Bank'),
                      ],
                    ),
                    children: [
                      RadioListTile<PaymentMethod>(
                        value: PaymentMethod.bankTransferBCA,
                        groupValue: selectedMethod,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedMethod = value);
                          }
                        },
                        title: Row(
                          children: [
                            Image.asset('assets/icons/BCA.png', width: 24),
                            const SizedBox(width: 8),
                            const Text('Bank BCA'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  PaymentOptionTile(
                    label: 'QRIS Payment',
                    iconPath: 'assets/icons/QRIS.png',
                    selected: selectedMethod == PaymentMethod.qris,
                    onTap: () {
                      setState(() => selectedMethod = PaymentMethod.qris);
                    },
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF819766),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _navigateToPaymentPage,
                child: const Text(
                  'CONFIRM',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentOptionTile extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool selected;
  final VoidCallback onTap;

  const PaymentOptionTile({
    super.key,
    required this.label,
    required this.iconPath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(iconPath, width: 24),
      title: Text(label),
      trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
    );
  }
}
