// Copyright 2023 Hugo Pointcheval
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:test/test.dart';
import 'package:usecase/usecase.dart';

void main() {
  group('UsecaseException', () {
    test('should create an exception with a message', () {
      const message = 'Test message';
      final exception = UsecaseException(message);
      expect(exception.message, equals(message));
    });

    test('should create an exception without a message', () {
      final exception = UsecaseException();
      expect(exception.message, isNull);
    });

    test('should have a string representation', () {
      const message = 'Test message';
      final exception = UsecaseException(message);
      expect(exception.toString(), equals('UsecaseException: $message'));
    });

    test('should be equal to another exception with the same message', () {
      const message = 'Test message';
      final exception1 = UsecaseException(message);
      final exception2 = UsecaseException(message);
      expect(exception1, equals(exception2));
    });

    test('should not be equal to another exception with a different message',
        () {
      final exception1 = UsecaseException('Test message 1');
      final exception2 = UsecaseException('Test message 2');
      expect(exception1, isNot(equals(exception2)));
    });

    test(
        'should have the same hashcode as another exception with the same '
        'message', () {
      const message = 'Test message';
      final exception1 = UsecaseException(message);
      final exception2 = UsecaseException(message);
      expect(exception1.hashCode, equals(exception2.hashCode));
    });
  });

  group('StreamUsecaseException', () {
    test('should create an exception with a message', () {
      const message = 'Test message';
      final exception = StreamUsecaseException(message);
      expect(exception.message, equals(message));
    });

    test('should create an exception without a message', () {
      final exception = StreamUsecaseException();
      expect(exception.message, isNull);
    });

    test('should have a string representation', () {
      const message = 'Test message';
      final exception = StreamUsecaseException(message);
      expect(exception.toString(), equals('StreamUsecaseException: $message'));
    });

    test('should be equal to another exception with the same message', () {
      const message = 'Test message';
      final exception1 = StreamUsecaseException(message);
      final exception2 = StreamUsecaseException(message);
      expect(exception1, equals(exception2));
    });

    test('should not be equal to another exception with a different message',
        () {
      final exception1 = StreamUsecaseException('Test message 1');
      final exception2 = StreamUsecaseException('Test message 2');
      expect(exception1, isNot(equals(exception2)));
    });
  });

  group('PreconditionsException', () {
    test('should create an exception with a message', () {
      const message = 'Test message';
      final exception = PreconditionsException(message);
      expect(exception.message, equals(message));
    });

    test('should create an exception without a message', () {
      final exception = PreconditionsException();
      expect(exception.message, isNull);
    });

    test('should have a string representation', () {
      const message = 'Test message';
      final exception = PreconditionsException(message);
      expect(exception.toString(), equals('PreconditionsException: $message'));
    });

    test('should be equal to another exception with the same message', () {
      const message = 'Test message';
      final exception1 = PreconditionsException(message);
      final exception2 = PreconditionsException(message);
      expect(exception1, equals(exception2));
    });

    test('should not be equal to another exception with a different message',
        () {
      final exception1 = PreconditionsException('Test message 1');
      final exception2 = PreconditionsException('Test message 2');
      expect(exception1, isNot(equals(exception2)));
    });
  });

  group('InvalidPreconditionsException', () {
    test('should create an exception with a message', () {
      const message = 'Test message';
      final exception = InvalidPreconditionsException(message);
      expect(exception.message, equals(message));
    });

    test('should create an exception without a message', () {
      final exception = InvalidPreconditionsException();
      expect(exception.message, isNull);
    });

    test('should have a string representation', () {
      const message = 'Test message';
      final exception = InvalidPreconditionsException(message);
      expect(exception.toString(),
          equals('InvalidPreconditionsException: $message'));
    });

    test('should be equal to another exception with the same message', () {
      const message = 'Test message';
      final exception1 = InvalidPreconditionsException(message);
      final exception2 = InvalidPreconditionsException(message);
      expect(exception1, equals(exception2));
    });

    test('should not be equal to another exception with a different message',
        () {
      final exception1 = InvalidPreconditionsException('Test message 1');
      final exception2 = InvalidPreconditionsException('Test message 2');
      expect(exception1, isNot(equals(exception2)));
    });
  });
}