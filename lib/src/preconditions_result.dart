// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

class PreconditionsResult {
  PreconditionsResult({
    required this.isValid,
    this.message = 'Requirements are not met',
  });

  final bool isValid;
  final String message;
}
