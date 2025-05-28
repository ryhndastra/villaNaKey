import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:villanakey/main.dart';

class ConnectivityService with ChangeNotifier {
  bool _hasConnection = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool get hasConnection => _hasConnection;

  void initialize() {
    print('[ConnectivityService] initialize dipanggil');

    _subscription ??= _connectivity.onConnectivityChanged.listen((results) {
      final isConnected =
          results.isNotEmpty &&
          results.any((r) => r != ConnectivityResult.none);

      print('[ConnectivityService] Results: $results');
      print('[ConnectivityService] isConnected: $isConnected');

      if (_hasConnection != isConnected) {
        _hasConnection = isConnected;
        notifyListeners();

        if (!isConnected) {
          Future.delayed(const Duration(seconds: 2), () {
            if (!_hasConnection) {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                '/no_internet',
                (route) => false,
              );
            }
          });
        }
      }
    });
  }

  void disposeConnectionListener() {
    _subscription?.cancel();
  }
}
