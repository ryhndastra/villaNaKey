import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Login');
      },
      child: Container(
        alignment: Alignment.center,
        height: 55,
        decoration: BoxDecoration(
          color: Color(0xFF819766),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10
            ),
          ],
        ),
        child: Text(
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
