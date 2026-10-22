import 'package:imprest_cash/utils/extensions/amount_extensions.dart';

/// Shared empty/null display rules for read-only interfaced tables and payload preview.
class ReadOnlyDisplay {
  ReadOnlyDisplay._();

  /// Table cells and meta cards when the value is null, blank, or unavailable.
  static const empty = '-';

  /// Alias of [empty] for meta cards and section placeholders.
  static const emptyMeta = empty;

  /// Legacy table placeholder still greys in [isEmptyPlaceholder] during cutover.
  static const legacyEmpty = 'N/A';
  static const legacyNoData = '(No data)';

  static bool isEmptyPlaceholder(String? value) =>
      value == empty ||
      value == emptyMeta ||
      value == legacyEmpty ||
      value == legacyNoData;

  static String text(String? value) =>
      (value == null || value.trim().isEmpty) ? empty : value;

  static String textMeta(String? value) =>
      (value == null || value.trim().isEmpty) ? emptyMeta : value;

  /// [emptyIfZero]: use for optional GST columns (CGST/SGST/IGST) where 0 means
  /// unavailable / not applicable on this line (show [empty], not formatted zero).
  /// Never use [emptyIfZero] for VAT rates or VAT amounts — zero-rated VAT is real.
  static String money(
    num? value, {
    required int precision,
    bool emptyIfZero = false,
  }) {
    if (value == null || (emptyIfZero && value == 0)) return empty;
    return value
        .toDouble()
        .formatAmount(precision: precision, includeSymbol: true);
  }

  /// Formats a tax rate for display. [0] becomes `0%`. Null becomes [empty].
  static String percent(num? value) {
    if (value == null) return empty;
    final d = value.toDouble();
    final s = d == d.roundToDouble()
        ? d.toStringAsFixed(0)
        : d
            .toStringAsFixed(2)
            .replaceFirst(RegExp(r'0+$'), '')
            .replaceFirst(RegExp(r'\.$'), '');
    return '$s%';
  }
}
