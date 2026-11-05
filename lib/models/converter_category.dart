import 'package:flutter/material.dart';

enum CategoryType {
  length,
  weight,
  temperature,
}

class ConverterCategory {
  final CategoryType type;
  final String title;
  final String description;
  final IconData icon;
  final List<String> units;
  final String defaultFromUnit;
  final String defaultToUnit;

  const ConverterCategory({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.units,
    required this.defaultFromUnit,
    required this.defaultToUnit,
  });

  static const List<ConverterCategory> categories = [
    ConverterCategory(
      type: CategoryType.length,
      title: 'Length',
      description: 'Meter, Kilometer, Centimeter, Mile, Foot, etc.',
      icon: Icons.straighten_rounded,
      units: [
        'Meter',
        'Kilometer',
        'Centimeter',
        'Millimeter',
        'Mile',
        'Foot',
        'Inch',
      ],
      defaultFromUnit: 'Meter',
      defaultToUnit: 'Kilometer',
    ),
    ConverterCategory(
      type: CategoryType.weight,
      title: 'Weight',
      description: 'Kilogram, Gram, Milligram, Pound, Ounce',
      icon: Icons.scale_rounded,
      units: [
        'Kilogram',
        'Gram',
        'Milligram',
        'Pound',
        'Ounce',
      ],
      defaultFromUnit: 'Kilogram',
      defaultToUnit: 'Pound',
    ),
    ConverterCategory(
      type: CategoryType.temperature,
      title: 'Temperature',
      description: 'Celsius, Fahrenheit, Kelvin',
      icon: Icons.thermostat_rounded,
      units: [
        'Celsius',
        'Fahrenheit',
        'Kelvin',
      ],
      defaultFromUnit: 'Celsius',
      defaultToUnit: 'Fahrenheit',
    ),
  ];
}
