import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Hiệu ứng fade-in cho logo
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // Chuyển sang HomeScreen sau 4 giây
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ảnh nền thời trang
          Image.asset(
            'assets/images/tn_hero.jpg',
            fit: BoxFit.cover,
          ),

          // Lớp phủ mờ nhẹ để logo nổi hơn
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0x33000000),
                  Color(0x00000000),
                ],
              ),
            ),
          ),

          // Logo “T&N” kiểu H&M
          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Transform.rotate(
                angle: -0.08, // nghiêng nhẹ
                child: Text(
                  'T&N',
                  style: GoogleFonts.satisfy(
                    // Font mềm kiểu viết tay gần giống H&M
                    color: const Color(0xFFE10000),
                    fontSize: MediaQuery.of(context).size.width * 0.32,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -4,
                    shadows: const [
                      Shadow(
                        color: Color(0x55000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
