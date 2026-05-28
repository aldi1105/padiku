import 'package:flutter_test/flutter_test.dart';

import 'package:padiku/main.dart';

void main() {
  testWidgets('PADIKU app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PadikuApp());

    // Verify that login screen loads
    expect(find.text('Welcome to'), findsOneWidget);
  });
}
