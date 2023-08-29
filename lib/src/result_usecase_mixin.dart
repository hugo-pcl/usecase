// Copyright 2023 Hugo Pointcheval
// 
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:sealed_result/sealed_result.dart';
import 'package:usecase/usecase.dart';

mixin ResultUsecaseMixin<Success, Failure> {
  /// Build an error result from a [UsecaseException]
  Result<Success, Failure> onException(UsecaseException e);
}
