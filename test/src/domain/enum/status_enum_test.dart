import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/domain/enum/status_enum.dart';

void main() {
  group('StatusEnum', () {
    test('fromString returns operating for "operating"', () {
      expect(StatusEnum.fromString('operating'), StatusEnum.operating);
    });

    test('fromString returns alert for "alert"', () {
      expect(StatusEnum.fromString('alert'), StatusEnum.alert);
    });

    test('fromString returns none for an unknown value', () {
      expect(StatusEnum.fromString('unknown'), StatusEnum.none);
    });

    test('name property returns correct value for operating', () {
      expect(StatusEnum.operating.name, 'operating');
    });

    test('name property returns correct value for alert', () {
      expect(StatusEnum.alert.name, 'alert');
    });

    test('name property returns empty string for none', () {
      expect(StatusEnum.none.name, '');
    });
  });
}
