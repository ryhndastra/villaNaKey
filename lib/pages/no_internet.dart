import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:villanakey/main.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  Future<bool> _checkActualConnection() async {
    try {
      final result = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 3));
      return result.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> _handleRetry(BuildContext context) async {
    final isConnected = await _checkActualConnection();

    if (isConnected) {
      navigatorKey.currentState?.pushReplacementNamed('/home');
    } else {
      Fluttertoast.showToast(
        msg: "Anda belum terhubung ke internet",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              "Tidak ada koneksi internet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Periksa koneksi Anda dan coba lagi."),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _handleRetry(context),
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      ),
    );
  }
}
