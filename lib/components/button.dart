import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key});

  // Navigator sementara, Karena belum ada tombol untuk pindah ke user setting 
  void _goToUserSettings(BuildContext context) {
    Navigator.pushNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _goToUserSettings(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF819766),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),
            ),
            elevation: 10,
              ),
          child: const Text(
            'Sign In',
            style: TextStyle(
              color:Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    );
  }
}