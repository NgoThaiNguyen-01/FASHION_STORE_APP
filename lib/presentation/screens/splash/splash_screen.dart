import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fashion_store_app/core/constants/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeIn);
    _scale = Tween(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut));
    _c.forward();

    // 3s → Onboarding
    Timer(const Duration(seconds: 15), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF7043), Color(0xFFFF8A65)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fade,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scale,
                  child: const CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.shopping_bag,
                      size: 42,
                      color: Colors.deepOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "FASHION",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    letterSpacing: 4,
                  ),
                ),
                const Text(
                  "STORE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
