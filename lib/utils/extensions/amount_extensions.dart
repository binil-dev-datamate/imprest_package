/// Local amount formatting for Imprest.
///
/// Adapted from Accounting: no company-selection dependency. The host
/// session will supply currency/precision in a later phase; until then
/// amounts use two decimals and the rupee symbol.
enum AmountFormatStyle { indian, international }

extension AmountFormatter on double {
  /// Formats a double using Indian or International grouping.
  /// Precision is mandatory.
  String formatAmount({
    AmountFormatStyle style = AmountFormatStyle.indian,
    int? precision,
    bool isNegativeRepresentedInBrackets = true,
    String? symbol,
    bool includeSymbol = false,
  }) {
    final applicablePrecision = precision ?? 2;
    assert(applicablePrecision >= 0, 'Precision must be >= 0');

    final isNegative = this < 0;
    final absValue = abs();

    final parts = absValue.toStringAsFixed(applicablePrecision).split('.');
    final integerPart = parts[0];
    final decimals = parts.length > 1 ? parts[1] : '';

    String formattedInt;
    switch (style) {
      case AmountFormatStyle.indian:
        formattedInt = _formatIndian(integerPart);
        break;
      case AmountFormatStyle.international:
        formattedInt = _formatInternational(integerPart);
        break;
    }

    var formatted =
        decimals.isNotEmpty ? '$formattedInt.$decimals' : formattedInt;

    if (includeSymbol) {
      final activeSymbol = symbol ?? '\u20B9';
      formatted = '$activeSymbol $formatted';
    }

    return isNegative
        ? isNegativeRepresentedInBrackets
            ? '($formatted)'
            : '-$formatted'
        : formatted;
  }

  /// Indian number system formatting (e.g., 12,34,567)
  String _formatIndian(String input) {
    if (input.length <= 3) return input;

    final last3 = input.substring(input.length - 3);
    final rest = input.substring(0, input.length - 3);

    final buffer = StringBuffer();
    int i = rest.length % 2;
    if (i > 0) {
      buffer.write(rest.substring(0, i));
      buffer.write(',');
    }

    for (; i < rest.length; i += 2) {
      buffer.write(rest.substring(i, i + 2));
      buffer.write(',');
    }

    buffer.write(last3);
    return buffer.toString().replaceAll(RegExp(r',$'), '');
  }

  /// International number system formatting (e.g., 1,234,567)
  String _formatInternational(String input) {
    final buffer = StringBuffer();
    int length = input.length;
    for (int i = 0; i < length; i++) {
      buffer.write(input[i]);
      if ((length - i - 1) % 3 == 0 && i != length - 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }
}
