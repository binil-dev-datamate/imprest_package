import 'package:imprest_cash/shared/widgets/text_overflow_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool enabled;
  final FocusNode? focusNode;
  final String? hint;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String text)? onFieldSubmitted;
  final void Function(String text)? onChanged;
  final bool isRequired; // Indicates if the field is required
  final String? initialValue;
  final bool obscureText;
  final bool autoFocus;
  final TextStyle? style;
  final int? maxLength;
  final bool? readOnly;
  final double verticalPadding;
  final TextInputAction? textInputAction;

  /// Shows a … hint when text overflows and the field is not focused.
  final bool showOverflowIndicator;

  const CustomTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.inputFormatters,
    this.enabled = true,
    this.autoFocus = false,
    this.focusNode,
    this.onFieldSubmitted,
    this.hint,
    this.textAlign = TextAlign.left,
    this.keyboardType,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.suffixIcon,
    this.prefixIcon,
    this.verticalPadding = 14,
    this.isRequired = false,
    this.initialValue,
    this.style,
    this.obscureText = false,
    this.maxLength,
    this.readOnly,
    this.textInputAction,
    this.showOverflowIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!showOverflowIndicator) {
      return _CustomTextFieldBody(
        controller: controller,
        enabled: enabled,
        focusNode: focusNode,
        hint: hint,
        textAlign: textAlign,
        keyboardType: keyboardType,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        prefix: prefix,
        suffix: suffix,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        isRequired: isRequired,
        initialValue: initialValue,
        obscureText: obscureText,
        autoFocus: autoFocus,
        style: style,
        maxLength: maxLength,
        readOnly: readOnly,
        verticalPadding: verticalPadding,
        textInputAction: textInputAction,
      );
    }

    return _OverflowTextFieldDecorator(
      controller: controller,
      focusNode: focusNode,
      textAlign: textAlign,
      style: style,
      initialValue: initialValue,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      childBuilder: (overflowPrefix, overflowSuffix, fieldKey, scrollController,
          onChangedWrapper) {
        return _CustomTextFieldBody(
          controller: controller,
          enabled: enabled,
          focusNode: focusNode,
          hint: hint,
          textAlign: textAlign,
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          prefix: prefix,
          suffix: suffix,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          isRequired: isRequired,
          initialValue: initialValue,
          obscureText: obscureText,
          autoFocus: autoFocus,
          style: style,
          maxLength: maxLength,
          readOnly: readOnly,
          verticalPadding: verticalPadding,
          textInputAction: textInputAction,
          overflowPrefix: overflowPrefix,
          overflowSuffix: overflowSuffix,
          fieldKey: fieldKey,
          scrollController: scrollController,
          onChangedWithOverflowCheck: onChangedWrapper,
        );
      },
    );
  }
}

class _CustomTextFieldBody extends StatelessWidget {
  final TextEditingController? controller;
  final bool enabled;
  final FocusNode? focusNode;
  final String? hint;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String text)? onFieldSubmitted;
  final void Function(String text)? onChanged;
  final bool isRequired;
  final String? initialValue;
  final bool obscureText;
  final bool autoFocus;
  final TextStyle? style;
  final int? maxLength;
  final bool? readOnly;
  final double verticalPadding;
  final TextInputAction? textInputAction;
  final Widget? overflowPrefix;
  final Widget? overflowSuffix;
  final GlobalKey? fieldKey;
  final ScrollController? scrollController;
  final void Function(String)? onChangedWithOverflowCheck;

  const _CustomTextFieldBody({
    this.controller,
    this.onChanged,
    this.inputFormatters,
    this.enabled = true,
    this.autoFocus = false,
    this.focusNode,
    this.onFieldSubmitted,
    this.hint,
    this.textAlign = TextAlign.left,
    this.keyboardType,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.suffixIcon,
    this.prefixIcon,
    this.verticalPadding = 14,
    this.isRequired = false,
    this.initialValue,
    this.style,
    this.obscureText = false,
    this.maxLength,
    this.readOnly,
    this.textInputAction,
    this.overflowPrefix,
    this.overflowSuffix,
    this.fieldKey,
    this.scrollController,
    this.onChangedWithOverflowCheck,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = _inputDecoration(context).copyWith(
      prefix: _mergeDecorationWidgets(_buildPrefix(), overflowPrefix),
      suffix: _mergeDecorationWidgets(suffix, overflowSuffix),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    );
    final theme = Theme.of(context);
    final baseStyle = style ?? theme.textTheme.bodyMedium;
    return TextFormField(
      key: fieldKey,
      scrollController: scrollController,
      autofocus: autoFocus,
      style: enabled
          ? baseStyle
          : (baseStyle?.copyWith(color: Colors.grey.shade600) ??
              TextStyle(color: Colors.grey.shade600)),
      enabled: enabled,
      controller: controller,
      focusNode: focusNode,
      textAlign: textAlign,
      keyboardType: keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      decoration: decoration,
      inputFormatters: inputFormatters,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: (value) {
        onChanged?.call(value);
        onChangedWithOverflowCheck?.call(value);
      },
      initialValue: initialValue,
      obscureText: obscureText,
      readOnly: readOnly ?? false,
      textInputAction: textInputAction,
    );
  }

  Widget? _mergeDecorationWidgets(Widget? existing, Widget? overflowPart) {
    if (existing == null && overflowPart == null) return null;
    if (existing == null) return overflowPart;
    if (overflowPart == null) return existing;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [existing, overflowPart],
    );
  }

  Widget? _buildPrefix() {
    if (isRequired) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '*',
              style: TextStyle(color: Colors.red),
            ),
            if (prefix != null) prefix!,
          ],
        ),
      );
    }
    return prefix;
  }

  InputDecoration _inputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final colors = theme.colorScheme;
    final borderRadius = BorderRadius.circular(8);
    final enabledBorderColor =
        inputTheme.enabledBorder?.borderSide.color ?? Colors.grey.shade300;
    final disabledBorderColor =
        inputTheme.disabledBorder?.borderSide.color ?? Colors.grey.shade200;

    return InputDecoration(
      hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
      hintText: hint,
      isDense: true,
      contentPadding:
          EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: enabledBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: enabledBorderColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: disabledBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      filled: true,
      fillColor: enabled ? inputTheme.fillColor : Colors.grey.shade200,
    );
  }
}

typedef _OverflowChildBuilder = Widget Function(
  Widget? overflowPrefix,
  Widget? overflowSuffix,
  GlobalKey fieldKey,
  ScrollController scrollController,
  void Function(String) onChangedWrapper,
);

class _OverflowTextFieldDecorator extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextStyle? style;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final _OverflowChildBuilder childBuilder;

  const _OverflowTextFieldDecorator({
    required this.controller,
    required this.focusNode,
    required this.textAlign,
    required this.style,
    required this.initialValue,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.childBuilder,
  });

  @override
  State<_OverflowTextFieldDecorator> createState() =>
      _OverflowTextFieldDecoratorState();
}

class _OverflowTextFieldDecoratorState
    extends State<_OverflowTextFieldDecorator> {
  final GlobalKey _fieldKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  bool _isOverflowing = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
    widget.focusNode?.addListener(_onFocusChanged);
    _isFocused = widget.focusNode?.hasFocus ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  @override
  void didUpdateWidget(covariant _OverflowTextFieldDecorator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      widget.controller?.addListener(_onTextChanged);
    }

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChanged);
      widget.focusNode?.addListener(_onFocusChanged);
      _isFocused = widget.focusNode?.hasFocus ?? false;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    widget.focusNode?.removeListener(_onFocusChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _onFocusChanged() {
    final focused = widget.focusNode?.hasFocus ?? false;
    if (_isFocused != focused) {
      setState(() => _isFocused = focused);
    }

    if (!focused) {
      _scrollToVisibleEdge();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _scrollToVisibleEdge() {
    if (!_scrollController.hasClients) return;

    if (widget.textAlign == TextAlign.right) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    } else {
      _scrollController.jumpTo(0);
    }
  }

  void _checkOverflow() {
    if (!mounted) return;

    final renderBox = _fieldKey.currentContext?.findRenderObject();
    if (renderBox is! RenderBox) return;

    const horizontalPadding = 24.0;
    const indicatorWidth = 16.0;
    final reserved = horizontalPadding +
        (widget.prefixIcon != null ? 40.0 : 0) +
        (widget.suffixIcon != null ? 40.0 : 0) +
        (_shouldShowOverflowIndicator ? indicatorWidth : 0);

    final maxWidth = renderBox.size.width - reserved;
    final text = widget.controller?.text ?? widget.initialValue ?? '';
    final theme = Theme.of(context);
    final style = widget.style ?? theme.textTheme.bodyMedium;

    final overflowing = TextOverflowHelper.isTextOverflowing(
      text: text,
      style: style,
      maxWidth: maxWidth,
    );

    if (_isOverflowing != overflowing) {
      setState(() => _isOverflowing = overflowing);
    }
  }

  bool get _shouldShowOverflowIndicator => _isOverflowing && !_isFocused;

  bool get _showLeadingEllipsis =>
      _shouldShowOverflowIndicator && widget.textAlign == TextAlign.right;

  bool get _showTrailingEllipsis =>
      _shouldShowOverflowIndicator && widget.textAlign != TextAlign.right;

  void _onChangedWrapper(String value) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  @override
  Widget build(BuildContext context) {
    final overflowPrefix = _showLeadingEllipsis
        ? TextOverflowHelper.ellipsisIndicator(context)
        : null;
    final overflowSuffix = _showTrailingEllipsis
        ? TextOverflowHelper.ellipsisIndicator(context)
        : null;

    final field = widget.childBuilder(
      overflowPrefix,
      overflowSuffix,
      _fieldKey,
      _scrollController,
      _onChangedWrapper,
    );

    final fullText = widget.controller?.text ?? widget.initialValue ?? '';
    if (fullText.isEmpty || !_isOverflowing) return field;

    return Tooltip(
      message: fullText,
      waitDuration: const Duration(milliseconds: 400),
      child: field,
    );
  }
}
