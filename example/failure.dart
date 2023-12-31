// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

class Failure implements Exception {
  Failure(this.message);

  final String message;

  @override
  String toString() => message;
}
