import 'package:flutter/material.dart';

class AppBarApp extends StatelessWidget implements PreferredSizeWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/images/logoya.png', width: 55, height: 55),
          const SizedBox(width: 8),
          const Text(
            "Villanakey",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      flexibleSpace: Container(color: const Color(0xFF819766)),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              "Login",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
