import 'package:imprest_cash/utils/extensions/context_extensions.dart';
import 'package:imprest_cash/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

// Define the enum for dialog modes
enum DeleteDialogMode { info, delete, import, cancel }

// Define the result model
class ConfirmationDialogResult {
  final bool confirmed;
  final String? reason;

  ConfirmationDialogResult({required this.confirmed, this.reason});
}

Future<ConfirmationDialogResult?> showDeleteConfirmationDialog(
  BuildContext context,
  String message, {
  String? content,
  String action = 'deletion',
  bool escReturns = false,
  double width = 400,
  DeleteDialogMode mode = DeleteDialogMode.info,
}) async {
  return await showDialog<ConfirmationDialogResult>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return _DeleteConfirmationDialog(
        message: message,
        content: content,
        escReturns: escReturns,
        width: width,
        mode: mode,
        action: action,
      );
    },
  );
}

class _DeleteConfirmationDialog extends StatefulWidget {
  final String message;
  final String? content;
  final bool escReturns;
  final double width;
  final DeleteDialogMode mode;
  final String? action;

  const _DeleteConfirmationDialog({
    required this.message,
    this.content,
    required this.escReturns,
    required this.width,
    required this.mode,
    this.action = 'deletion',
  });

  @override
  State<_DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<_DeleteConfirmationDialog> {
  final FocusNode _focusNode = FocusNode();
  late bool isYesSelected;
  FocusNode? _previousFocusNode;

  final TextEditingController _reasonController = TextEditingController();
  String _deleteReason = '';

  @override
  void initState() {
    super.initState();
    _previousFocusNode = FocusManager.instance.primaryFocus;
    isYesSelected = widget.mode == DeleteDialogMode.delete ? false : true;
    Future.delayed(Duration.zero, () {
      if (mounted) FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _focusNode.dispose();
    _previousFocusNode?.requestFocus();
    super.dispose();
  }

  void _showMissingReasonAlert() {
    context.showAlertSnackBar(
        message: 'Please enter a reason for ${widget.action}.');
  }

  void _tryPopResult(bool confirmed) {
    bool isDeleteOrCancelMode = widget.mode == DeleteDialogMode.delete ||
        widget.mode == DeleteDialogMode.cancel;
    if (isDeleteOrCancelMode && confirmed && _deleteReason.trim().isEmpty) {
      _showMissingReasonAlert();
      return;
    }

    Navigator.pop(
      context,
      ConfirmationDialogResult(
        confirmed: confirmed,
        reason: isDeleteOrCancelMode ? _deleteReason.trim() : null,
      ),
    );
  }

  void _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      // if (event.logicalKey == LogicalKeyboardKey.keyY) {
      //   _tryPopResult(true);
      // } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
      //   _tryPopResult(false);
      // }
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _tryPopResult(widget.escReturns);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() {
          isYesSelected = !isYesSelected;
        });
      }
      // else if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.space) {
      //   _tryPopResult(isYesSelected);
      // }
      else if (event.logicalKey == LogicalKeyboardKey.enter) {
        _tryPopResult(isYesSelected);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData headerIcon;
    Color headerIconColor;

    switch (widget.mode) {
      case DeleteDialogMode.info:
        headerIcon = Icons.info_outline;
        headerIconColor = AppColors.appThemeColorLight;
        break;
      case DeleteDialogMode.delete:
        headerIcon = Icons.delete_outline;
        headerIconColor = Colors.red.shade600;
        break;
      case DeleteDialogMode.import:
        headerIcon = Icons.file_download_outlined;
        headerIconColor = Colors.green.shade600;
        break;
      case DeleteDialogMode.cancel:
        headerIcon = Icons.cancel_outlined;
        headerIconColor = Colors.orange.shade600;
        break;
    }

    bool isDeleteMode = widget.mode == DeleteDialogMode.delete ||
        widget.mode == DeleteDialogMode.cancel;
    bool canConfirmDelete = !isDeleteMode || _deleteReason.trim().isNotEmpty;

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.width),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: KeyboardListener(
              focusNode: _focusNode,
              onKeyEvent: _handleKeyPress,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      headerIcon,
                      size: 48,
                      color: headerIconColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.content != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.content!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (isDeleteMode) ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Reason for ${widget.action}',
                          border: const OutlineInputBorder(),
                          hintText: 'Enter your reason here...',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _deleteReason = value;
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildButton(Icons.close, "No", false, true),
                        const Gap(16),
                        _buildButton(
                            Icons.check, "Yes", true, canConfirmDelete),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String text, bool isYes, bool enabled) {
    bool isSelected = isYes ? isYesSelected : !isYesSelected;

    return ElevatedButton.icon(
      onPressed: enabled ? () => _tryPopResult(isYes) : null,
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected && enabled
            ? AppColors.appThemeColorLight
            : Colors.grey.shade300,
        foregroundColor: isSelected && enabled ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: isSelected && enabled ? 4 : 0,
      ),
    );
  }
}
