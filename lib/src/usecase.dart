// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:sealed_result/sealed_result.dart';
import 'package:usecase/usecase.dart';

abstract class _Usecase<Input, Output> {
  const _Usecase._();

  /// {@template check_precondition}
  /// Check if the usecase can be executed with the given params
  /// {@endtemplate}
  FutureOr<PreconditionsResult> checkPrecondition(Input? params);
}

/// {@template usecase}
/// A usecase that requires params of type [Input] and returns a result of type
/// [Output].
/// {@endtemplate}
abstract class Usecase<Input, Output> extends _Usecase<Input, Output> {
  /// {@macro usecase}
  const Usecase() : super._();

  /// {@macro check_precondition}
  ///
  /// By default, it returns true if params is not null.
  ///
  /// Override this method to change the behavior.
  @override
  FutureOr<PreconditionsResult> checkPrecondition(Input? params) async {
    if (params != null) {
      return PreconditionsResult(isValid: true);
    } else {
      return PreconditionsResult(
          isValid: false, message: 'Params cannot be null');
    }
  }

  /// Execute the usecase with the given params
  ///
  /// Must be implemented by subclasses but should not be called directly.
  @visibleForOverriding
  Future<Output> execute(Input params);

  /// Call the usecase with the given params
  Future<Output> call(Input? params) async {
    PreconditionsResult condition;

    try {
      condition = await checkPrecondition(params);
    } catch (e) {
      throw PreconditionsException(
          'An error occured during the preconditions check: $e');
    }

    if (condition.isValid) {
      return execute(params as Input);
    } else {
      throw InvalidPreconditionsException(
          'Invalid preconditions: ${condition.message}');
    }
  }
}

/// {@template no_params_usecase}
/// A usecase that does not require any params, but returns a result of type
/// [Output].
/// {@endtemplate}
abstract class NoParamsUsecase<Output> extends _Usecase<void, Output> {
  /// {@macro no_params_usecase}
  const NoParamsUsecase() : super._();

  /// {@macro check_precondition}
  ///
  /// By default, it returns true.
  ///
  /// Override this method to change the behavior.
  @override
  FutureOr<PreconditionsResult> checkPrecondition(void params) {
    return Future.value(PreconditionsResult(isValid: true));
  }

  /// Execute the usecase with the given params
  ///
  /// Must be implemented by subclasses but should not be called directly.
  @visibleForOverriding
  Future<Output> execute();

  /// Call the usecase
  Future<Output> call() async {
    PreconditionsResult condition;

    try {
      condition = await checkPrecondition(null);
    } catch (e) {
      throw PreconditionsException(
          'An error occured during the preconditions check: $e');
    }

    if (condition.isValid) {
      return execute();
    } else {
      throw InvalidPreconditionsException(
          'Invalid preconditions: ${condition.message}');
    }
  }
}

/// {@template result_usecase}
/// A usecase that requires params of type [Input] and returns a result of type
/// [Output] or an error of type [Failure].
/// {@endtemplate}
abstract class ResultUsecase<Input, Output, Failure>
    extends Usecase<Input, Result<Output, Failure>>
    with ResultUsecaseMixin<Output, Failure> {
  /// {@macro result_usecase}
  const ResultUsecase() : super();

  /// Call the usecase with the given params
  Future<Result<Output, Failure>> call(Input? params) async {
    PreconditionsResult condition;

    try {
      condition = await checkPrecondition(params);
    } catch (e) {
      return onException(PreconditionsException(
          'An error occured during the preconditions check: $e'));
    }

    if (condition.isValid) {
      return execute(params as Input);
    } else {
      return onException(InvalidPreconditionsException(
          'Invalid preconditions: ${condition.message}'));
    }
  }
}

/// {@template no_params_result_usecase}
/// A usecase that does not require any params, but returns a result of type
/// [Output] or an error of type [Failure].
/// {@endtemplate}
abstract class NoParamsResultUsecase<Output, Failure>
    extends NoParamsUsecase<Result<Output, Failure>>
    with ResultUsecaseMixin<Output, Failure> {
  /// {@macro no_params_result_usecase}
  const NoParamsResultUsecase() : super();

  /// Call the usecase
  Future<Result<Output, Failure>> call() async {
    PreconditionsResult condition;

    try {
      condition = await checkPrecondition(null);
    } catch (e) {
      return onException(PreconditionsException(
          'An error occured during the preconditions check: $e'));
    }

    if (condition.isValid) {
      return execute();
    } else {
      return onException(InvalidPreconditionsException(
          'Invalid preconditions: ${condition.message}'));
    }
  }
}
