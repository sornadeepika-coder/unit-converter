import '../models/converter_category.dart';

class ConversionResult {
  final double? numericValue;
  final String formattedValue;
  final String? errorMessage;
  final bool isValid;
  final bool isEmpty;

  const ConversionResult.success({
    required this.numericValue,
    required this.formattedValue,
  })  : isValid = true,
        isEmpty = false,
        errorMessage = null;

  const ConversionResult.error(this.errorMessage)
      : isValid = false,
        isEmpty = false,
        numericValue = null,
        formattedValue = '';

  const ConversionResult.empty()
      : isValid = true,
        isEmpty = true,
        numericValue = null,
        formattedValue = '',
        errorMessage = null;
}

class ConverterLogic {
  static const Map<String, double> lengthToMeter = {
    'Meter': 1.0,
    'Kilometer': 1000.0,
    'Centimeter': 0.01,
    'Millimeter': 0.001,
    'Mile': 1609.344,
    'Foot': 0.3048,
    'Inch': 0.0254,
  };

  static const Map<String, double> weightToKg = {
    'Kilogram': 1.0,
    'Gram': 0.001,
    'Milligram': 0.000001,
    'Pound': 0.45359237,
    'Ounce': 0.028349523125,
  };

  static const Map<String, String> unitSymbols = {
    'Meter': 'm',
    'Kilometer': 'km',
    'Centimeter': 'cm',
    'Millimeter': 'mm',
    'Mile': 'mi',
    'Foot': 'ft',
    'Inch': 'in',
    'Kilogram': 'kg',
    'Gram': 'g',
    'Milligram': 'mg',
    'Pound': 'lb',
    'Ounce': 'oz',
    'Celsius': '°C',
    'Fahrenheit': '°F',
    'Kelvin': 'K',
  };

  static String getSymbol(String unit) => unitSymbols[unit] ?? '';

  static double? getAbsoluteZero(String unit) {
    switch (unit) {
      case 'Celsius':
        return -273.15;
      case 'Fahrenheit':
        return -459.67;
      case 'Kelvin':
        return 0.0;
      default:
        return null;
    }
  }

  static bool isBelowAbsoluteZero(double value, String unit) {
    final min = getAbsoluteZero(unit);
    if (min == null) return false;
    return value < min;
  }

  static double convertLength(double value, String from, String to) {
    if (from == to) return value;
    final fromFactor = lengthToMeter[from];
    final toFactor = lengthToMeter[to];
    if (fromFactor == null || toFactor == null) {
      throw ArgumentError('Invalid length units: $from, $to');
    }
    final inMeters = value * fromFactor;
    return inMeters / toFactor;
  }

  static double convertWeight(double value, String from, String to) {
    if (from == to) return value;
    final fromFactor = weightToKg[from];
    final toFactor = weightToKg[to];
    if (fromFactor == null || toFactor == null) {
      throw ArgumentError('Invalid weight units: $from, $to');
    }
    final inKg = value * fromFactor;
    return inKg / toFactor;
  }

  static double convertTemperature(double value, String from, String to) {
    if (from == to) return value;

    // Convert from source unit to Celsius first
    double inCelsius;
    switch (from) {
      case 'Celsius':
        inCelsius = value;
        break;
      case 'Fahrenheit':
        inCelsius = (value - 32.0) * (5.0 / 9.0);
        break;
      case 'Kelvin':
        inCelsius = value - 273.15;
        break;
      default:
        throw ArgumentError('Invalid temperature unit: $from');
    }

    // Convert from Celsius to target unit
    switch (to) {
      case 'Celsius':
        return inCelsius;
      case 'Fahrenheit':
        return (inCelsius * 9.0 / 5.0) + 32.0;
      case 'Kelvin':
        return inCelsius + 273.15;
      default:
        throw ArgumentError('Invalid temperature unit: $to');
    }
  }

  static ConversionResult convert({
    required CategoryType category,
    required String input,
    required String fromUnit,
    required String toUnit,
  }) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const ConversionResult.empty();
    }

    // Replace comma with dot if user typed localized decimal
    final sanitizedInput = trimmed.replaceAll(',', '.');
    final numericValue = double.tryParse(sanitizedInput);

    if (numericValue == null) {
      return const ConversionResult.error('Please enter a valid number');
    }

    if (category == CategoryType.temperature) {
      if (isBelowAbsoluteZero(numericValue, fromUnit)) {
        final min = getAbsoluteZero(fromUnit);
        return ConversionResult.error(
          'Value cannot be below absolute zero ($min ${getSymbol(fromUnit)})',
        );
      }
    }

    double result;
    try {
      switch (category) {
        case CategoryType.length:
          result = convertLength(numericValue, fromUnit, toUnit);
          break;
        case CategoryType.weight:
          result = convertWeight(numericValue, fromUnit, toUnit);
          break;
        case CategoryType.temperature:
          result = convertTemperature(numericValue, fromUnit, toUnit);
          break;
      }
    } catch (e) {
      return ConversionResult.error(e.toString());
    }

    return ConversionResult.success(
      numericValue: result,
      formattedValue: formatValue(result),
    );
  }

  static String formatValue(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';
    if (value.abs() < 1e-12) return '0';

    if (value.abs() >= 1e9 || (value.abs() < 1e-4 && value != 0)) {
      return value.toStringAsExponential(4);
    }

    String formatted = value.toStringAsFixed(6);
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }
    return formatted;
  }
}
