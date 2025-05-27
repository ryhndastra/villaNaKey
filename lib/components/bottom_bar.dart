import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:villanakey/components/appbar_app.dart';
import 'package:villanakey/pages/home_page.dart';
import 'package:villanakey/pages/reservation.dart';
import 'package:villanakey/providers/user_provider.dart';

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

      // Tampilkan snackbar jika login berhasil
      if (widget.showWelcome && mounted) {
        final name = userProvider.user?.name ?? 'Pengguna';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Halo, $name!')));
      }
    });
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
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 250),
      ),
    );
  }
}
