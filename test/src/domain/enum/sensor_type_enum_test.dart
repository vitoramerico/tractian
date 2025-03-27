import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/domain/enum/sensor_type_enum.dart';

void main() {
  group('SensorTypeEnum', () {
    test('fromString returns vibration for "vibration"', () {
      final sensor = SensorTypeEnum.fromString('vibration');
      expect(sensor, SensorTypeEnum.vibration);
    });

    test('fromString returns energy for "energy"', () {
      final sensor = SensorTypeEnum.fromString('energy');
      expect(sensor, SensorTypeEnum.energy);
    });

    test('fromString returns none for an unknown value', () {
      final sensor = SensorTypeEnum.fromString('unknown');
      expect(sensor, SensorTypeEnum.none);
    });

    test('name property returns correct value for vibration', () {
      expect(SensorTypeEnum.vibration.name, 'vibration');
    });

    test('name property returns correct value for energy', () {
      expect(SensorTypeEnum.energy.name, 'energy');
    });

    test('name property returns empty string for none', () {
      expect(SensorTypeEnum.none.name, '');
    });
  });
}
