// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

Future<void> display<T>(FutureOr<T> Function() f) async {
  try {
    print(await f.call());
  } catch (e) {
    print(e);
  }
}
