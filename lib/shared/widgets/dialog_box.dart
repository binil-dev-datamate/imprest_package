import 'package:imprest_cash/shared/widgets/butttons/button.dart';
import 'package:imprest_cash/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

enum DialogSeverity { info, warning, error, success }

class DialogBox extends StatefulWidget {
  final String heading;
  final String messageText;
  final IconData icon;
  final Color headerColor;
  final Color iconColor;
  final double boxWidth;
  final List<Widget> actions;
  final bool showClose;
  final double? maxMessageHeight;

  static const double _messageFontSize = 15;

  const DialogBox._({
    super.key,
    required this.heading,
    required this.messageText,
    required this.icon,
    required this.headerColor,
    required this.iconColor,
    required this.actions,
    this.boxWidth = 460,
    this.showClose = true,
    this.maxMessageHeight,
  });

  /// Default constructor with custom actions
  factory DialogBox.custom({
    Key? key,
    required String heading,
    required String messageText,
    required List<Widget> actions,
    DialogSeverity severity = DialogSeverity.warning,
    double boxWidth = 460,
    bool showClose = true,
    double? maxMessageHeight,
  }) {
    final style = _severityColors(severity);
    return DialogBox._(
      key: key,
      heading: heading,
      messageText: messageText,
      icon: style.icon,
      headerColor: style.headerColor,
      iconColor: style.iconColor,
      actions: actions,
      boxWidth: boxWidth,
      showClose: showClose,
      maxMessageHeight: maxMessageHeight,
    );
  }

  factory DialogBox.ok({
    Key? key,
    required BuildContext context,
    String heading = '',
    String messageText = '',
    DialogSeverity severity = DialogSeverity.info,
    double boxWidth = 460,
    bool showClose = true,
    double? maxMessageHeight,
    bool autofocusOk = false,
  }) {
    final style = _severityColors(severity);
    return DialogBox._(
      key: key,
      heading: heading,
      messageText: messageText,
      icon: style.icon,
      headerColor: style.headerColor,
      iconColor: style.iconColor,
      actions: [
        AppPrimaryButton(
          width: 110,
          height: 38,
          label: 'OK',
          autofocus: autofocusOk,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
      boxWidth: boxWidth,
      showClose: showClose,
      maxMessageHeight: maxMessageHeight,
    );
  }

  static _DialogSeverityStyle _severityColors(DialogSeverity severity) {
    const headerBlue = AppColors.appThemeColorLight;

    switch (severity) {
      case DialogSeverity.warning:
        return _DialogSeverityStyle(
          icon: Icons.warning_amber_rounded,
          headerColor: headerBlue,
          iconColor: Colors.orange.shade800,
        );
      case DialogSeverity.error:
        return _DialogSeverityStyle(
          icon: Icons.error_outline_rounded,
          headerColor: headerBlue,
          iconColor: Colors.red.shade700,
        );
      case DialogSeverity.success:
        return _DialogSeverityStyle(
          icon: Icons.check_circle_outline_rounded,
          headerColor: headerBlue,
          iconColor: Colors.green.shade700,
        );
      case DialogSeverity.info:
        return const _DialogSeverityStyle(
          icon: Icons.info_outline_rounded,
          headerColor: headerBlue,
          iconColor: headerBlue,
        );
    }
  }

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final FocusNode _keyboardFocusNode = FocusNode();
  FocusNode? _previousFocusNode;

  @override
  void initState() {
    super.initState();
    _previousFocusNode = FocusManager.instance.primaryFocus;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _keyboardFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    _previousFocusNode?.requestFocus();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      Navigator.of(context).pop(true);
      return;
    }
    // Escape only when the header close control is shown; failure dialogs stay OK-only.
    if (event.logicalKey == LogicalKeyboardKey.escape && widget.showClose) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.boxWidth),
        child: KeyboardListener(
          focusNode: _keyboardFocusNode,
          onKeyEvent: _handleKeyEvent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              _buildContent(),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: widget.headerColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.heading,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
          if (widget.showClose)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    Widget message = Text(
      widget.messageText,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: DialogBox._messageFontSize,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );

    if (widget.maxMessageHeight != null) {
      message = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.maxMessageHeight!),
        child: SingleChildScrollView(child: Center(child: message)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: widget.iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(widget.icon, color: widget.iconColor, size: 36),
            ),
          ),
          const Gap(16),
          Center(
            child: message,
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.actions,
      ),
    );
  }
}

class _DialogSeverityStyle {
  final IconData icon;
  final Color headerColor;
  final Color iconColor;

  const _DialogSeverityStyle({
    required this.icon,
    required this.headerColor,
    required this.iconColor,
  });
}

extension DialogBoxShowExtension on DialogBox {
  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => this,
    );
  }
}
