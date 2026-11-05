import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/main.dart';

void main() {
  testWidgets('HomeScreen displays title and three category cards', (WidgetTester tester) async {
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle();

    // Verify Home screen title
    expect(find.text('Unit Converter'), findsOneWidget);
    expect(find.text('Select a Category'), findsOneWidget);

    // Verify all three category cards
    expect(find.text('Length'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('Temperature'), findsOneWidget);

    // Verify category icons
    expect(find.byIcon(Icons.straighten_rounded), findsOneWidget);
    expect(find.byIcon(Icons.scale_rounded), findsOneWidget);
    expect(find.byIcon(Icons.thermostat_rounded), findsOneWidget);
  });

  testWidgets('Navigation to ConverterScreen and back works smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle();

    // Tap on Length category
    await tester.tap(find.text('Length'));
    await tester.pumpAndSettle();

    // Verify ConverterScreen is opened
    expect(find.text('Length Converter'), findsOneWidget);
    expect(find.text('Enter Value'), findsOneWidget);
    expect(find.text('Convert Between'), findsOneWidget);
    expect(find.text('Converted Result'), findsOneWidget);

    // Tap AppBar back button
    final appBarBackButton = find.byKey(const Key('appBarBackButton'));
    expect(appBarBackButton, findsOneWidget);
    await tester.tap(appBarBackButton);
    await tester.pumpAndSettle();

    // Back to Home screen
    expect(find.text('Select a Category'), findsOneWidget);

    // Also test navigation and bottom back button with scrolling
    await tester.tap(find.text('Weight'));
    await tester.pumpAndSettle();
    expect(find.text('Weight Converter'), findsOneWidget);

    final bottomBackButton = find.byKey(const Key('bottomBackButton'));
    await tester.ensureVisible(bottomBackButton);
    await tester.pumpAndSettle();
    await tester.tap(bottomBackButton);
    await tester.pumpAndSettle();

    // Back to Home screen
    expect(find.text('Select a Category'), findsOneWidget);
  });

  testWidgets('ConverterScreen performs live conversion and swap', (WidgetTester tester) async {
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle();

    // Tap on Length category
    await tester.tap(find.text('Length'));
    await tester.pumpAndSettle();

    // Default is 1 Meter to Kilometer => 0.001
    expect(find.byKey(const Key('converterResultText')), findsOneWidget);
    expect(find.text('0.001'), findsOneWidget);

    // Change input to 2500
    final inputField = find.byKey(const Key('converterInputField'));
    await tester.enterText(inputField, '2500');
    await tester.pumpAndSettle();

    // 2500 Meter = 2.5 Kilometer
    expect(find.text('2.5'), findsOneWidget);

    // Tap swap button
    final swapButton = find.byKey(const Key('swapUnitsButton'));
    await tester.tap(swapButton);
    await tester.pumpAndSettle();

    // Now From is Kilometer and To is Meter: 2500 Kilometer = 2500000 Meter
    expect(find.text('2500000'), findsOneWidget);
  });

  testWidgets('Temperature converter displays absolute zero warning', (WidgetTester tester) async {
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle();

    // Tap Temperature category
    await tester.tap(find.text('Temperature'));
    await tester.pumpAndSettle();

    expect(find.text('Temperature Converter'), findsOneWidget);

    // Enter a temperature below absolute zero: -300 Celsius
    final inputField = find.byKey(const Key('converterInputField'));
    await tester.enterText(inputField, '-300');
    await tester.pumpAndSettle();

    // Check error message is displayed
    expect(find.byKey(const Key('converterErrorMessage')), findsOneWidget);
    expect(find.textContaining('absolute zero'), findsOneWidget);

    // Now enter valid temperature 100 Celsius -> 212 Fahrenheit
    await tester.enterText(inputField, '100');
    await tester.pumpAndSettle();

    expect(find.text('212'), findsOneWidget);
    expect(find.byKey(const Key('converterErrorMessage')), findsNothing);
  });
}
