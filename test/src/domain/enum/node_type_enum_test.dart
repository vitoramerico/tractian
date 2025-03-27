import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/domain/enum/node_type_enum.dart';

void main() {
  group('NodeTypeEnum', () {
    test('enum values have correct names', () {
      expect(NodeTypeEnum.location.name, 'location');
      expect(NodeTypeEnum.asset.name, 'asset');
      expect(NodeTypeEnum.component.name, 'component');
      expect(NodeTypeEnum.none.name, '');
    });

    test('fromString returns correct enum for valid strings', () {
      expect(NodeTypeEnum.fromString('location'), NodeTypeEnum.location);
      expect(NodeTypeEnum.fromString('asset'), NodeTypeEnum.asset);
      expect(NodeTypeEnum.fromString('component'), NodeTypeEnum.component);
    });

    test('fromString returns NodeTypeEnum.none for invalid string', () {
      expect(NodeTypeEnum.fromString('invalid'), NodeTypeEnum.none);
      expect(NodeTypeEnum.fromString(''), NodeTypeEnum.none);
    });
  });
}
