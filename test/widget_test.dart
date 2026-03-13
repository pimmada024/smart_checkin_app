import 'package:flutter_test/flutter_test.dart';

import 'package:smart_checkin_app/main.dart';

void main() {
  testWidgets('Home screen shows title and action buttons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Smart Class Check-in'), findsOneWidget);
    expect(find.text('Welcome, Student'), findsOneWidget);
    expect(find.text('Check-in to Class'), findsOneWidget);
    expect(find.text('Finish Class'), findsOneWidget);
  });

  testWidgets('Navigate from Home to Check-in screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Check-in to Class'));
    await tester.pumpAndSettle();

    expect(find.text('Class Check-in'), findsOneWidget);
    expect(find.text('Previous Class Topic'), findsOneWidget);
  });

  testWidgets('Navigate from Home to Finish Class screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Finish Class'));
    await tester.pumpAndSettle();

    expect(find.text('Finish Class'), findsOneWidget);
    expect(find.text('What did you learn today?'), findsOneWidget);
  });
}
