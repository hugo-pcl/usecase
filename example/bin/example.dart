// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:example/example.dart';

Future<void> main(List<String> arguments) async {
  print('AdditionUsecase');

  final AdditionUsecase addition = const AdditionUsecase();

  print('> addition(null)');
  await addition(null).then((value) => print(value), onError: (e) => print(e));

  print('> addition(2)');
  await addition(2).then((value) => print(value), onError: (e) => print(e));

  print('DivisionUsecase');

  final DivisionUsecase division = const DivisionUsecase();

  print('> division(null)');
  await division(null).then((value) => print(value), onError: (e) => print(e));

  print('> division((2, 0))');
  await division((2, 0))
      .then((value) => print(value), onError: (e) => print(e));

  print('> division((4, 2))');
  await division((4, 2))
      .then((value) => print(value), onError: (e) => print(e));

  print('BooleanResultUsecase');
  final BooleanResultUsecase boolean = const BooleanResultUsecase();

  print('> boolean()');
  await boolean().then((value) => print(value), onError: (e) => print(e));

  print('DivisionResultUsecase');

  final DivisionResultUsecase divisionResult = const DivisionResultUsecase();

  print('> divisionResult(null)');
  await divisionResult(null)
      .then((value) => print(value), onError: (e) => print(e));

  print('> divisionResult((2, 0))');
  await divisionResult((2, 0))
      .then((value) => print(value), onError: (e) => print(e));

  print('> divisionResult((4, 2))');
  await divisionResult((4, 2))
      .then((value) => print(value), onError: (e) => print(e));

  print('GeneratorUsecase');

  final GeneratorUsecase generator = const GeneratorUsecase();

  print('> generator()');
  generator().listen(
    (event) {
      print('>> generator: $event');
    },
    onError: (e) => print('>> generator (error): $e'),
  );

  print('RxDartGeneratorUsecase');

  final RxDartGeneratorUsecase rxDartGenerator = const RxDartGeneratorUsecase();

  print('> rxDartGenerator()');

  rxDartGenerator().listen((event) {
    print(">> rxDartGenerator: $event");
  }, onError: (e) => print('>> rxDartGenerator (error): $e'));
}
