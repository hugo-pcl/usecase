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

class UsecaseTest extends Usecase<int, int> {
  const UsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(int? result) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Future<int> execute(int params) async => params * 2;
}

class UsecaseDefaultTest extends Usecase<int, int> {
  const UsecaseDefaultTest();

  @override
  Future<int> execute(int params) async => params * 2;
}

class UsecaseThrowTest extends Usecase<int, int> {
  const UsecaseThrowTest();

  @override
  // ignore: only_throw_errors
  Future<int> execute(int params) async => throw 'Error';
}

class BrokenPreconditionsUsecaseTest extends Usecase<int, int> {
  const BrokenPreconditionsUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(int? params) =>
      throw ArgumentError('Preconditions failed');

  @override
  Future<int> execute(int params) async => params * 2;
}

class BrokenPostconditionsUsecaseTest extends Usecase<int, int> {
  const BrokenPostconditionsUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPostconditions(int? result) =>
      throw ArgumentError('Postconditions failed');

  @override
  Future<int> execute(int params) async => params * 2;
}

class NoParamsUsecaseTest extends NoParamsUsecase<int> {
  const NoParamsUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(int? result) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Future<int> execute() async => 42;
}

class NoParamsBrokenPreconditionsUsecaseTest extends NoParamsUsecase<int> {
  const NoParamsBrokenPreconditionsUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) =>
      throw ArgumentError('Preconditions failed');

  @override
  Future<int> execute() async => 42;
}

class NoParamsBrokenPostconditionsUsecaseTest extends NoParamsUsecase<int> {
  const NoParamsBrokenPostconditionsUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPostconditions(int? result) =>
      throw ArgumentError('Postconditions failed');

  @override
  Future<int> execute() async => 42;
}

void main() {
  const usecaseTest = UsecaseTest();
  const usecaseDefaultTest = UsecaseDefaultTest();
  const usecaseThrowTest = UsecaseThrowTest();
  const brokenPreconditionsUsecaseTest = BrokenPreconditionsUsecaseTest();
  const brokenPostconditionsUsecaseTest = BrokenPostconditionsUsecaseTest();
  const noParamsUsecaseTest = NoParamsUsecaseTest();
  const noParamsBrokenPreconditionsUsecaseTest =
      NoParamsBrokenPreconditionsUsecaseTest();
  const noParamsBrokenPostconditionsUsecaseTest =
      NoParamsBrokenPostconditionsUsecaseTest();

  setUp(() {
    globalPrecondition = true;
    globalPostcondition = true;
  });

  group('Usecase', () {
    test('should return 4', () async {
      final int result = await usecaseTest(2);
      expect(result, 4);
    });

    test('should throw an exception on invalid preconditions', () async {
      globalPrecondition = false;
      expect(
        () => usecaseTest(2),
        throwsA(isA<InvalidPreconditionsException>()),
      );
    });

    test('should throw an exception on invalid postconditions', () async {
      globalPostcondition = false;
      expect(
        () => usecaseTest(2),
        throwsA(isA<InvalidPostconditionsException>()),
      );
    });

    test('should throw an exception on broken preconditions', () async {
      expect(
        () => brokenPreconditionsUsecaseTest(2),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw an exception on broken postconditions', () async {
      expect(
        () => brokenPostconditionsUsecaseTest(2),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('with no params should return 42', () async {
      final int result = await noParamsUsecaseTest();
      expect(result, 42);
    });

    test('with no params should throw an exception on invalid preconditions',
        () async {
      globalPrecondition = false;

      expect(
        () => noParamsUsecaseTest(),
        throwsA(isA<InvalidPreconditionsException>()),
      );
    });

    test('with no params should throw an exception on invalid postconditions',
        () async {
      globalPostcondition = false;

      expect(
        () => noParamsUsecaseTest(),
        throwsA(isA<InvalidPostconditionsException>()),
      );
    });

    test('with no params should throw an exception on broken preconditions',
        () async {
      expect(
        () => noParamsBrokenPreconditionsUsecaseTest(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('with no params should throw an exception on broken postconditions',
        () async {
      expect(
        () => noParamsBrokenPostconditionsUsecaseTest(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw an exception on invalid preconditions using default',
        () async {
      expect(
        () => usecaseDefaultTest(null),
        throwsA(isA<InvalidPreconditionsException>()),
      );
    });

    test('can throw anytype of exception', () async {
      expect(
        () => usecaseThrowTest(2),
        throwsA(isA<Exception>()),
      );
    });

    test('should return 4 using default', () async {
      final int result = await usecaseDefaultTest(2);
      expect(result, 4);
    });
  });
}
