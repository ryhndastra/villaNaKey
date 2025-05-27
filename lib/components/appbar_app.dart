import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class AppBarApp extends StatelessWidget implements PreferredSizeWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

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
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child:
                user != null
                    ? IconButton(
                      icon: const Icon(Icons.person, color: Colors.white),
                      tooltip: 'Profil Saya',
                      onPressed: () {
                        // Tampilkan snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Settings"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        // Arahkan ke halaman pengaturan
                        Navigator.pushNamed(context, '/settings');
                      },
                    )
                    : TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: Colors.white,
                        ),
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
