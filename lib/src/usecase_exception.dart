// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:meta/meta.dart';

/// {@template usecase_exception}
/// [UsecaseException] is sometimes threw by Usecases operations.
///
/// ```dart
/// throw const UsecaseException('Emergency failure!');
/// ```
/// {@endtemplate}
@immutable
class UsecaseException implements Exception {
  /// {@macro usecase_exception}
  const UsecaseException([this.message]);

  /// The message of the exception.
  final String? message;

  @mustBeOverridden
  String get prefix => 'UsecaseException';

  @override
  String toString() => '$prefix${message != null ? ': $message' : ''}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsecaseException &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

/// {@template invalid_preconditions_exception}
/// [InvalidPreconditionsException] is threw when the preconditions of a
/// Usecase are not met.
/// {@endtemplate}
class InvalidPreconditionsException extends UsecaseException {
  /// {@macro invalid_preconditions_exception}
  const InvalidPreconditionsException([super.message]);

  @override
  String get prefix => 'InvalidPreconditionsException';
}

/// {@template invalid_postconditions_exception}
/// [InvalidPostconditionsException] is threw when the postconditions of a
/// Usecase are not met.
/// {@endtemplate}
class InvalidPostconditionsException extends UsecaseException {
  /// {@macro invalid_postconditions_exception}
  const InvalidPostconditionsException([super.message]);

  @override
  String get prefix => 'InvalidPostconditionsException';
}

/// {@template stream_usecase_exception}
/// [StreamUsecaseException] is sometimes threw by Stream Usecases operations.
/// {@endtemplate}
class StreamUsecaseException extends UsecaseException {
  /// {@macro stream_usecase_exception}
  const StreamUsecaseException([super.message]);

  @override
  String get prefix => 'StreamUsecaseException';
}
