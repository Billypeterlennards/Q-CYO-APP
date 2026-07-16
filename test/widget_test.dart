// BEFORE: this was the default Flutter template's "Counter increments"
// test, left over from `flutter create`. It looks for a '+' icon and a
// counter that don't exist anywhere in this app - running it would fail
// immediately. It was never adapted to actually test Q-CYO.
//
// AFTER: a real smoke test that verifies the actual home screen renders
// its key elements without crashing.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qcyo/main.dart';

void main() {
  testWidgets('App launches and shows the farm details form', (tester) async {
    await tester.pumpWidget(const QCYApp());
    await tester.pump();

    expect(find.text('Q-CYO: Quantum Crop Yield Optimizer'), findsOneWidget);
    expect(find.text('Farm Details'), findsOneWidget);
    expect(find.text('Get Quantum Recommendations'), findsOneWidget);

    // Default form values should be pre-filled.
    expect(find.widgetWithText(TextFormField, ''), findsNothing);
  });

  testWidgets('Advanced options toggle reveals the budget field', (tester) async {
    await tester.pumpWidget(const QCYApp());
    await tester.pump();

    expect(find.text('Budget (USD) - Optional'), findsNothing);

    await tester.tap(find.text('Advanced Options'));
    await tester.pump();

    expect(find.text('Budget (USD) - Optional'), findsOneWidget);
  });
}
