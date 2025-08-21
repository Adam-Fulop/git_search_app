import 'package:flutter_test/flutter_test.dart';
import 'package:git_search_app/core/utils/input_converter.dart';

void main() {
  late InputConverter converter;

  setUp(() {
    converter = InputConverter();
  });

  test('should parse valid date string', () {
    // Arrange
    const dateString = '2024-01-01';

    // Act
    final result = converter.parseDate(dateString);

    // Assert
    expect(result, DateTime(2024, 1, 1));
  });

  test('should return null for invalid date string', () {
    // Arrange
    const invalidDateString = 'invalid-date';

    // Act
    final result = converter.parseDate(invalidDateString);

    // Assert
    expect(result, isNull);
  });

  test('should format date correctly', () {
    // Arrange
    final date = DateTime(2024, 1, 1);

    // Act
    final result = converter.formatDate(date);

    // Assert
    expect(result, '2024-01-01');
  });
}
