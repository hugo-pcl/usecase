import 'package:usecase/usecase.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(usecase(), 42);
  });
}
