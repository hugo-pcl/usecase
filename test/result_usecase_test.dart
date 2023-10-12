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

class ResultUsecaseTest extends ResultUsecase<int, int, Exception> {
  const ResultUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(int? params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Future<Result<int, Exception>> execute(int params) async =>
      Result.success(params * 2);

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

// ignore: missing_override_of_must_be_overridden
class ResultWithExceptionUsecaseTest
    extends ResultUsecase<int, int, Exception> {
  const ResultWithExceptionUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(int? params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Future<Result<int, Exception>> execute(int params) async =>
      Result.success(params * 2);
}

class BrokenPreconditionsResultUsecaseTest
    extends ResultUsecase<int, int, Exception> {
  const BrokenPreconditionsResultUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(int? params) =>
      throw Exception('Preconditions failed');

  @override
  Future<Result<int, Exception>> execute(int params) async =>
      Result.success(params * 2);

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

class BrokenPostconditionsResultUsecaseTest
    extends ResultUsecase<int, int, Exception> {
  const BrokenPostconditionsResultUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) =>
      throw Exception('Postconditions failed');

  @override
  Future<Result<int, Exception>> execute(int params) async =>
      Result.success(params * 2);

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

class NoParamsResultUsecaseTest extends NoParamsResultUsecase<int, Exception> {
  const NoParamsResultUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Future<Result<int, Exception>> execute() async => const Result.success(42);

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

// ignore: missing_override_of_must_be_overridden
class NoParamsResultWithExceptionUsecaseTest
    extends NoParamsResultUsecase<int, Exception> {
  const NoParamsResultWithExceptionUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) async =>
      ConditionsResult(isValid: globalPrecondition);

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) async =>
      ConditionsResult(isValid: globalPostcondition);

  @override
  Future<Result<int, Exception>> execute() async => const Result.success(42);
}

class NoParamsBrokenPreconditionsResultUsecaseTest
    extends NoParamsResultUsecase<int, Exception> {
  const NoParamsBrokenPreconditionsResultUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPreconditions(void params) =>
      throw Exception('Preconditions failed');

  @override
  Future<Result<int, Exception>> execute() async => const Result.success(42);

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

class NoParamsBrokenPostconditionsResultUsecaseTest
    extends NoParamsResultUsecase<int, Exception> {
  const NoParamsBrokenPostconditionsResultUsecaseTest();

  @override
  FutureOr<ConditionsResult> checkPostconditions(
    Result<int, Exception>? result,
  ) =>
      throw Exception('Postconditions failed');

  @override
  Future<Result<int, Exception>> execute() async => const Result.success(42);

  @override
  FutureOr<Result<int, Exception>> onException(Object e) =>
      Result.failure(e as Exception);
}

void main() {
  const resultUsecaseTest = ResultUsecaseTest();
  const resultWithExceptionUsecaseTest = ResultWithExceptionUsecaseTest();
  const brokenPreconditionsResultUsecaseTest =
      BrokenPreconditionsResultUsecaseTest();
  const brokenPostconditionsResultUsecaseTest =
      BrokenPostconditionsResultUsecaseTest();
  const noParamsResultUsecaseTest = NoParamsResultUsecaseTest();
  const noParamsResultWithExceptionUsecaseTest =
      NoParamsResultWithExceptionUsecaseTest();
  const noParamsBrokenPreconditionsResultUsecaseTest =
      NoParamsBrokenPreconditionsResultUsecaseTest();
  const noParamsBrokenPostconditionsResultUsecaseTest =
      NoParamsBrokenPostconditionsResultUsecaseTest();

  setUp(() {
    globalPrecondition = true;
    globalPostcondition = true;
  });

  group('ResultUsecase', () {
    test('should return 4', () async {
      final Result<int, Exception> result = await resultUsecaseTest(2);
      expect(result, const Result<int, Exception>.success(4));
    });

    test('should return a failure on invalid preconditions', () async {
      globalPrecondition = false;

      final Result<int, Exception> result = await resultUsecaseTest(2);
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('should return a failure on invalid postconditions', () async {
      globalPostcondition = false;

      final Result<int, Exception> result = await resultUsecaseTest(2);
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('should return a failure on broken preconditions', () async {
      final Result<int, Exception> result =
          await brokenPreconditionsResultUsecaseTest(2);
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('should return a failure on broken postconditions', () async {
      final Result<int, Exception> result =
          await brokenPostconditionsResultUsecaseTest(2);
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('with no params should return 42', () async {
      final Result<int, Exception> result = await noParamsResultUsecaseTest();
      expect(result, const Result<int, Exception>.success(42));
    });

    test('with no params should return a failure on invalid preconditions',
        () async {
      globalPrecondition = false;

      final Result<int, Exception> result = await noParamsResultUsecaseTest();
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('with no params should return a failure on invalid postconditions',
        () async {
      globalPostcondition = false;

      final Result<int, Exception> result = await noParamsResultUsecaseTest();
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('with no params should throw an exception on broken preconditions',
        () async {
      final Result<int, Exception> result =
          await noParamsBrokenPreconditionsResultUsecaseTest();
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test('with no params should throw an exception on broken postconditions',
        () async {
      final Result<int, Exception> result =
          await noParamsBrokenPostconditionsResultUsecaseTest();
      expect(result.isErr, true);
      expect(result.unwrapErr(), isA<Exception>());
    });

    test(
        'should throw an exception on invalid preconditions'
        ' if onException is not overriden', () async {
      globalPrecondition = false;

      expect(
        () async => resultWithExceptionUsecaseTest(2),
        throwsA(isA<Exception>()),
      );
    });

    test(
        'with no params should throw an exception on invalid preconditions'
        ' if onException is not overriden', () async {
      globalPrecondition = false;

      expect(
        () async => noParamsResultWithExceptionUsecaseTest(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
