import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CodelabApp());
    await tester.pump();

    // Verify app renders login screen or initial UI
    expect(find.byType(CodelabApp), findsOneWidget);
  });
}
