// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'dart:async';

import 'package:generic_usecase/generic_usecase.dart';

import 'display.dart';

Future<void> main() async {
  print('AdditionUsecase');

  const AdditionUsecase addition = AdditionUsecase();

  print('> addition(2)');
  await display(() => addition(2));

  print('> addition(null)');
  await display(() => addition(null));

  print('> addition(-2)');
  await display(() => addition(-2));

  print('DivisionUsecase');

  const DivisionUsecase division = DivisionUsecase();

  print('> division(null)');
  await display(() => division(null));

  print('> division((2, 0))');
  await display(() => division((2, 0)));

  print('> division((4, 2))');
  await display(() => division((4, 2)));

  print('GeneratorUsecase');

  const GeneratorUsecase generator = GeneratorUsecase();

  print('> generator()');
  generator().listen(
    print,
    onError: print,
    onDone: () => print('Done'),
  );
}

class AdditionUsecase extends Usecase<int, int> {
  const AdditionUsecase();

  @override
  FutureOr<int> execute(int params) async => params + params;

  @override
  FutureOr<ConditionsResult> checkPostconditions(int? result) {
    if (result == null) {
      return ConditionsResult(isValid: false, message: 'Result is null');
    }

    if (result < 0) {
      return ConditionsResult(isValid: false, message: 'Result is negative');
    }

    return ConditionsResult(isValid: true);
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
  FutureOr<double> execute((int, int) params) async => params.$1 / params.$2;
}

class GeneratorUsecase extends NoParamsStreamUsecase<int> {
  const GeneratorUsecase();

  @override
  Stream<int> execute() async* {
    for (int i = 0; i < 5; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      yield i;
    }
  }
}
