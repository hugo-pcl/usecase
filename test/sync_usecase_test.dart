// Copyright 2026 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:generic_usecase/generic_usecase.dart';
import 'package:test/test.dart';

bool globalPrecondition = true;
bool globalPostcondition = true;

class SyncUsecaseTest extends SyncUsecase<int, int> {
  const SyncUsecaseTest();

  @override
  ConditionsResult checkPreconditions(void params) =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  ConditionsResult checkPostconditions(int? result) =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  int execute(int params) => params * 2;
}

class SyncUsecaseDefaultTest extends SyncUsecase<int, int> {
  const SyncUsecaseDefaultTest();

  @override
  int execute(int params) => params * 2;
}

class SyncUsecaseThrowTest extends SyncUsecase<int, int> {
  const SyncUsecaseThrowTest();

  @override
  // ignore: only_throw_errors
  int execute(int params) => throw 'Error';
}

class BrokenPreconditionsSyncUsecaseTest extends SyncUsecase<int, int> {
  const BrokenPreconditionsSyncUsecaseTest();

  @override
  ConditionsResult checkPreconditions(int? params) =>
      throw ArgumentError('Preconditions failed');

  @override
  int execute(int params) => params * 2;
}

class BrokenPostconditionsSyncUsecaseTest extends SyncUsecase<int, int> {
  const BrokenPostconditionsSyncUsecaseTest();

  @override
  ConditionsResult checkPostconditions(int? result) =>
      throw ArgumentError('Postconditions failed');

  @override
  int execute(int params) => params * 2;
}

class NoParamsSyncUsecaseTest extends NoParamsSyncUsecase<int> {
  const NoParamsSyncUsecaseTest();

  @override
  ConditionsResult checkPreconditions(void params) =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  ConditionsResult checkPostconditions(int? result) =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  int execute() => 42;
}

class NoParamsBrokenPreconditionsSyncUsecaseTest
    extends NoParamsSyncUsecase<int> {
  const NoParamsBrokenPreconditionsSyncUsecaseTest();

  @override
  ConditionsResult checkPreconditions(void params) =>
      throw ArgumentError('Preconditions failed');

  @override
  int execute() => 42;
}

class NoParamsBrokenPostconditionsSyncUsecaseTest
    extends NoParamsSyncUsecase<int> {
  const NoParamsBrokenPostconditionsSyncUsecaseTest();

  @override
  ConditionsResult checkPostconditions(int? result) =>
      throw ArgumentError('Postconditions failed');

  @override
  int execute() => 42;
}

void main() {
  const syncUsecaseTest = SyncUsecaseTest();
  const syncUsecaseDefaultTest = SyncUsecaseDefaultTest();
  const syncUsecaseThrowTest = SyncUsecaseThrowTest();
  const brokenPreconditionsSyncUsecaseTest =
      BrokenPreconditionsSyncUsecaseTest();
  const brokenPostconditionsSyncUsecaseTest =
      BrokenPostconditionsSyncUsecaseTest();
  const noParamsSyncUsecaseTest = NoParamsSyncUsecaseTest();
  const noParamsBrokenPreconditionsSyncUsecaseTest =
      NoParamsBrokenPreconditionsSyncUsecaseTest();
  const noParamsBrokenPostconditionsSyncUsecaseTest =
      NoParamsBrokenPostconditionsSyncUsecaseTest();

  setUp(() {
    globalPrecondition = true;
    globalPostcondition = true;
  });

  group('SyncUsecase', () {
    test('should return 4', () {
      final int result = syncUsecaseTest(2);
      expect(result, 4);
    });

    test('should throw an exception on invalid preconditions', () {
      globalPrecondition = false;
      expect(
        () => syncUsecaseTest(2),
        throwsA(isA<InvalidPreconditionsException>()),
      );
    });

    test('should throw an exception on invalid postconditions', () {
      globalPostcondition = false;
      expect(
        () => syncUsecaseTest(2),
        throwsA(isA<InvalidPostconditionsException>()),
      );
    });

    test('should throw an exception on broken preconditions', () {
      expect(
        () => brokenPreconditionsSyncUsecaseTest(2),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw an exception on broken postconditions', () {
      expect(
        () => brokenPostconditionsSyncUsecaseTest(2),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('with no params should return 42', () {
      final int result = noParamsSyncUsecaseTest();
      expect(result, 42);
    });

    test('with no params should throw an exception on invalid preconditions',
        () {
      globalPrecondition = false;

      expect(
        () => noParamsSyncUsecaseTest(),
        throwsA(isA<InvalidPreconditionsException>()),
      );
    });

    test('with no params should throw an exception on invalid postconditions',
        () {
      globalPostcondition = false;

      expect(
        () => noParamsSyncUsecaseTest(),
        throwsA(isA<InvalidPostconditionsException>()),
      );
    });

    test('with no params should throw an exception on broken preconditions',
        () {
      expect(
        () => noParamsBrokenPreconditionsSyncUsecaseTest(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('with no params should throw an exception on broken postconditions',
        () {
      expect(
        () => noParamsBrokenPostconditionsSyncUsecaseTest(),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw an exception on invalid preconditions using default',
        () {
      expect(
        () => syncUsecaseDefaultTest(null),
        throwsA(isA<InvalidPreconditionsException>()),
      );
    });

    test('can throw anytype of exception', () {
      expect(
        () => syncUsecaseThrowTest(2),
        throwsA(isA<Exception>()),
      );
    });

    test('should return 4 using default', () {
      final int result = syncUsecaseDefaultTest(2);
      expect(result, 4);
    });
  });
}
