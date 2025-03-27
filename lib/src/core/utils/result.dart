import 'errors/base_error.dart';

sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok._;
  const factory Result.error(BaseError error) = Error._;

  R fold<R>(R Function(T) onOk, R Function(BaseError) onError) {
    if (this is Ok<T>) {
      return onOk((this as Ok<T>).value);
    } else if (this is Error<BaseError>) {
      return onError((this as Error<BaseError>).error);
    }
    throw StateError('Unexpected state in Result.fold');
  }

  (T?, BaseError?) toTuple() {
    if (this is Ok<T>) {
      return ((this as Ok<T>).value, null);
    } else if (this is Error<BaseError>) {
      return (null, (this as Error<BaseError>).error);
    }
    throw StateError('Unexpected state in Result.toTuple');
  }

  bool get isOk => this is Ok<T>;
  bool get isError => this is Error;

  T getOrElse(T Function() orElse) {
    if (this is Ok<T>) {
      return (this as Ok<T>).value;
    }
    return orElse();
  }
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

final class Error<T extends BaseError> extends Result<T> {
  const Error._(this.error);

  final BaseError error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

extension ResultExtensions<T> on Result<T> {
  void when({
    required void Function(T value) onOk,
    required void Function(BaseError error) onError,
  }) {
    if (this is Ok<T>) {
      onOk((this as Ok<T>).value);
    } else if (this is Error<BaseError>) {
      onError((this as Error<BaseError>).error);
    }
  }
}
