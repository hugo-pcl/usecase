// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:generic_usecase/generic_usecase.dart';
import 'package:meta/meta.dart';
import 'package:sealed_result/sealed_result.dart';

/// {@template result_usecase}
/// A usecase that requires params of type [Input] and returns a result of type
/// [Output] or an error of type [Failure].
/// {@endtemplate}
abstract class ResultUsecase<Input, Output, Failure>
    extends Usecase<Input, Result<Output, Failure>> {
  /// {@macro result_usecase}
  const ResultUsecase() : super();

  @override
  @mustBeOverridden
  FutureOr<Result<Output, Failure>> onException(Object e) =>
      super.onException(e);
}

/// {@template no_params_result_usecase}
/// A usecase that does not require any params, but returns a result of type
/// [Output] or an error of type [Failure].
/// {@endtemplate}
abstract class NoParamsResultUsecase<Output, Failure>
    extends NoParamsUsecase<Result<Output, Failure>> {
  /// {@macro no_params_result_usecase}
  const NoParamsResultUsecase() : super();

  @override
  @mustBeOverridden
  FutureOr<Result<Output, Failure>> onException(Object e) =>
      super.onException(e);
}

/// {@template result_stream_usecase}
/// A stream usecase that requires params of type [Input] and returns a
/// stream of [Output] or [Failure].
/// {@endtemplate}
abstract class ResultStreamUsecase<Input, Output, Failure>
    extends StreamUsecase<Input, Result<Output, Failure>> {
  /// {@macro result_stream_usecase}
  const ResultStreamUsecase() : super();

  @override
  @mustBeOverridden
  FutureOr<Result<Output, Failure>> onException(Object e) =>
      super.onException(e);
}

/// {@template no_params_result_stream_usecase}
/// A stream usecase that does not require any params, but returns a
/// stream of [Output] or [Failure].
/// {@endtemplate}
abstract class NoParamsResultStreamUsecase<Output, Failure>
    extends NoParamsStreamUsecase<Result<Output, Failure>> {
  /// {@macro no_params_result_stream_usecase}
  const NoParamsResultStreamUsecase() : super();

  @override
  @mustBeOverridden
  FutureOr<Result<Output, Failure>> onException(Object e) =>
      super.onException(e);
}
