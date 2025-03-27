import '../../core/utils/errors/base_error.dart';

base class TractianError extends BaseError {
  const TractianError({
    super.stackTrace,
    super.errorMessage = 'Erro desconhecido',
  });
}

final class TractianDataError extends TractianError {
  const TractianDataError({
    super.stackTrace,
    super.errorMessage = 'Erro desconhecido',
  });
}
