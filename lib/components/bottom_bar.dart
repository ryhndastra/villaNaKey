import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:villanakey/components/appbar_app.dart';
import 'package:villanakey/pages/home_page.dart';
import 'package:villanakey/pages/reservation.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _selectedIndex = 0;

  final List<PreferredSizeWidget> _appBars = [
    AppBarApp(), // Untuk Home
    AppBarApp(), // Untuk Reservation
  ];

  final List<Widget> _pages = [HomePage(), Reservation()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_selectedIndex],
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
