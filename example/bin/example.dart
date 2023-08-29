// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:example/example.dart';

void main(List<String> arguments) {
  final AdditionUsecase addition = const AdditionUsecase();

  addition(2).then((value) => print(value));
  addition(null).then((value) => print(value), onError: (e) => print(e));

  final GeneratorUsecase generator = const GeneratorUsecase();

  generator().listen((event) {
    print(event);
  });

  final DangerousUsecase dangerous = DangerousUsecase();

  dangerous(null).then((value) => print(value), onError: (e) => print(e));
  dangerous(0).then((value) => print(value), onError: (e) => print(e));
  dangerous(2).then((value) => print(value), onError: (e) => print(e));

  final ListenerUsecase listener = ListenerUsecase();

  listener().listen((event) {
    print(event);
  });
}
