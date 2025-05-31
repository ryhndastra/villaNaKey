import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

// Pages & Components
import 'package:villanakey/components/splash_page.dart';
import 'package:villanakey/firebase_options.dart';
import 'package:villanakey/pages/change_information_page.dart';
import 'package:villanakey/auth/login_page.dart';
import 'package:villanakey/components/bottom_bar.dart';
import 'package:villanakey/auth/sign_up.dart';
import 'package:villanakey/pages/no_internet.dart';
import 'package:villanakey/pages/order_list_page.dart';
import 'package:villanakey/pages/payment_page.dart';
import 'package:villanakey/pages/user_settings.dart';

// Providers & Services
import 'package:villanakey/providers/user_provider.dart';
import 'package:villanakey/service/connectivity_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting();

  final connectivityService = ConnectivityService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => connectivityService),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConnectivityService>().initialize();
    });

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/home': (context) => const CustomBottomBar(),
        '/login': (context) => const LoginPage(),
        '/settings': (context) => const UserSettings(),
        '/orderlist': (context) => const OrderListPage(),
        '/signup': (context) => const SignUp(),
        '/changeinfo': (context) => const ChangeInformationPage(),
        '/no_internet': (context) => const NoInternetPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/payment') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => PaymentPage(amountToPay: args['amountToPay']),
          );
        }
        return MaterialPageRoute(builder: (_) => const SplashPage());
      },
    );
  }
}
