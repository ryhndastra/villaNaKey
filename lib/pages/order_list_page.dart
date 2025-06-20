import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'order_detail_page.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final UserModel? user = userProvider.user;

    if (user == null) {
      return const Center(child: Text('Silakan login terlebih dahulu.'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reservasi Saya'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('reservations')
                .where('email', isEqualTo: user.email)
                .orderBy('paymentTime', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada reservasi.'));
          }

          final reservations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final data = reservations[index];
              final checkIn = DateTime.tryParse(data['checkIn'] ?? '');
              final checkOut = DateTime.tryParse(data['checkOut'] ?? '');
              final amount = data['amount'] ?? 0;

              final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
              final checkInStr =
                  checkIn != null
                      ? dateFormat.format(checkIn)
                      : 'Tanggal tidak valid';
              final checkOutStr =
                  checkOut != null
                      ? dateFormat.format(checkOut)
                      : 'Tanggal tidak valid';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    '$checkInStr - $checkOutStr',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Total: Rp ${NumberFormat('#,###', 'id_ID').format(amount)}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => OrderDetailPage(
                              reservationId: reservations[index].id,
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
