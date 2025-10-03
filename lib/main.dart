import 'package:flutter/material.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';

// DB (nếu có dùng SQLite)
// import 'data/database/db_helper.dart';

// Screens
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/reset_password_screen.dart';
import 'presentation/screens/auth/create_account_screen.dart';
import 'presentation/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Nếu dự án dùng SQLite (sqflite_common_ffi / web):
  // await DBHelper.initFactory();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fashion Store',
      theme: AppTheme.light(),

      // Vào splash trước
      initialRoute: AppRoutes.splash,

      // Map routes -> (context) => Widget
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.reset: (_) => const ResetPasswordScreen(),
        AppRoutes.signup: (_) => const CreateAccountScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
      },

      // Nếu gõ nhầm route -> về Login (tránh crash)
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}
