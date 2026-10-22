import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String? hint;
  final void Function(T? selectedValue)? onChanged;
  final String Function(T) itemLabel;
  final double dropdownWidth;
  final double? dropdownHeight;
  final FocusNode? focusNode;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    required this.value,
    this.focusNode,
    this.hint,
    this.dropdownWidth = 200,
    this.dropdownHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<T>(
        key: ValueKey<T?>(value),
        initialValue: value,
        isExpanded: true,
        hint: hint != null
            ? Text(
                hint!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey),
              )
            : null,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: _inputDecoration(context),
        style: theme.textTheme.bodyMedium,
        borderRadius: BorderRadius.circular(8),
        icon: Icon(Icons.keyboard_arrow_down, color: colors.primary, size: 20),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              itemLabel(item),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }).toList(),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color:
              Theme.of(context).inputDecorationTheme.border!.borderSide.color,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      filled: true,
      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
    );
  }
}
