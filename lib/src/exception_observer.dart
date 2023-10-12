// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

/// {@template exception_observer}
/// A mixin that allows to handle exceptions
/// {@endtemplate}
mixin ExceptionObserver<Output> {
  /// {@template on_exception}
  /// Handle an exception.
  ///
  /// By default, it throws the exception.
  /// {@endtemplate}
  FutureOr<Output> onException(Object e) {
    if (e case Exception _) {
      throw e;
    }
    if (e case Error _) {
      throw e;
    }
    throw Exception(e);
  }
}
