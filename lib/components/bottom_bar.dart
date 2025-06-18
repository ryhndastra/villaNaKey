import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:villanakey/components/appbar_app.dart';
import 'package:villanakey/pages/home_page.dart';
import 'package:villanakey/pages/reservation.dart';
import 'package:villanakey/providers/user_provider.dart';
import 'package:villanakey/service/connectivity_service.dart';

class CustomBottomBar extends StatefulWidget {
  final int initialIndex;
  final bool showWelcome;
  const CustomBottomBar({
    super.key,
    this.initialIndex = 0,
    this.showWelcome = false,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late int _selectedIndex;

  final List<Widget> _pages = [HomePage(), Reservation()];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    Future.microtask(() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUser();

      if (widget.showWelcome && mounted) {
        final name = userProvider.user?.name ?? 'Pengguna';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Halo, $name!')));
      }
    });
  }

  @override
  void dispose() {
    Provider.of<ConnectivityService>(
      context,
      listen: false,
    ).disposeConnectionListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarApp(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        color: const Color(0xFF819766),
        backgroundColor: Colors.white,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.bed, size: 30, color: Colors.white),
        ],
        onTap: (index) async {
          final isLoggedIn =
              Provider.of<UserProvider>(context, listen: false).isLoggedIn;

          if (!isLoggedIn && index == 1) {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    title: const Text(
                      'Harap Login Dahulu',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 43, 75, 49),
                      ),
                    ),
                    content: const Text(
                      'Silakan login terlebih dahulu untuk melakukan Reservasi',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Tutup',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF42754C),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
            );
            return;
          }

          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
