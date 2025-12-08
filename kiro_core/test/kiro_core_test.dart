import 'package:flutter_test/flutter_test.dart';
import 'package:kiro_core/kiro_core.dart';

void main() {
  group('KiroCore', () {
    group('Validators', () {
      test('email validation works correctly', () {
        expect(Validators.email('test@example.com'), isNull);
        expect(Validators.email('invalid-email'), isNotNull);
        expect(Validators.email(''), isNotNull);
      });

      test('password validation works correctly', () {
        expect(Validators.password('Password1'), isNull);
        expect(Validators.password('weak'), isNotNull);
        expect(Validators.password('nouppercase1'), isNotNull);
      });

      test('phone validation works correctly', () {
        expect(Validators.phone('+1234567890'), isNull);
        expect(Validators.phone('1234567890'), isNull);
        expect(Validators.phone('123'), isNotNull);
      });
    });

    group('Result', () {
      test('Success contains value', () {
        const result = Result<int>.success(42);
        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.valueOrNull, equals(42));
      });

      test('Failure contains error', () {
        const result = Result<int>.failure(
          Failure(message: 'Test error', code: 'TEST'),
        );
        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.valueOrNull, isNull);
        expect(result.failureOrNull?.message, equals('Test error'));
      });

      test('fold handles both cases', () {
        const success = Result<int>.success(42);
        const failure = Result<int>.failure(
          Failure(message: 'Error'),
        );

        final successResult = success.fold(
          onSuccess: (v) => 'Value: $v',
          onFailure: (f) => 'Error: ${f.message}',
        );
        expect(successResult, equals('Value: 42'));

        final failureResult = failure.fold(
          onSuccess: (v) => 'Value: $v',
          onFailure: (f) => 'Error: ${f.message}',
        );
        expect(failureResult, equals('Error: Error'));
      });

      test('map transforms success value', () {
        const result = Result<int>.success(21);
        final mapped = result.map((v) => v * 2);
        expect(mapped.valueOrNull, equals(42));
      });
    });

    group('Extensions', () {
      test('String.capitalize works', () {
        expect('hello'.capitalize, equals('Hello'));
        expect(''.capitalize, equals(''));
      });

      test('String.toSnakeCase works', () {
        expect('helloWorld'.toSnakeCase, equals('hello_world'));
        expect('HelloWorld'.toSnakeCase, equals('hello_world'));
      });

      test('String.toCamelCase works', () {
        expect('hello_world'.toCamelCase, equals('helloWorld'));
        expect('Hello World'.toCamelCase, equals('helloWorld'));
      });

      test('Iterable.firstOrNull works', () {
        expect([1, 2, 3].firstOrNull, equals(1));
        expect(<int>[].firstOrNull, isNull);
      });
    });

    group('Logger', () {
      test('Logger can be created', () {
        final logger = KiroLogger(tag: 'Test');
        expect(logger.tag, equals('Test'));
      });

      test('Global logger exists', () {
        expect(logger, isNotNull);
      });
    });
  });
}
