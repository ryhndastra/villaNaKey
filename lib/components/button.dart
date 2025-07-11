import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String textBtn;
  final String routeName;
  final VoidCallback? onPressed;

  const Button({
    super.key,
    this.textBtn = 'Sign In',
    this.routeName = '/signin',
    this.onPressed,
  });

  void _navigate(BuildContext context) {
    if (onPressed != null) {
      onPressed!();
    } else {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _navigate(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF42754C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 10,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          textBtn,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
