// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:example/failure.dart';
import 'package:generic_usecase/generic_usecase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sealed_result/sealed_result.dart';

class AdditionUsecase extends Usecase<int, int> {
  const AdditionUsecase();

  @override
  Future<int> execute(int params) async {
    return params + params;
  }

  @override
  FutureOr<int> onException(Object e) {
    print(e);
    return super.onException(e);
  }
}

class DivisionUsecase extends Usecase<(int, int), double> {
  const DivisionUsecase();

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
  Future<double> execute((int, int) params) async {
    return params.$1 / params.$2;
  }
}

class GeneratorUsecase extends NoParamsStreamUsecase<int> {
  const GeneratorUsecase();

  @override
  Stream<int> execute() async* {
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(seconds: 1));
      yield i;
    }
  }
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
  Future<Result<double, Failure>> execute((int, int) params) async {
    return Result.success(params.$1 / params.$2);
  }

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
      Result<bool, Failure>? result) {
    return ConditionsResult(
      isValid: result?.ok == true,
      message: 'Result is not true',
    );
  }

  @override
  Future<Result<bool, Failure>> execute() {
    return Future.delayed(
      const Duration(seconds: 1),
      () => Result.success(false),
    );
  }

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

class RxDartGeneratorUsecase extends NoParamsStreamUsecase<int> {
  const RxDartGeneratorUsecase();

  @override
  Stream<int> execute() async* {
    final subject = BehaviorSubject<int>.seeded(0);

    subject.addStream(
      Stream.periodic(
        const Duration(seconds: 1),
        (i) => i + 1,
      ),
    );

    yield* subject.shareValue();
  }
}
