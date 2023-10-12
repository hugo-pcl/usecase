// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:generic_usecase/generic_usecase.dart';
import 'package:sealed_result/sealed_result.dart';
import 'package:test/test.dart';

bool globalPrecondition = true;
bool globalPostcondition = true;

class ResultStreamUsecaseTest extends ResultStreamUsecase<int, int, Exception> {
  const ResultStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(int? params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Stream<Result<int, Exception>> execute(int params) async* {
    yield Result.success(params * 2);
  }

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

// ignore: missing_override_of_must_be_overridden
class ResultWithExceptionStreamUsecaseTest
    extends ResultStreamUsecase<int, int, Exception> {
  const ResultWithExceptionStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(int? params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Stream<Result<int, Exception>> execute(int params) async* {
    yield Result.success(params * 2);
  }
}

class BrokenPreconditionsResultStreamUsecaseTest
    extends ResultStreamUsecase<int, int, Exception> {
  const BrokenPreconditionsResultStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(int? params) =>
      throw Exception('Preconditions failed');

  @override
  Stream<Result<int, Exception>> execute(int params) async* {
    yield Result.success(params * 2);
  }

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

class BrokenPostconditionsResultStreamUsecaseTest
    extends ResultStreamUsecase<int, int, Exception> {
  const BrokenPostconditionsResultStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) =>
      throw Exception('Postconditions failed');

  @override
  Stream<Result<int, Exception>> execute(int params) async* {
    yield Result.success(params * 2);
  }

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

class NoParamsResultStreamUsecaseTest
    extends NoParamsResultStreamUsecase<int, Exception> {
  const NoParamsResultStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Stream<Result<int, Exception>> execute() async* {
    yield const Result.success(42);
  }

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

// ignore: missing_override_of_must_be_overridden
class NoParamsResultWithExceptionStreamUsecaseTest
    extends NoParamsResultStreamUsecase<int, Exception> {
  const NoParamsResultWithExceptionStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Stream<Result<int, Exception>> execute() async* {
    yield const Result.success(42);
  }
}

class NoParamsBrokenPreconditionsResultStreamUsecaseTest
    extends NoParamsResultStreamUsecase<int, Exception> {
  const NoParamsBrokenPreconditionsResultStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) =>
      throw Exception('Preconditions failed');

  @override
  Stream<Result<int, Exception>> execute() async* {
    yield const Result.success(42);
  }

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

class NoParamsBrokenPostconditionsResultStreamUsecaseTest
    extends NoParamsResultStreamUsecase<int, Exception> {
  const NoParamsBrokenPostconditionsResultStreamUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) =>
      throw Exception('Postconditions failed');

  @override
  Stream<Result<int, Exception>> execute() async* {
    yield const Result.success(42);
  }

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

void main() {
  const resultStreamUsecaseTest = ResultStreamUsecaseTest();
  const resultWithExceptionStreamUsecaseTest =
      ResultWithExceptionStreamUsecaseTest();
  const brokenPreconditionsResultStreamUsecaseTest =
      BrokenPreconditionsResultStreamUsecaseTest();
  const brokenPostconditionsResultStreamUsecaseTest =
      BrokenPostconditionsResultStreamUsecaseTest();
  const noParamsResultStreamUsecaseTest = NoParamsResultStreamUsecaseTest();
  const noParamsResultWithExceptionStreamUsecaseTest =
      NoParamsResultWithExceptionStreamUsecaseTest();
  const noParamsBrokenPreconditionsResultStreamUsecaseTest =
      NoParamsBrokenPreconditionsResultStreamUsecaseTest();
  const noParamsBrokenPostconditionsResultStreamUsecaseTest =
      NoParamsBrokenPostconditionsResultStreamUsecaseTest();

  setUp(() {
    globalPrecondition = true;
    globalPostcondition = true;
  });

  group('ResultStreamUsecase', () {
    test('should return 4', () async {
      final Result<int, Exception> result =
          await resultStreamUsecaseTest(2).first;
      expect(result, const Result<int, Exception>.success(4));
    });

    test('should return a failure on invalid preconditions', () async {
      globalPrecondition = false;

      final Stream<Result<int, Exception>> stream = resultStreamUsecaseTest(2);

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('should return a failure on invalid postconditions', () async {
      globalPostcondition = false;

      final Stream<Result<int, Exception>> stream = resultStreamUsecaseTest(2);

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('should return a failure on broken preconditions', () async {
      final Stream<Result<int, Exception>> stream =
          brokenPreconditionsResultStreamUsecaseTest(2);

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('should return a failure on broken postconditions', () async {
      final Stream<Result<int, Exception>> stream =
          brokenPostconditionsResultStreamUsecaseTest(2);

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('with no params should return 42', () async {
      final Result<int, Exception> result =
          await noParamsResultStreamUsecaseTest().first;
      expect(result, const Result<int, Exception>.success(42));
    });

    test('with no params should return a failure on invalid preconditions',
        () async {
      globalPrecondition = false;

      final Stream<Result<int, Exception>> stream =
          noParamsResultStreamUsecaseTest();

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('with no params should return a failure on invalid postconditions',
        () async {
      globalPostcondition = false;

      final Stream<Result<int, Exception>> stream =
          noParamsResultStreamUsecaseTest();

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('with no params should return a failure on broken preconditions',
        () async {
      final Stream<Result<int, Exception>> stream =
          noParamsBrokenPreconditionsResultStreamUsecaseTest();

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('with no params should return a failure on broken postconditions',
        () async {
      final Stream<Result<int, Exception>> stream =
          noParamsBrokenPostconditionsResultStreamUsecaseTest();

      final result = await stream.first;

      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test(
        'should throw an exception on invalid preconditions'
        ' when onException is not overriden', () async {
      globalPrecondition = false;

      final Stream<Result<int, Exception>> stream =
          resultWithExceptionStreamUsecaseTest(2);

      expect(stream.first, throwsA(isA<InvalidPreconditionsException>()));
    });

    test(
        'with no params should throw an exception on invalid preconditions'
        ' when onException is not overriden', () async {
      globalPrecondition = false;

      final Stream<Result<int, Exception>> stream =
          noParamsResultWithExceptionStreamUsecaseTest();

      expect(stream.first, throwsA(isA<InvalidPreconditionsException>()));
    });
  });
}
