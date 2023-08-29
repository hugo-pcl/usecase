// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:sealed_result/src/result.dart';
import 'package:test/test.dart';
import 'package:usecase/usecase.dart';

bool globalPrecondition = true;

class UsecaseTest extends Usecase<int, int> {
  const UsecaseTest();

  @override
  Future<int> execute(int params) async {
    return params * 2;
  }
}

class BrokenPreconditionUsecaseTest extends Usecase<int, int> {
  const BrokenPreconditionUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(int? params) =>
      throw Exception('Precondition failed');

  @override
  Future<int> execute(int params) async {
    return params * 2;
  }
}

class NoParamsUsecaseTest extends NoParamsUsecase<int> {
  const NoParamsUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(void params) async {
    return PreconditionsResult(isValid: globalPrecondition);
  }

  @override
  Future<int> execute() async {
    return 42;
  }
}

class NoParamsDefaultUsecaseTest extends NoParamsUsecase<int> {
  const NoParamsDefaultUsecaseTest();

  @override
  Future<int> execute() async {
    return 42;
  }
}

class NoParamsBrokenPreconditionUsecaseTest extends NoParamsUsecase<int> {
  const NoParamsBrokenPreconditionUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(void params) =>
      throw Exception('Precondition failed');

  @override
  Future<int> execute() async {
    return 42;
  }
}

class ResultUsecaseTest extends ResultUsecase<int, int, Exception> {
  const ResultUsecaseTest();

  @override
  Future<Result<int, Exception>> execute(int params) async {
    return Result.success(params * 2);
  }

  @override
  Result<int, Exception> onException(UsecaseException e) {
    return Result.failure(e);
  }
}

class BrokenPreconditionResultUsecaseTest
    extends ResultUsecase<int, int, Exception> {
  const BrokenPreconditionResultUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(int? params) =>
      throw Exception('Precondition failed');

  @override
  Future<Result<int, Exception>> execute(int params) async {
    return Result.success(params * 2);
  }

  @override
  Result<int, Exception> onException(UsecaseException e) {
    return Result.failure(e);
  }
}

class NoParamsResultUsecaseTest extends NoParamsResultUsecase<int, Exception> {
  const NoParamsResultUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(void params) async {
    return PreconditionsResult(isValid: globalPrecondition);
  }

  @override
  Future<Result<int, Exception>> execute() async {
    return Result.success(42);
  }

  @override
  Result<int, Exception> onException(UsecaseException e) {
    return Result.failure(e);
  }
}

class NoParamsBrokenPreconditionResultUsecaseTest
    extends NoParamsResultUsecase<int, Exception> {
  const NoParamsBrokenPreconditionResultUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(void params) =>
      throw Exception('Precondition failed');

  @override
  Future<Result<int, Exception>> execute() async {
    return Result.success(42);
  }

  @override
  Result<int, Exception> onException(UsecaseException e) {
    return Result.failure(e);
  }
}

class StreamUsecaseTest extends StreamUsecase<int, int> {
  const StreamUsecaseTest();

  @override
  Stream<int> execute(int params) async* {
    yield params * 2;
  }
}

class BrokenPreconditionStreamUsecaseTest extends StreamUsecase<int, int> {
  const BrokenPreconditionStreamUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(int? params) =>
      throw Exception('Precondition failed');

  @override
  Stream<int> execute(int params) async* {
    yield params * 2;
  }
}

class NoParamsStreamUsecaseTest extends NoParamsStreamUsecase<int> {
  const NoParamsStreamUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(void params) async {
    return PreconditionsResult(isValid: globalPrecondition);
  }

  @override
  Stream<int> execute() async* {
    yield 42;
  }
}

class NoParamsDefaultStreamUsecaseTest extends NoParamsStreamUsecase<int> {
  const NoParamsDefaultStreamUsecaseTest();

  @override
  Stream<int> execute() async* {
    yield 42;
  }
}

class NoParamsBrokenPreconditionStreamUsecaseTest
    extends NoParamsStreamUsecase<int> {
  const NoParamsBrokenPreconditionStreamUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(void params) =>
      throw Exception('Precondition failed');

  @override
  Stream<int> execute() async* {
    yield 42;
  }
}

class ResultStreamUsecaseTest extends ResultStreamUsecase<int, int, Exception> {
  const ResultStreamUsecaseTest();

  @override
  Stream<Result<int, Exception>> execute(int params) async* {
    yield Result.success(params * 2);
  }

  @override
  Result<int, Exception> onException(UsecaseException e) {
    return Result.failure(e);
  }
}

class BrokenPreconditionResultStreamUsecaseTest
    extends ResultStreamUsecase<int, int, Exception> {
  const BrokenPreconditionResultStreamUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(int? params) =>
      throw Exception('Precondition failed');

  @override
  Stream<Result<int, Exception>> execute(int params) async* {
    yield Result.success(params * 2);
  }

  @override
  Result<int, Exception> onException(UsecaseException e) {
    return Result.failure(e);
  }
}

class NoParamsResultStreamUsecaseTest
    extends NoParamsResultStreamUsecase<int, Exception> {
  const NoParamsResultStreamUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(void params) async {
    return PreconditionsResult(isValid: globalPrecondition);
  }

  @override
  Stream<Result<int, Exception>> execute() async* {
    yield Result.success(42);
  }

  @override
  Result<int, Exception> onException(UsecaseException e) {
    return Result.failure(e);
  }
}

class NoParamsBrokenPreconditionResultStreamUsecaseTest
    extends NoParamsResultStreamUsecase<int, Exception> {
  const NoParamsBrokenPreconditionResultStreamUsecaseTest();

  @override
  FutureOr<PreconditionsResult> checkPrecondition(void params) =>
      throw Exception('Precondition failed');

  @override
  Stream<Result<int, Exception>> execute() async* {
    yield Result.success(42);
  }

  @override
  Result<int, Exception> onException(UsecaseException e) {
    return Result.failure(e);
  }
}

void main() {
  const usecaseTest = UsecaseTest();
  const brokenPreconditionUsecaseTest = BrokenPreconditionUsecaseTest();
  const noParamsUsecaseTest = NoParamsUsecaseTest();
  const noParamsDefaultUsecaseTest = NoParamsDefaultUsecaseTest();
  const noParamsBrokenPreconditionUsecaseTest =
      NoParamsBrokenPreconditionUsecaseTest();
  const resultUsecaseTest = ResultUsecaseTest();
  const brokenPreconditionResultUsecaseTest =
      BrokenPreconditionResultUsecaseTest();
  const noParamsResultUsecaseTest = NoParamsResultUsecaseTest();
  const noParamsBrokenPreconditionResultUsecaseTest =
      NoParamsBrokenPreconditionResultUsecaseTest();

  const streamUsecaseTest = StreamUsecaseTest();
  const brokenPreconditionStreamUsecaseTest =
      BrokenPreconditionStreamUsecaseTest();
  const noParamsStreamUsecaseTest = NoParamsStreamUsecaseTest();
  const noParamsDefaultStreamUsecaseTest = NoParamsDefaultStreamUsecaseTest();
  const noParamsBrokenPreconditionStreamUsecaseTest =
      NoParamsBrokenPreconditionStreamUsecaseTest();
  const resultStreamUsecaseTest = ResultStreamUsecaseTest();
  const brokenPreconditionResultStreamUsecaseTest =
      BrokenPreconditionResultStreamUsecaseTest();
  const noParamsResultStreamUsecaseTest = NoParamsResultStreamUsecaseTest();
  const noParamsBrokenPreconditionResultStreamUsecaseTest =
      NoParamsBrokenPreconditionResultStreamUsecaseTest();

  setUp(() {
    globalPrecondition = true;
  });

  group('Usecase', () {
    test('should return 4', () async {
      final int result = await usecaseTest(2);
      expect(result, 4);
    });

    test('should throw an exception on invalid precondition', () async {
      expect(() => usecaseTest(null), throwsA(isA<UsecaseException>()));
    });

    test('should throw an exception on broken precondition', () async {
      expect(() => brokenPreconditionUsecaseTest(2),
          throwsA(isA<UsecaseException>()));
    });

    test('with no params should return 42', () async {
      final int result = await noParamsUsecaseTest();
      expect(result, 42);
    });

    test('with no params should throw an exception on invalid precondition',
        () async {
      globalPrecondition = false;

      expect(() => noParamsUsecaseTest(), throwsA(isA<UsecaseException>()));
    });

    test('with no params should throw an exception on broken precondition',
        () async {
      expect(() => noParamsBrokenPreconditionUsecaseTest(),
          throwsA(isA<UsecaseException>()));
    });

    test('with no params should return 42 with default implementation',
        () async {
      final int result = await noParamsDefaultUsecaseTest();
      expect(result, 42);
    });
  });

  group('ResultUsecase', () {
    test('should return 4', () async {
      final Result<int, Exception> result = await resultUsecaseTest(2);
      expect(result, Result<int, Exception>.success(4));
    });

    test('should return a failure on invalid precondition', () async {
      final Result<int, Exception> result = await resultUsecaseTest(null);
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<UsecaseException>());
    });

    test('should return a failure on broken precondition', () async {
      final Result<int, Exception> result =
          await brokenPreconditionResultUsecaseTest(2);
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<UsecaseException>());
    });

    test('with no params should return 42', () async {
      final Result<int, Exception> result = await noParamsResultUsecaseTest();
      expect(result, Result<int, Exception>.success(42));
    });

    test('with no params should return a failure on invalid precondition',
        () async {
      globalPrecondition = false;

      final Result<int, Exception> result = await noParamsResultUsecaseTest();
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<UsecaseException>());
    });

    test('with no params should throw an exception on broken precondition',
        () async {
      final Result<int, Exception> result =
          await noParamsBrokenPreconditionResultUsecaseTest();
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<UsecaseException>());
    });
  });

  group('StreamUsecase', () {
    test('should return 4', () async {
      final int result = await streamUsecaseTest(2).first;
      expect(result, 4);
    });

    test('should throw an exception on invalid precondition', () async {
      final Stream<int> stream = streamUsecaseTest(null);

      expect(stream.first, throwsA(isA<UsecaseException>()));
    });

    test('should throw an exception on broken precondition', () async {
      final Stream<int> stream = brokenPreconditionStreamUsecaseTest(2);

      expect(stream.first, throwsA(isA<UsecaseException>()));
    });

    test('with no params should return 42', () async {
      final int result = await noParamsStreamUsecaseTest().first;
      expect(result, 42);
    });

    test('with no params should throw an exception on invalid precondition',
        () async {
      globalPrecondition = false;

      final Stream<int> stream = noParamsStreamUsecaseTest();

      expect(stream.first, throwsA(isA<UsecaseException>()));
    });

    test('with no params should throw an exception on broken precondition',
        () async {
      final Stream<int> stream = noParamsBrokenPreconditionStreamUsecaseTest();

      expect(stream.first, throwsA(isA<UsecaseException>()));
    });

    test('with no params should return 42 with default implementation',
        () async {
      final int result = await noParamsDefaultStreamUsecaseTest().first;
      expect(result, 42);
    });
  });

  group('ResultStreamUsecase', () {
    test('should return 4', () async {
      final Result<int, Exception> result =
          await resultStreamUsecaseTest(2).first;
      expect(result, Result<int, Exception>.success(4));
    });

    test('should return a failure on invalid precondition', () async {
      final Stream<Result<int, Exception>> stream =
          resultStreamUsecaseTest(null);

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<UsecaseException>());
    });

    test('should return a failure on broken precondition', () async {
      final Stream<Result<int, Exception>> stream =
          brokenPreconditionResultStreamUsecaseTest(2);

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<UsecaseException>());
    });

    test('with no params should return 42', () async {
      final Result<int, Exception> result =
          await noParamsResultStreamUsecaseTest().first;
      expect(result, Result<int, Exception>.success(42));
    });

    test('with no params should return a failure on invalid precondition',
        () async {
      globalPrecondition = false;

      final Stream<Result<int, Exception>> stream =
          noParamsResultStreamUsecaseTest();

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<UsecaseException>());
    });

    test('with no params should return a failure on broken precondition',
        () async {
      final Stream<Result<int, Exception>> stream =
          noParamsBrokenPreconditionResultStreamUsecaseTest();

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<UsecaseException>());
    });
  });
}
