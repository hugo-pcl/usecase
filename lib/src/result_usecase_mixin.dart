// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:generic_usecase/generic_usecase.dart';
import 'package:sealed_result/sealed_result.dart';

mixin ResultUsecaseMixin<Success, Failure> {
  /// Build an error result from a [UsecaseException]
  Result<Success, Failure> onException(UsecaseException e);
}
