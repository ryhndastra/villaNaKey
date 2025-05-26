import 'package:flutter/material.dart';

class GoogleLogin extends StatelessWidget {
  final String label;

  const GoogleLogin({super.key, this.label = 'Continue with Google'});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Google Button Full Width
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              print(label);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shadowColor: Colors.black.withOpacity(0.1),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/google.png', height: 30, width: 30),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
