import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/domain/errors/tractian_error.dart';

void main() {
  test('TractianError default constructor', () {
    final error = TractianError();
    expect(error.errorMessage, equals('Erro desconhecido'));
    expect(error.stackTrace, isNull);
  });

  test('TractianError with stackTrace provided', () {
    final testStack = StackTrace.current;
    final error = TractianError(stackTrace: testStack);
    expect(error.stackTrace, equals(testStack));
  });

  test('TractianDataError default constructor', () {
    final error = TractianDataError();
    expect(error.errorMessage, equals('Erro desconhecido'));
    expect(error.stackTrace, isNull);
  });

  test('TractianDataError with stackTrace provided', () {
    final testStack = StackTrace.current;
    final error = TractianDataError(stackTrace: testStack);
    expect(error.stackTrace, equals(testStack));
  });
}
