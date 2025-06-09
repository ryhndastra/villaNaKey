import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _rollSlideController;
  late AnimationController _popController;

  late Animation<double> _rollAnimation;
  late Animation<Offset> _slideAnimation;

  late Animation<double> _popScaleAnimation;
  late Animation<double> _popOpacityAnimation;

  bool _showLogo = true;

  @override
  void initState() {
    super.initState();

    _rollSlideController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rollAnimation = Tween<double>(begin: 0, end: 4 * pi).animate(
      CurvedAnimation(parent: _rollSlideController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _rollSlideController, curve: Curves.easeOut),
    );

    _popController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _popScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.5,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_popController);

    _popOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_popController);

    _rollSlideController.forward();

    _rollSlideController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          _popController.forward();
        });
      }
    });

    _popController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showLogo = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    });
  }

  @override
  void dispose() {
    _rollSlideController.dispose();
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF819766),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF819766), Color(0xFFEADECE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child:
              _showLogo
                  ? AnimatedBuilder(
                    animation: Listenable.merge([
                      _rollSlideController,
                      _popController,
                    ]),
                    builder: (context, child) {
                      final scale =
                          _popController.isAnimating
                              ? _popScaleAnimation.value
                              : 1.0;
                      final opacity =
                          _popController.isAnimating
                              ? _popOpacityAnimation.value
                              : 1.0;

                      return Opacity(
                        opacity: opacity,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Transform.rotate(
                            angle: _rollAnimation.value,
                            child: Transform.scale(scale: scale, child: child),
                          ),
                        ),
                      );
                    },
                    child: const Image(
                      image: AssetImage('assets/images/logoya.png'),
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
