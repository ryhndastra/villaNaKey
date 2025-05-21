import 'dart:async';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF819766), Color(0xFFEADECE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Image(
            image: AssetImage('assets/images/logoya.png'),
            width: 250,
            height: 250,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
