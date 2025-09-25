// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:game_hub/main.dart';

void main() {
  testWidgets('Game Hub app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GameHubApp());

    // Verify that the login page is shown.
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login to continue your gaming journey'), findsOneWidget);
  });
}
