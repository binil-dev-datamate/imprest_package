import 'package:flutter/material.dart';

class AppColors {
  static const Color appThemeColorLight = Color.fromARGB(255, 22, 54, 123);
  //static const Color appThemeColorLight = Color(0xFF2A3B4D);
  static const Color reportDrillDownItemColor = Colors.green;
  static const Color selectedCategoryColor = Color(0xffE31F26);
  static const Color reportGrandTotalColor = Color.fromARGB(255, 126, 15, 19);
  static const Color loginTextFieldColor = Color(0xff222020);
  static const Color borderColorGrey = Color(0xffE1E1E1);
  static const Color textBlueColor = Color(0xff007AFF);
  static const Color cancelButtonBackgroundColor = Color(0xFFEEEEEE);
  static const Color reportsScheduleRowColor = Color(0xff007AFF);
  static const Color textredColors = Color(0xFFD32F2F);
  static const Color cancelledVoucherRowColor = Color(0xFFD32F2F);
  static Color memoVoucherRowColor = Colors.blueAccent;
  static const Color textWhiteColor = Color(0xFFEEEEEE);
  static const Color textGreyColor = Color(0xFF757575);
  static Color textDarkGreyColor = Colors.grey.shade600;

  static const Color statusNoAction = Color(0xFF1976D2);
  static const Color statusAccepted = Color(0xFF388E3C);
  static const Color statusRejected = Color(0xFFD32F2F);
  static const Color statusPending = Color(0xFFF57C00);

  // Report semantics (Receipts & Payments, comparisons) — values match the
  // MaterialColor shades they replace, so appearance is unchanged.
  static const Color balancedBg = Color(0xFFE8F5E9); // green.shade50
  static const Color unbalancedBg = Color(0xFFFFEBEE); // red.shade50
  static const Color reportSpillover = Color(0xFFEF6C00); // orange.shade800
  static const Color reportSpilloverBg = Color(0xFFFFF3E0); // orange.shade50
  static const Color surfaceLightGrey = Color(0xFFF9F9F9);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static final Color shadowColor = Colors.black.withValues(alpha: 0.04);

  // Selection / row chrome (Material blue.shade50).
  static const Color selectionBarBg = Color(0xFFE3F2FD);
  static const Color selectedRowBg = Color(0xFFE3F2FD);

  // Credit / debit foregrounds (Material green/red.shade700).
  // Backgrounds reuse balancedBg / unbalancedBg.
  static const Color creditFg = Color(0xFF388E3C);
  static const Color debitFg = Color(0xFFD32F2F);
  static const Color creditBg = balancedBg;
  static const Color debitBg = unbalancedBg;

  // Caution / spillover aliases.
  static const Color warningFg = reportSpillover;
  static const Color warningBg = reportSpilloverBg;

  // Soft amber highlight (e.g. note/tag emphasis cells).
  static const Color highlightSoft = Color(0xFFFFF3CD);

  // Muted empty-state / secondary icons.
  static const Color mutedIcon = textGreyColor;
}
