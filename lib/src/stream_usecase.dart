// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:meta/meta.dart';
import 'package:sealed_result/sealed_result.dart';
import 'package:usecase/src/result_usecase_mixin.dart';
import 'package:usecase/src/usecase_exception.dart';

abstract class _StreamUsecase<Input, Output> {
  const _StreamUsecase._();

  /// {@template check_precondition}
  /// Check if the usecase can be executed with the given params
  /// {@endtemplate}
  Future<bool> checkPrecondition(Input? params) async => true;
}

/// {@template stream_usecase}
/// A stream usecase that requires params of type [Input] and returns a
/// stream of [Output].
/// {@endtemplate}
abstract class StreamUsecase<Input, Output>
    extends _StreamUsecase<Input, Output> {
  /// {@macro stream_usecase}
  const StreamUsecase() : super._();

  /// {@macro check_precondition}
  ///
  /// By default, it returns true if params is not null.
  ///
  /// Override this method to change the behavior.
  @override
  Future<bool> checkPrecondition(Input? params) async => true;

  /// Execute the usecase with the given params
  ///
  /// Must be implemented by subclasses but should not be called directly.
  @visibleForOverriding
  Stream<Output> execute(Input params);

  /// Call the usecase with the given params
  Stream<Output> call(Input? params) async* {
    if (await checkPrecondition(params)) {
      yield* execute(params as Input);
    } else {
      throw StreamUsecaseException('Invalid preconditions');
    }
  }
}

/// {@template no_params_stream_usecase}
/// A stream usecase that does not require any params, but returns a
/// stream of [Output].
/// {@endtemplate}
abstract class NoParamsStreamUsecase<Output>
    extends _StreamUsecase<void, Output> {
  /// {@macro no_params_stream_usecase}
  const NoParamsStreamUsecase() : super._();

  /// {@macro check_precondition}
  ///
  /// By default, it returns true.
  ///
  /// Override this method to change the behavior.
  @override
  Future<bool> checkPrecondition(void params) async => true;

  /// Execute the usecase with the given params
  ///
  /// Must be implemented by subclasses but should not be called directly.
  @visibleForOverriding
  Stream<Output> execute();

  /// Call the usecase
  Stream<Output> call() async* {
    if (await checkPrecondition(null)) {
      yield* execute();
    } else {
      throw StreamUsecaseException('Invalid preconditions');
    }
  }
}

/// {@template result_stream_usecase}
/// A stream usecase that requires params of type [Input] and returns a
/// stream of [Output] or [Failure].
/// {@endtemplate}
abstract class ResultStreamUsecase<Input, Output, Failure>
    extends StreamUsecase<Input, Result<Output, Failure>>
    with ResultUsecaseMixin<Output, Failure> {
  /// {@macro result_stream_usecase}
  const ResultStreamUsecase() : super();

  /// Call the usecase with the given params
  Stream<Result<Output, Failure>> call(Input? params) async* {
    if (await checkPrecondition(params)) {
      yield* execute(params as Input);
    } else {
      yield onException(StreamUsecaseException('Invalid preconditions'));
    }
  }
}

/// {@template no_params_result_stream_usecase}
/// A stream usecase that does not require any params, but returns a
/// stream of [Output] or [Failure].
/// {@endtemplate}
abstract class NoParamsResultStreamUsecase<Output, Failure>
    extends NoParamsStreamUsecase<Result<Output, Failure>>
    with ResultUsecaseMixin<Output, Failure> {
  /// {@macro no_params_result_stream_usecase}
  const NoParamsResultStreamUsecase() : super();

  /// Call the usecase
  Stream<Result<Output, Failure>> call() async* {
    if (await checkPrecondition(null)) {
      yield* execute();
    } else {
      yield onException(StreamUsecaseException('Invalid preconditions'));
    }
  }
}
