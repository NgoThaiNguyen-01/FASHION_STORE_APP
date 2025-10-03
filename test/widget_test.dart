import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_store_app/presentation/screens/splash/splash_screen.dart';

void main() {
  testWidgets('SplashScreen shows logo text and navigates to /onboarding', (
    WidgetTester tester,
  ) async {
    // Dùng MaterialApp với route /onboarding trỏ tới một widget giả (Placeholder)
    await tester.pumpWidget(
      MaterialApp(
        home: const SplashScreen(),
        routes: {'/onboarding': (_) => const Scaffold(body: Placeholder())},
      ),
    );

    // 1) Kiểm tra nội dung hiển thị ở Splash
    expect(find.byIcon(Icons.shopping_bag), findsOneWidget);
    expect(find.text('FASHION'), findsOneWidget);
    expect(find.text('STORE'), findsOneWidget);

    // 2) Mô phỏng thời gian 3s để Timer trong Splash chạy
    await tester.pump(const Duration(milliseconds: 100)); // frame đầu
    await tester.pump(const Duration(seconds: 3)); // cho timer fire

    // 3) Đã điều hướng sang /onboarding (Placeholder xuất hiện)
    expect(find.byType(Placeholder), findsOneWidget);
    // Và SplashScreen không còn trên màn
    expect(find.byType(SplashScreen), findsNothing);
  });
}
