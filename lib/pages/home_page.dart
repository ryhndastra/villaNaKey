import 'package:flutter/material.dart';
import 'package:villanakey/components/appbar_app.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  void _goToLogin(BuildContext context) async {
    final username = await Navigator.pushNamed(context, '/login');

    if (username != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Selamat datang, $username!')));
      print('Login sukses user: $username');
      // Update UI, simpan session, dll
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarApp(onLoginPressed: () => _goToLogin(context)),
      body: Center(child: Text("Home Page")),
    );
  }
}
