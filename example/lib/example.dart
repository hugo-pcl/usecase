// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:example/failure.dart';
import 'package:sealed_result/sealed_result.dart';
import 'package:usecase/usecase.dart';

class AdditionUsecase extends Usecase<int, String> {
  const AdditionUsecase();

  @override
  Future<String> execute(int params) async {
    return '$params * 2 = ${params * 2}';
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

class DangerousUsecase extends ResultUsecase<int, String, Failure> {
  @override
  Future<Result<String, Failure>> execute(int params) async {
    if (params == 0) {
      return Result.err(Failure('Cannot divide by 0'));
    }
    return Result.success('${10 / params}');
  }

  @override
  Result<String, Failure> onException(UsecaseException e) =>
      Result.failure(Failure(e.message ?? ''));
}

class ListenerUsecase extends NoParamsResultStreamUsecase<String, Failure> {
  @override
  Stream<Result<String, Failure>> execute() async* {
    for (int i = 0; i < 10; i++) {
      if (i == 0) {
        yield Result.err(Failure('Cannot be 0'));
      } else if (i == 5) {
        yield Result.err(Failure('Cannot be 5'));
      } else {
        yield Result.success('${10 / i}');
      }
    }
  }

  @override
  Result<String, Failure> onException(UsecaseException e) =>
      Result.failure(Failure(e.message ?? ''));
}
