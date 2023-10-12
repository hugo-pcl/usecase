// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:generic_usecase/generic_usecase.dart';
import 'package:test/test.dart';

void main() {
  group('UsecaseException', () {
    test('should create an exception with a message', () {
      const message = 'Test message';
      const exception = UsecaseException(message);
      expect(exception.message, equals(message));
    });

    test('should create an exception without a message', () {
      const exception = UsecaseException();
      expect(exception.message, isNull);
    });

    test('should have a string representation', () {
      const message = 'Test message';
      const exception = UsecaseException(message);
      expect(exception.toString(), equals('UsecaseException: $message'));
    });

    test('should be equal to another exception with the same message', () {
      const message = 'Test message';
      const exception1 = UsecaseException(message);
      const exception2 = UsecaseException(message);
      expect(exception1, equals(exception2));
    });

    test('should not be equal to another exception with a different message',
        () {
      const exception1 = UsecaseException('Test message 1');
      const exception2 = UsecaseException('Test message 2');
      expect(exception1, isNot(equals(exception2)));
    });

    test(
        'should have the same hashcode as another exception with the same '
        'message', () {
      const message = 'Test message';
      const exception1 = UsecaseException(message);
      const exception2 = UsecaseException(message);
      expect(exception1.hashCode, equals(exception2.hashCode));
    });
  });

  group('StreamUsecaseException', () {
    test('should create an exception with a message', () {
      const message = 'Test message';
      const exception = StreamUsecaseException(message);
      expect(exception.message, equals(message));
    });

    test('should create an exception without a message', () {
      const exception = StreamUsecaseException();
      expect(exception.message, isNull);
    });

    test('should have a string representation', () {
      const message = 'Test message';
      const exception = StreamUsecaseException(message);
      expect(exception.toString(), equals('StreamUsecaseException: $message'));
    });

    test('should be equal to another exception with the same message', () {
      const message = 'Test message';
      const exception1 = StreamUsecaseException(message);
      const exception2 = StreamUsecaseException(message);
      expect(exception1, equals(exception2));
    });

    test('should not be equal to another exception with a different message',
        () {
      const exception1 = StreamUsecaseException('Test message 1');
      const exception2 = StreamUsecaseException('Test message 2');
      expect(exception1, isNot(equals(exception2)));
    });
  });

  group('InvalidPreconditionsException', () {
    test('should create an exception with a message', () {
      const message = 'Test message';
      const exception = InvalidPreconditionsException(message);
      expect(exception.message, equals(message));
    });

    test('should create an exception without a message', () {
      const exception = InvalidPreconditionsException();
      expect(exception.message, isNull);
    });

    test('should have a string representation', () {
      const message = 'Test message';
      const exception = InvalidPreconditionsException(message);
      expect(
        exception.toString(),
        equals('InvalidPreconditionsException: $message'),
      );
    });

    test('should be equal to another exception with the same message', () {
      const message = 'Test message';
      const exception1 = InvalidPreconditionsException(message);
      const exception2 = InvalidPreconditionsException(message);
      expect(exception1, equals(exception2));
    });

    test('should not be equal to another exception with a different message',
        () {
      const exception1 = InvalidPreconditionsException('Test message 1');
      const exception2 = InvalidPreconditionsException('Test message 2');
      expect(exception1, isNot(equals(exception2)));
    });
  });

  group('InvalidPostconditionsException', () {
    test('should create an exception with a message', () {
      const message = 'Test message';
      const exception = InvalidPostconditionsException(message);
      expect(exception.message, equals(message));
    });

    test('should create an exception without a message', () {
      const exception = InvalidPostconditionsException();
      expect(exception.message, isNull);
    });

    test('should have a string representation', () {
      const message = 'Test message';
      const exception = InvalidPostconditionsException(message);
      expect(
        exception.toString(),
        equals('InvalidPostconditionsException: $message'),
      );
    });

    test('should be equal to another exception with the same message', () {
      const message = 'Test message';
      const exception1 = InvalidPostconditionsException(message);
      const exception2 = InvalidPostconditionsException(message);
      expect(exception1, equals(exception2));
    });

    test('should not be equal to another exception with a different message',
        () {
      const exception1 = InvalidPostconditionsException('Test message 1');
      const exception2 = InvalidPostconditionsException('Test message 2');
      expect(exception1, isNot(equals(exception2)));
    });
  });
}
