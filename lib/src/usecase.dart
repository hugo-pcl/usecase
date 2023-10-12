// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:generic_usecase/generic_usecase.dart';
import 'package:meta/meta.dart';

/// Base class for all usecases.
///
/// This carries the mixins that are used by all usecases.
abstract class _Usecase<Input, Output>
    with ConditionsObserver<Input, Output>, ExceptionObserver<Output> {
  const _Usecase._();
}

/// {@template usecase}
/// A usecase that requires params of type [Input] and returns a result of type
/// [Output].
/// {@endtemplate}
abstract class Usecase<Input, Output> extends _Usecase<Input, Output>
    with UsecaseExecutor<Input, Output> {
  /// {@macro usecase}
  const Usecase() : super._();

  /// This method is called before the execution of the usecase.
  ///
  /// By default, it returns true if the input is not null.
  @override
  FutureOr<ConditionsResult> checkPreconditions(Input? params) {
    if (params == null) {
      return ConditionsResult(isValid: false, message: 'Params is null');
    }
    return super.checkPreconditions(params);
  }

  /// Execute the usecase with the given params
  ///
  /// Must be implemented by subclasses but should not be called directly.
  @visibleForOverriding
  Future<Output> execute(Input params);

  /// Call the usecase with the given params
  Future<Output> call(Input? params) async => executeWithConditions(
        params,
        executor: () async => execute(params as Input),
        onException: onException,
      );
}

/// {@template no_params_usecase}
/// A usecase that does not require any params, but returns a result of type
/// [Output].
/// {@endtemplate}
abstract class NoParamsUsecase<Output> extends _Usecase<void, Output>
    with UsecaseExecutor<void, Output> {
  /// {@macro no_params_usecase}
  const NoParamsUsecase() : super._();

  /// Execute the usecase with the given params
  ///
  /// Must be implemented by subclasses but should not be called directly.
  @visibleForOverriding
  Future<Output> execute();

  /// Call the usecase
  Future<Output> call() async => executeWithConditions(
        null,
        executor: execute,
        onException: onException,
      );
}

/// {@template stream_usecase}
/// A stream usecase that requires params of type [Input] and returns a
/// stream of [Output].
/// {@endtemplate}
abstract class StreamUsecase<Input, Output> extends _Usecase<Input, Output>
    with UsecaseStreamExecutor<Input, Output> {
  /// {@macro stream_usecase}
  const StreamUsecase() : super._();

  /// This method is called before the execution of the usecase.
  ///
  /// By default, it returns if the input is not null.
  @override
  FutureOr<ConditionsResult> checkPreconditions(Input? params) {
    if (params == null) {
      return ConditionsResult(isValid: false, message: 'Params is null');
    }
    return super.checkPreconditions(params);
  }

  /// Execute the usecase with the given params
  ///
  /// Must be implemented by subclasses but should not be called directly.
  @visibleForOverriding
  Stream<Output> execute(Input params);

  /// Call the usecase with the given params
  Stream<Output> call(Input? params) async* {
    yield* executeWithConditions(
      params,
      executor: () => execute(params as Input),
      onException: onException,
    );
  }
}

/// {@template no_params_stream_usecase}
/// A stream usecase that does not require any params, but returns a
/// stream of [Output].
/// {@endtemplate}
abstract class NoParamsStreamUsecase<Output> extends _Usecase<void, Output>
    with UsecaseStreamExecutor<void, Output> {
  /// {@macro no_params_stream_usecase}
  const NoParamsStreamUsecase() : super._();

  /// Execute the usecase with the given params
  ///
  /// Must be implemented by subclasses but should not be called directly.
  @visibleForOverriding
  Stream<Output> execute();

  /// Call the usecase
  Stream<Output> call() async* {
    yield* executeWithConditions(
      null,
      executor: execute,
      onException: onException,
    );
  }
}
