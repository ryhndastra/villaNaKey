import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:villanakey/components/splash_page.dart';
import 'package:villanakey/firebase_options.dart';
import 'package:villanakey/pages/change_information_page.dart';
import 'package:villanakey/auth/login_page.dart';
import 'package:villanakey/components/bottom_bar.dart';
import 'package:villanakey/auth/sign_up.dart';
import 'package:villanakey/pages/user_settings.dart';
import 'package:villanakey/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ← penting
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const MainApp(),
    ),
  );
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
        '/settings':
            (context) =>
                UserSettings(), // Navigator sementara, Karena belum ada tombol untuk pindah ke user setting
        '/signup': (context) => SignUp(),
        '/changeinfo': (context) => ChangeInformationPage(),
      },
    );
  }
}
