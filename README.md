<p align="center">
<img width="700px" src="https://raw.githubusercontent.com/hugo-pcl/usecase/main/resources/usecase_lib.png" style="background-color: rgb(255, 255, 255)">
<h5 align="center">Small component that encapsulates an application's scenario logic.</h5>
</p>

<p align="center">
<img src="https://img.shields.io/badge/SDK-Dart%20%7C%20Flutter-blue" alt="SDK: Dart & Flutter" />

<a href="https://github.com/invertase/melos">
<img src="https://img.shields.io/badge/Maintained%20with-melos-f700ff.svg" alt="Maintained with Melos" />
</a>

<a href="https://pub.dev/packages/generic_usecase">
<img src="https://img.shields.io/pub/v/generic_usecase" alt="Pub.dev" />
</a>

<a href="https://drone.wyatt-studio.fr/hugo/usecase">
  <img src="https://drone.wyatt-studio.fr/api/badges/hugo/usecase/status.svg?ref=refs/heads/main" />
</a>

</p>

---

[[Changelog]](./CHANGELOG.md) | [[License]](./LICENSE)

---

## Introduction

Playing around with the clean architecture, I often found myself rewriting the generic code of my usecases.

These class enable you to encapsulate your logic in an atomic elements that you can then inject and use throughout your application.

## Features

* [x] Simple and easy to use API
* [x] Fully tested (100% coverage)
* [x] Fully documented
* [x] `sealed_result` compatible (see [sealed_result](https://pub.dev/packages/sealed_result))

Available usecase types:

* `Usecase<Input, Output>`
* `NoParamsUsecase<Output>`
* `StreamUsecase<Input, Output>`
* `NoParamsStreamUsecase<Output>`

* Result usecase types:
  + `ResultUsecase<Input, Output, Failure>`
  + `NoParamsResultUsecase<Output, Failure>`
  + `ResultStreamUsecase<Input, Output, Failure>`
  + `NoParamsResultStreamUsecase<Output, Failure>`

## Usage

### Simple usecase

Let's say you want to add two numbers together, you can create a usecase like this:

```dart
class AdditionUsecase extends Usecase<int, int> {
  const AdditionUsecase();

  @override
  Future<int> execute(int params) async => params + params;
}
```

The `execute` method is the one that will be called when you call the `call` method on your usecase.

```dart
final addition = AdditionUsecase();
await addition(2).then(print, onError: print); // 4
```

### Using a stream usecase

You can use a stream usecase to return a `Stream` instead of a raw value:

```dart
class GeneratorUsecase extends NoParamsStreamUsecase<int> {
  const GeneratorUsecase();

  @override
  Stream<int> execute() async* {
    for (int i = 0; i < 10; i++) {
      await Future<void>.delayed(const Duration(seconds: 1));
      yield i;
    }
  }
}
```

You can then use it like this:

```dart
final generator = GeneratorUsecase();
final stream = generator();

stream.listen(
  print,
  onError: print,
  onDone: () => print('Done'),
);
```

### Checking preconditions and postconditions

You can add a precondition check to your usecase, which will be executed before the `execute` method:

```dart
class DivisionUsecase extends Usecase<(int, int), double> {
  const DivisionUsecase();

  @override
  FutureOr<ConditionsResult> checkPreconditions((int, int)? params) {
    if (params == null) {
      return ConditionsResult(isValid: false, message: 'Params is null');
    }

    if (params.$2 == 0) {
      return ConditionsResult(isValid: false, message: 'Cannot divide by 0');
    }

    return ConditionsResult(isValid: true);
  }

  @override
  Future<double> execute((int, int) params) async => params.$1 / params.$2;
}
```

You can also add a postcondition check to your usecase, which will be executed after the `execute` method:

```dart
class AdditionUsecase extends Usecase<int, int> {
  const AdditionUsecase();

  @override
  Future<int> execute(int params) async => params + params;

  @override
  FutureOr<ConditionsResult> checkPostconditions(int? result) {
    if (result == null) {
      return ConditionsResult(isValid: false, message: 'Result is null');
    }

    if (result < 0) {
      return ConditionsResult(isValid: false, message: 'Result is negative');
    }

    return ConditionsResult(isValid: true);
  }
}
```

### Catching exceptions

You can catch exceptions thrown by your usecase by overriding the `onException` method:

```dart
class AdditionUsecase extends Usecase<int, int> {
  const AdditionUsecase();

  @override
  Future<int> execute(int params) async => params + params;

  @override
  FutureOr<int> onException(Object e) {
    print(e); // Prints the exception
    return super.onException(e);
  }
}
```

This method will be called when an exception is thrown by the `execute` method. It will also be called when a precondition or postcondition check fails.

### Using a Result

By assembling the previous examples, you can create a usecase that returns a `Result` object. By catching exceptions and checking preconditions and postconditions, you can return a `Result` object that will be either a `Success` or a `Failure` :

> This example uses the [sealed_result](https://pub.dev/packages/sealed_result) package.

```dart
class DivisionResultUsecase extends ResultUsecase<(int, int), double, Failure> {
  const DivisionResultUsecase();

  @override
  FutureOr<ConditionsResult> checkPreconditions((int, int)? params) {
    if (params == null) {
      return ConditionsResult(isValid: false, message: 'Params is null');
    }

    if (params.$2 == 0) {
      return ConditionsResult(isValid: false, message: 'Cannot divide by 0');
    }

    return ConditionsResult(isValid: true);
  }

  @override
  Future<Result<double, Failure>> execute((int, int) params) async =>
      Result.success(params.$1 / params.$2);

  @override
  FutureOr<Result<double, Failure>> onException(Object e) {
    if (e case UsecaseException _) {
      return Result.failure(Failure(e.message ?? ''));
    }
    if (e case Exception || Error) {
      return Result.failure(Failure(e.toString()));
    }
    return Result.failure(Failure(''));
  }
}
```
