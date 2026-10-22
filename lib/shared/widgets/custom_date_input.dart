import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Enum to represent the type of date error
enum DateErrorType {
  invalidFormat, // Invalid date format (e.g., "abc-def-ghij")
  invalidRange, // Date is outside the allowed range
  empty, // Field was empty on blur/submit
}

class CustomDateInput extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime?) onDateSelected;
  final Function(String, DateErrorType) onInvalidDate;
  final FocusNode focusNode;
  final String? dateUnselectedLabel;
  final bool readOnly;

  const CustomDateInput({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    required this.onInvalidDate,
    required this.focusNode,
    this.dateUnselectedLabel,
    this.readOnly = false,
  });

  @override
  State createState() => CustomDateInputState();
}

class CustomDateInputState extends State<CustomDateInput> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  String? _currentFormat;

  final List<String> _dateFormats = [
    'dd-MM-yyyy',
    'dd MM yyyy',
    'dd-MMM-yyyy',
    'dd MMM yyyy',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _controller.text = DateFormat('dd-MM-yyyy').format(widget.initialDate!);
      _currentFormat = 'dd-MM-yyyy';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _normalizeMonth(String input) {
    return input.replaceAllMapped(
      RegExp(r'\b[a-z]{3}\b', caseSensitive: false),
      (match) => match.group(0)!.toLowerCase().capitalize(),
    );
  }

  DateTime? _parseDate(String input) {
    final normalizedInput = _normalizeMonth(input.trim());

    for (var format in _dateFormats) {
      try {
        final parsedDate = DateFormat(format).tryParse(normalizedInput);
        if (parsedDate != null) {
          if (!parsedDate.isBefore(widget.firstDate!) &&
              !parsedDate.isAfter(widget.lastDate!)) {
            _currentFormat = format;
            return parsedDate;
          } else {
            widget.onInvalidDate(input, DateErrorType.invalidRange);
            return null;
          }
        }
      } catch (_) {}
    }
    widget.onInvalidDate(input, DateErrorType.invalidFormat);
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    if (widget.readOnly) return;

    final now = DateTime.now();
    DateTime initialDate = widget.initialDate ?? now;

    // Clamp initialDate to be within the valid range
    if (initialDate.isBefore(widget.firstDate!)) {
      initialDate = widget.firstDate!;
    } else if (initialDate.isAfter(widget.lastDate!)) {
      initialDate = widget.lastDate!;
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: widget.firstDate!,
      lastDate: widget.lastDate!,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
        _currentFormat = 'dd-MM-yyyy';
        widget.onDateSelected(_selectedDate);
      });
    }
  }

  DateTime? validateAndGetDate() {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      widget.onInvalidDate(input, DateErrorType.invalidFormat);
      return null;
    }
    return _parseDate(input);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: widget.focusNode,
            readOnly: widget.readOnly,
            decoration: InputDecoration(
              hintText: widget.dateUnselectedLabel ?? 'Enter Date',
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .inputDecorationTheme
                      .border!
                      .borderSide
                      .color,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 1.5),
              ),
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: widget.readOnly ? null : () => _selectDate(context),
              ),
            ),
            keyboardType: TextInputType.datetime,
            onSubmitted: widget.readOnly
                ? null
                : (value) {
                    final parsedDate = _parseDate(value);
                    if (parsedDate != null) {
                      setState(() {
                        _selectedDate = parsedDate;
                        _controller.text =
                            DateFormat(_currentFormat!).format(parsedDate);
                        widget.onDateSelected(_selectedDate);
                      });
                    }
                  },
          ),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
