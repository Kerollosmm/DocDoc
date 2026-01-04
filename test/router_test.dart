import 'package:flutter_test/flutter_test.dart';
import 'package:doc_app/core/routes/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Router navigation smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: appRouter,
    ));

    // Verify we are at login
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Login (Mock)'), findsOneWidget);

    // Tap login
    await tester.tap(find.text('Login (Mock)'));
    await tester.pumpAndSettle();

    // Verify we are at dashboard
    expect(find.text('Classes'), findsOneWidget);
    expect(find.text('Grade 1'), findsOneWidget);
  });
}
