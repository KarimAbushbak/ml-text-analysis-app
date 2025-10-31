import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingua_sense/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LinguaSenseApp());

    // The app should have the MaterialApp.router with SplashScreen
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
