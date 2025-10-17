import 'package:flutter_test/flutter_test.dart';
import 'package:fashion_store_app/main.dart';

void main() {
  testWidgets('Splash shows T&N logo', (WidgetTester tester) async {
    await tester.pumpWidget(const FashionStoreApp());

    // Kiểm tra chữ T&N xuất hiện
    expect(find.text('T&N'), findsOneWidget);
  });
}
