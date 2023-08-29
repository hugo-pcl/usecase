<p align="center">
<img width="700px" src="./resources/usecase_lib.png" style="background-color: rgb(255, 255, 255)">
<h5 align="center">Small component that encapsulates an application's scenario logic.</h5>
</p>

<p align="center">
<img src="https://img.shields.io/badge/SDK-Dart%20%7C%20Flutter-blue" alt="SDK: Dart & Flutter" />

<a href="https://github.com/invertase/melos">
<img src="https://img.shields.io/badge/Maintained%20with-melos-f700ff.svg" alt="Maintained with Melos" />
</a>

<a href="https://pub.dev/packages/usecase">
<img src="https://img.shields.io/pub/v/usecase" alt="Pub.dev" />
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
* `ResultUsecase<Input, Output, Failure>`
* `NoParamsResultUsecase<Output, Failure>`
* `StreamUsecase<Input, Output>`
* `NoParamsStreamUsecase<Output>`
* `StreamResultUsecase<Input, Output, Failure>`
* `NoParamsStreamResultUsecase<Output, Failure>`

## Usage

### Simple usecase

Let's say you want to add two numbers together, you can create a usecase like this:

```dart
class AdditionUsecase extends Usecase<int, int> {
  const AdditionUsecase();

  @override
  Future<int> execute(int params) async {
    return params + params;
  }
}
```

The `execute` method is the one that will be called when you call the `call` method on your usecase.

```dart
final usecase = AdditionUsecase();
final result = await usecase(2);
print(result); // 4
```

### Checking preconditions

You can add a precondition check to your usecase, which will be executed before the `execute` method:

```dart
class DivisionUsecase extends Usecase<(int, int), double> {
  const DivisionUsecase();

  @override
  FutureOr<PreconditionsResult> checkPrecondition((int, int)? params) {
    if (params == null) {
      return PreconditionsResult(isValid: false, message: 'Params is null');
    }

    if (params.$2 == 0) {
      return PreconditionsResult(isValid: false, message: 'Cannot divide by 0');
    }

    return PreconditionsResult(isValid: true);
  }

  @override
  Future<double> execute((int, int) params) async {
    return params.$1 / params.$2;
  }
}
```

### Using a result

You can use a result (see [sealed_result](https://pub.dev/packages/sealed_result)) usecase to return a `Result` object instead of a raw value:

```dart
class DivisionResultUsecase extends ResultUsecase<(int, int), double, Failure> {
  const DivisionResultUsecase();

  @override
  FutureOr<PreconditionsResult> checkPrecondition((int, int)? params) {
    if (params == null) {
      return PreconditionsResult(isValid: false, message: 'Params is null');
    }

    if (params.$2 == 0) {
      return PreconditionsResult(isValid: false, message: 'Cannot divide by 0');
    }

    return PreconditionsResult(isValid: true);
  }

  @override
  Future<Result<double, Failure>> execute((int, int) params) async {
    return Result.success(params.$1 / params.$2);
  }

  @override
  Result<double, Failure> onException(UsecaseException e) =>
      Result.failure(Failure(e.message ?? ''));
}
```

You need to override the `onException` method to build the `Failure` object from the `UsecaseException` .

### Using a stream

You can use a stream usecase to return a `Stream` instead of a raw value:

```dart
class GeneratorUsecase extends NoParamsStreamUsecase<int> {
  const GeneratorUsecase();

  @override
  Stream<int> execute() async* {
    for (int i = 0; i < 10; i++) {
      yield i;
    }
  }
}
```
