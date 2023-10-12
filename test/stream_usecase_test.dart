// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:generic_usecase/generic_usecase.dart';
import 'package:test/test.dart';

bool globalPrecondition = true;
bool globalPostcondition = true;

class StreamUsecaseTest extends StreamUsecase<int, int> {
  const StreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(int? params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(int? result) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Stream<int> execute(int params) async* {
    yield params * 2;
  }
}

class StreamUsecaseDefaultTest extends StreamUsecase<int, int> {
  const StreamUsecaseDefaultTest();

  @override
  Stream<int> execute(int params) async* {
    yield params * 2;
  }
}

class StreamUsecaseThrowTest extends StreamUsecase<int, int> {
  const StreamUsecaseThrowTest();

  @override
  Stream<int> execute(int params) async* {
    // ignore: only_throw_errors
    throw 'Error';
  }
}

class BrokenPreconditionsStreamUsecaseTest extends StreamUsecase<int, int> {
  const BrokenPreconditionsStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(int? params) =>
      throw ArgumentError('Preconditions failed');

  @override
  Stream<int> execute(int params) async* {
    yield params * 2;
  }
}

class BrokenPostconditionsStreamUsecaseTest extends StreamUsecase<int, int> {
  const BrokenPostconditionsStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPostconditions(int? result) =>
      throw ArgumentError('Postconditions failed');

  @override
  Stream<int> execute(int params) async* {
    yield params * 2;
  }
}

class NoParamsStreamUsecaseTest extends NoParamsStreamUsecase<int> {
  const NoParamsStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(int? result) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Stream<int> execute() async* {
    yield 42;
  }
}

class NoParamsBrokenPreconditionsStreamUsecaseTest
    extends NoParamsStreamUsecase<int> {
  const NoParamsBrokenPreconditionsStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) =>
      throw ArgumentError('Preconditions failed');

  @override
  Stream<int> execute() async* {
    yield 42;
  }
}

class NoParamsBrokenPostconditionsStreamUsecaseTest
    extends NoParamsStreamUsecase<int> {
  const NoParamsBrokenPostconditionsStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPostconditions(int? result) =>
      throw ArgumentError('Postconditions failed');

  @override
  Stream<int> execute() async* {
    yield 42;
  }
}

void main() {
  const streamUsecaseTest = StreamUsecaseTest();
  const streamUsecaseDefaultTest = StreamUsecaseDefaultTest();
  const streamUsecaseThrowTest = StreamUsecaseThrowTest();
  const brokenPreconditionsStreamUsecaseTest =
      BrokenPreconditionsStreamUsecaseTest();
  const brokenPostconditionsStreamUsecaseTest =
      BrokenPostconditionsStreamUsecaseTest();
  const noParamsStreamUsecaseTest = NoParamsStreamUsecaseTest();
  const noParamsBrokenPreconditionsStreamUsecaseTest =
      NoParamsBrokenPreconditionsStreamUsecaseTest();
  const noParamsBrokenPostconditionsStreamUsecaseTest =
      NoParamsBrokenPostconditionsStreamUsecaseTest();

  setUp(() {
    globalPrecondition = true;
    globalPostcondition = true;
  });

  group('StreamUsecase', () {
    test('should return 4', () async {
      final int result = await streamUsecaseTest(2).first;
      expect(result, 4);
    });

    test('should throw an exception on invalid preconditions', () async {
      globalPrecondition = false;
      final Stream<int> stream = streamUsecaseTest(null);

      expect(stream.first, throwsA(isA<InvalidPreconditionsException>()));
    });

    test('should throw an exception on invalid postconditions', () async {
      globalPostcondition = false;
      final Stream<int> stream = streamUsecaseTest(2);

      expect(stream.first, throwsA(isA<InvalidPostconditionsException>()));
    });

    test('should throw an exception on broken preconditions', () async {
      final Stream<int> stream = brokenPreconditionsStreamUsecaseTest(2);

      expect(stream.first, throwsA(isA<ArgumentError>()));
    });

    test('should throw an exception on broken postconditions', () async {
      final Stream<int> stream = brokenPostconditionsStreamUsecaseTest(2);

      expect(stream.first, throwsA(isA<ArgumentError>()));
    });

    test('with no params should return 42', () async {
      final int result = await noParamsStreamUsecaseTest().first;
      expect(result, 42);
    });

    test('with no params should throw an exception on invalid preconditions',
        () async {
      globalPrecondition = false;

      final Stream<int> stream = noParamsStreamUsecaseTest();

      expect(stream.first, throwsA(isA<InvalidPreconditionsException>()));
    });

    test('with no params should throw an exception on invalid postconditions',
        () async {
      globalPostcondition = false;

      final Stream<int> stream = noParamsStreamUsecaseTest();

      expect(stream.first, throwsA(isA<InvalidPostconditionsException>()));
    });

    test('with no params should throw an exception on broken preconditions',
        () async {
      final Stream<int> stream = noParamsBrokenPreconditionsStreamUsecaseTest();

      expect(stream.first, throwsA(isA<ArgumentError>()));
    });

    test('with no params should throw an exception on broken postconditions',
        () async {
      final Stream<int> stream =
          noParamsBrokenPostconditionsStreamUsecaseTest();

      expect(stream.first, throwsA(isA<ArgumentError>()));
    });

    test('should throw an exception on invalid preconditions using default',
        () async {
      final Stream<int> stream = streamUsecaseDefaultTest(null);

      expect(stream.first, throwsA(isA<InvalidPreconditionsException>()));
    });

    test('can throw anytype of exception', () async {
      expect(
        () => streamUsecaseThrowTest(2).first,
        throwsA(isA<Exception>()),
      );
    });
  });
}
