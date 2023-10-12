// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:generic_usecase/generic_usecase.dart';

/// {@template conditions_observer}
/// A mixin that allows to check preconditions and postconditions
/// of a use case.
/// {@endtemplate}
mixin ConditionsObserver<Input, Output> {
  /// {@template check_preconditions}
  /// Check conditions required for the case to apply
  ///
  /// By default, it returns true.
  /// {@endtemplate}
  FutureOr<ConditionsResult> checkPreconditions(Input? params) =>
      ConditionsResult(isValid: true);

  /// {@template check_postconditions}
  /// Check consequences of successful system application
  /// of the use case
  ///
  /// By default, it returns true.
  /// {@endtemplate}
  FutureOr<ConditionsResult> checkPostconditions(Output? result) =>
      ConditionsResult(isValid: true);
}
