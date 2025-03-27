base class BaseError implements Exception {
  final StackTrace? stackTrace;
  final String errorMessage;

  const BaseError({this.stackTrace, required this.errorMessage});

  @override
  String toString() => errorMessage;
}

final class UnknownError extends BaseError {
  UnknownError({super.stackTrace, super.errorMessage = 'Erro desconhecido'});
}
