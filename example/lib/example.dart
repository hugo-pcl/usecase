// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:example/failure.dart';
import 'package:sealed_result/sealed_result.dart';
import 'package:usecase/usecase.dart';

class AdditionUsecase extends Usecase<int, int> {
  const AdditionUsecase();

  @override
  Future<int> execute(int params) async {
    return params + params;
  }
}

class DivisionUsecase extends Usecase<(int, int), double> {
  const DivisionUsecase();

  @override
  FutureOr<PreconditionsResult> checkPrecondition((int, int)? params) {
    if (params == null) {
      return PreconditionsResult(isValid: false, message: 'Params is null');
    }

    if (params.$2 == 0) {
      return PreconditionsResult(isValid: false, message: 'Cannot divide by 0');
    }

    return PreconditionsResult(isValid: true);
  }

  @override
  Future<double> execute((int, int) params) async {
    return params.$1 / params.$2;
  }
}

class GeneratorUsecase extends NoParamsStreamUsecase<int> {
  const GeneratorUsecase();

  @override
  Stream<int> execute() async* {
    for (int i = 0; i < 10; i++) {
      yield i;
    }
  }
}

class DivisionResultUsecase extends ResultUsecase<(int, int), double, Failure> {
  const DivisionResultUsecase();

  @override
  FutureOr<PreconditionsResult> checkPrecondition((int, int)? params) {
    if (params == null) {
      return PreconditionsResult(isValid: false, message: 'Params is null');
    }

    if (params.$2 == 0) {
      return PreconditionsResult(isValid: false, message: 'Cannot divide by 0');
    }

    return PreconditionsResult(isValid: true);
  }

  @override
  Future<Result<double, Failure>> execute((int, int) params) async {
    return Result.success(params.$1 / params.$2);
  }

  @override
  Result<double, Failure> onException(UsecaseException e) =>
      Result.failure(Failure(e.message ?? ''));
}
