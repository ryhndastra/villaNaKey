import 'package:flutter/material.dart';
import 'package:villanakey/components/splash_page.dart';
import 'package:villanakey/pages/change_information_page.dart';
import 'package:villanakey/pages/login_page.dart';
import 'package:villanakey/components/bottom_bar.dart';
import 'package:villanakey/pages/sign_up.dart';
import 'package:villanakey/pages/user_settings.dart'; // ganti dari home_page.dart

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/home': (context) => CustomBottomBar(),
        '/login': (context) => LoginPage(),
        '/signin': (context) => UserSettings(), // Navigator sementara, Karena belum ada tombol untuk pindah ke user setting 
        '/signup': (context) => SignUp(),
        '/changeinfo': (context) => ChangeInformationPage(),
      },
    );
  }
}
