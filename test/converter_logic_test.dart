import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/logic/converter_logic.dart';
import 'package:unit_converter/models/converter_category.dart';

void main() {
  group('Length Conversion Tests', () {
    test('Converts Meter to Kilometer correctly', () {
      final result = ConverterLogic.convertLength(1000, 'Meter', 'Kilometer');
      expect(result, closeTo(1.0, 1e-6));
    });

    test('Converts Kilometer to Meter correctly', () {
      final result = ConverterLogic.convertLength(5.5, 'Kilometer', 'Meter');
      expect(result, closeTo(5500.0, 1e-6));
    });

    test('Converts Meter to Centimeter and Millimeter', () {
      expect(ConverterLogic.convertLength(1.0, 'Meter', 'Centimeter'), closeTo(100.0, 1e-6));
      expect(ConverterLogic.convertLength(1.0, 'Meter', 'Millimeter'), closeTo(1000.0, 1e-6));
    });

    test('Converts Mile to Kilometer and Meter', () {
      expect(ConverterLogic.convertLength(1.0, 'Mile', 'Meter'), closeTo(1609.344, 1e-4));
      expect(ConverterLogic.convertLength(1.0, 'Mile', 'Kilometer'), closeTo(1.609344, 1e-6));
    });

    test('Converts Foot to Inch and Meter', () {
      expect(ConverterLogic.convertLength(1.0, 'Foot', 'Inch'), closeTo(12.0, 1e-4));
      expect(ConverterLogic.convertLength(1.0, 'Foot', 'Meter'), closeTo(0.3048, 1e-6));
    });

    test('Same unit conversion returns identical value', () {
      expect(ConverterLogic.convertLength(42.5, 'Meter', 'Meter'), equals(42.5));
      expect(ConverterLogic.convertLength(10.0, 'Mile', 'Mile'), equals(10.0));
    });
  });

  group('Weight Conversion Tests', () {
    test('Converts Kilogram to Gram and Milligram', () {
      expect(ConverterLogic.convertWeight(1.0, 'Kilogram', 'Gram'), closeTo(1000.0, 1e-6));
      expect(ConverterLogic.convertWeight(1.0, 'Kilogram', 'Milligram'), closeTo(1000000.0, 1e-6));
    });

    test('Converts Kilogram to Pound and Ounce', () {
      expect(ConverterLogic.convertWeight(1.0, 'Kilogram', 'Pound'), closeTo(2.20462, 1e-3));
      expect(ConverterLogic.convertWeight(1.0, 'Pound', 'Ounce'), closeTo(16.0, 1e-3));
    });

    test('Converts Pound to Kilogram', () {
      expect(ConverterLogic.convertWeight(1.0, 'Pound', 'Kilogram'), closeTo(0.45359237, 1e-6));
    });

    test('Same unit conversion returns identical value', () {
      expect(ConverterLogic.convertWeight(50.0, 'Kilogram', 'Kilogram'), equals(50.0));
      expect(ConverterLogic.convertWeight(16.0, 'Ounce', 'Ounce'), equals(16.0));
    });
  });

  group('Temperature Conversion Tests', () {
    test('Converts Celsius to Fahrenheit correctly', () {
      expect(ConverterLogic.convertTemperature(0.0, 'Celsius', 'Fahrenheit'), closeTo(32.0, 1e-6));
      expect(ConverterLogic.convertTemperature(100.0, 'Celsius', 'Fahrenheit'), closeTo(212.0, 1e-6));
      expect(ConverterLogic.convertTemperature(-40.0, 'Celsius', 'Fahrenheit'), closeTo(-40.0, 1e-6));
    });

    test('Converts Fahrenheit to Celsius correctly', () {
      expect(ConverterLogic.convertTemperature(32.0, 'Fahrenheit', 'Celsius'), closeTo(0.0, 1e-6));
      expect(ConverterLogic.convertTemperature(212.0, 'Fahrenheit', 'Celsius'), closeTo(100.0, 1e-6));
      expect(ConverterLogic.convertTemperature(-40.0, 'Fahrenheit', 'Celsius'), closeTo(-40.0, 1e-6));
    });

    test('Converts Celsius to Kelvin correctly', () {
      expect(ConverterLogic.convertTemperature(0.0, 'Celsius', 'Kelvin'), closeTo(273.15, 1e-6));
      expect(ConverterLogic.convertTemperature(-273.15, 'Celsius', 'Kelvin'), closeTo(0.0, 1e-6));
    });

    test('Converts Kelvin to Celsius correctly', () {
      expect(ConverterLogic.convertTemperature(273.15, 'Kelvin', 'Celsius'), closeTo(0.0, 1e-6));
      expect(ConverterLogic.convertTemperature(0.0, 'Kelvin', 'Celsius'), closeTo(-273.15, 1e-6));
    });

    test('Converts Fahrenheit to Kelvin and vice-versa', () {
      expect(ConverterLogic.convertTemperature(32.0, 'Fahrenheit', 'Kelvin'), closeTo(273.15, 1e-6));
      expect(ConverterLogic.convertTemperature(273.15, 'Kelvin', 'Fahrenheit'), closeTo(32.0, 1e-6));
    });

    test('Same temperature unit returns identical value', () {
      expect(ConverterLogic.convertTemperature(25.0, 'Celsius', 'Celsius'), equals(25.0));
      expect(ConverterLogic.convertTemperature(300.0, 'Kelvin', 'Kelvin'), equals(300.0));
    });
  });

  group('Absolute Zero Validation Tests', () {
    test('Detects temperature below absolute zero in Celsius', () {
      expect(ConverterLogic.isBelowAbsoluteZero(-273.16, 'Celsius'), isTrue);
      expect(ConverterLogic.isBelowAbsoluteZero(-273.15, 'Celsius'), isFalse);
      expect(ConverterLogic.isBelowAbsoluteZero(-100.0, 'Celsius'), isFalse);
    });

    test('Detects temperature below absolute zero in Fahrenheit', () {
      expect(ConverterLogic.isBelowAbsoluteZero(-459.68, 'Fahrenheit'), isTrue);
      expect(ConverterLogic.isBelowAbsoluteZero(-459.67, 'Fahrenheit'), isFalse);
      expect(ConverterLogic.isBelowAbsoluteZero(0.0, 'Fahrenheit'), isFalse);
    });

    test('Detects temperature below absolute zero in Kelvin', () {
      expect(ConverterLogic.isBelowAbsoluteZero(-0.01, 'Kelvin'), isTrue);
      expect(ConverterLogic.isBelowAbsoluteZero(0.0, 'Kelvin'), isFalse);
      expect(ConverterLogic.isBelowAbsoluteZero(100.0, 'Kelvin'), isFalse);
    });

    test('Returns error ConversionResult when below absolute zero', () {
      final res = ConverterLogic.convert(
        category: CategoryType.temperature,
        input: '-300',
        fromUnit: 'Celsius',
        toUnit: 'Fahrenheit',
      );
      expect(res.isValid, isFalse);
      expect(res.errorMessage, contains('absolute zero'));
    });
  });

  group('Input Validation and Edge Cases', () {
    test('Handles empty input safely', () {
      final res = ConverterLogic.convert(
        category: CategoryType.length,
        input: '',
        fromUnit: 'Meter',
        toUnit: 'Kilometer',
      );
      expect(res.isValid, isTrue);
      expect(res.isEmpty, isTrue);
      expect(res.numericValue, isNull);
    });

    test('Handles whitespace input safely', () {
      final res = ConverterLogic.convert(
        category: CategoryType.weight,
        input: '   ',
        fromUnit: 'Kilogram',
        toUnit: 'Gram',
      );
      expect(res.isValid, isTrue);
      expect(res.isEmpty, isTrue);
    });

    test('Handles non-numeric input safely', () {
      final res = ConverterLogic.convert(
        category: CategoryType.length,
        input: 'abc',
        fromUnit: 'Meter',
        toUnit: 'Kilometer',
      );
      expect(res.isValid, isFalse);
      expect(res.errorMessage, contains('valid number'));
    });

    test('Handles comma as decimal separator', () {
      final res = ConverterLogic.convert(
        category: CategoryType.length,
        input: '1,5',
        fromUnit: 'Kilometer',
        toUnit: 'Meter',
      );
      expect(res.isValid, isTrue);
      expect(res.numericValue, closeTo(1500.0, 1e-6));
    });

    test('Formats zeros and clean numbers without trailing zeroes', () {
      expect(ConverterLogic.formatValue(0.0), '0');
      expect(ConverterLogic.formatValue(100.0), '100');
      expect(ConverterLogic.formatValue(1.5), '1.5');
      expect(ConverterLogic.formatValue(1.23456789), '1.234568');
    });
  });
}
