import 'package:flutter_test/flutter_test.dart';
import 'package:git_search_app/core/utils/input_converter.dart';

void main() {
  late InputConverter converter;

  setUp(() {
    converter = InputConverter();
  });

  test('should parse valid date string', () {
    const dateString = '2024-01-01';

    final result = converter.parseDate(dateString);

    expect(result, DateTime(2024, 1, 1));
  });

  test('should return null for invalid date string', () {
    const invalidDateString = 'invalid-date';

    final result = converter.parseDate(invalidDateString);

    expect(result, isNull);
  });

  test('should format date correctly', () {
    final date = DateTime(2024, 1, 1);

    final result = converter.formatDate(date);

    expect(result, '2024-01-01');
  });
}
