import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool useBodyStyle;
  final FontWeight? fontweight;
  final double? fontSize;

  const CustomText(
    this.text, {
    super.key,
    this.style,
    this.fontweight,
    this.fontSize,
    this.color,
    this.align,
    this.maxLines,
    this.overflow,
    this.useBodyStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = useBodyStyle
        ? theme.textTheme.bodyLarge?.copyWith(color: color)
        : style?.copyWith(
                color: color, fontWeight: fontweight, fontSize: fontSize) ??
            style;

    return Text(
      text,
      style: defaultStyle ??
          theme.textTheme.bodyLarge?.copyWith(
              color: color, fontWeight: fontweight, fontSize: fontSize),
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Pre-defined text variants
class HeadingLarge extends CustomText {
  const HeadingLarge(
    super.text, {
    super.key,
    super.color,
    super.align,
    super.maxLines,
    super.overflow,
  }) : super(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'LatoLocal',
            fontFamilyFallback: ['Roboto', 'NotoSansLocal'],
          ),
        );
}

class SubHeading extends CustomText {
  const SubHeading(
    super.text, {
    super.key,
    super.color,
    super.align,
    super.maxLines,
    super.overflow,
  }) : super(
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        );
}

class ContentText extends CustomText {
  ContentText(
    super.text, {
    super.key,
    super.color,
    super.align,
    super.maxLines,
    super.overflow,
    bool bold = false,
  }) : super(
          style: TextStyle(
            fontSize: 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            height: 1,
            fontFamily: 'LatoLocal',
            fontFamilyFallback: const ['Roboto', 'NotoSansLocal'],
          ),
        );
}

class SmallText extends CustomText {
  final bool bold;
  SmallText(
    super.text, {
    super.key,
    super.color,
    super.align,
    super.maxLines,
    super.overflow,
    this.bold = false,
  }) : super(
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'LatoLocal',
            fontFamilyFallback: const ['Roboto', 'NotoSansLocal'],
          ),
        );
}

class FormLabelText extends CustomText {
  const FormLabelText(
    super.text, {
    super.key,
    super.color,
    super.align,
    super.maxLines,
    super.overflow,
  }) : super(
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, wordSpacing: -1),
        );

  const FormLabelText.bold(
    super.text, {
    super.key,
    super.color,
    super.align,
    super.maxLines,
    super.overflow,
  }) : super(
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );
}

class BoldText extends CustomText {
  const BoldText(
    super.text, {
    super.key,
    super.color,
    super.align,
    super.maxLines,
    super.overflow,
  }) : super(
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );
}
