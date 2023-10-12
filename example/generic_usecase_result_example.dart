// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'dart:async';

import 'package:generic_usecase/generic_usecase.dart';
import 'package:sealed_result/sealed_result.dart';

import 'failure.dart';

Future<void> main() async {
  print('BooleanResultUsecase');
  const BooleanResultUsecase boolean = BooleanResultUsecase();

  print('> boolean()');
  await boolean().then(print, onError: print);

  print('DivisionResultUsecase');

  const DivisionResultUsecase divisionResult = DivisionResultUsecase();

  print('> divisionResult(null)');
  await divisionResult(null).then(print, onError: print);

  print('> divisionResult((2, 0))');
  await divisionResult((2, 0)).then(print, onError: print);

  print('> divisionResult((4, 2))');
  await divisionResult((4, 2)).then(print, onError: print);
}

class DivisionResultUsecase extends ResultUsecase<(int, int), double, Failure> {
  const DivisionResultUsecase();

  @override
  FutureOr<ConditionsResult> checkPreconditions((int, int)? params) {
    if (params == null) {
      return ConditionsResult(isValid: false, message: 'Params is null');
    }

    if (params.$2 == 0) {
      return ConditionsResult(isValid: false, message: 'Cannot divide by 0');
    }

    return ConditionsResult(isValid: true);
  }

  @override
  Future<Result<double, Failure>> execute((int, int) params) async =>
      Result.success(params.$1 / params.$2);

  @override
  FutureOr<Result<double, Failure>> onException(Object e) {
    if (e case UsecaseException _) {
      return Result.failure(Failure(e.message ?? ''));
    }
    if (e case Exception || Error) {
      return Result.failure(Failure(e.toString()));
    }
    return Result.failure(Failure(''));
  }
}

class BooleanResultUsecase extends NoParamsResultUsecase<bool, Failure> {
  const BooleanResultUsecase();

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<bool, Failure>? result,
  ) =>
      ConditionsResult(
        isValid: result?.ok ?? false,
        message: 'Result is not true',
      );

  @override
  Future<Result<bool, Failure>> execute() => Future.delayed(
        const Duration(seconds: 1),
        () => const Result.success(false),
      );

  @override
  FutureOr<Result<bool, Failure>> onException(Object e) {
    if (e case UsecaseException _) {
      return Result.failure(Failure(e.message ?? ''));
    }
    if (e case Exception || Error) {
      return Result.failure(Failure(e.toString()));
    }
    return Result.failure(Failure(''));
  }
}
