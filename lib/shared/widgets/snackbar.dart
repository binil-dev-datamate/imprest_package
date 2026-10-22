import 'package:imprest_cash/shared/widgets/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';

enum SnackBarType { success, failure, alert, normal }

bool _isPersistentType(SnackBarType type) => type == SnackBarType.alert;

void showCustomSnackBar(
    {required BuildContext context,
    required String message,
    VoidCallback? onRetry,
    SnackBarType type = SnackBarType.normal,
    int duration = 6000,
    bool autoDismiss = true}) {
  GetIt.I<NotificationManager>()
      .showNotification(context, message, type, duration, autoDismiss);
}

Color getSnackBarBackgroundColor(SnackBarType type) {
  switch (type) {
    case SnackBarType.alert:
      return Colors.orange;

    case SnackBarType.failure:
      return Colors.red;

    case SnackBarType.success:
      return Colors.green;

    case SnackBarType.normal:
      return Colors.blue;
  }
}

IconData getSnackBarIcon(SnackBarType type) {
  switch (type) {
    case SnackBarType.alert:
      return Icons.warning_rounded;

    case SnackBarType.failure:
      return Icons.error_rounded;

    case SnackBarType.success:
      return Icons.check_circle_rounded;

    case SnackBarType.normal:
      return Icons.info_rounded;
  }
}

class NotificationManager {
  final List<NotificationData> _notifications = [];
  OverlayEntry? _overlayEntry;
  int _nextId = 0;

  final List<String> _errorQueue = [];
  String? _visibleErrorMessage;
  bool _showingErrorDialog = false;

  void showNotification(BuildContext context, String message, SnackBarType type,
      int duration, bool autoDismiss) {
    if (type == SnackBarType.failure) {
      _enqueueErrorDialog(context, message);
      return;
    }

    final overlay = Overlay.of(context);
    final effectiveAutoDismiss = _isPersistentType(type) ? false : autoDismiss;

    final animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: overlay,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCubic,
    );

    final opacity =
        Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);
    final offset = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(curvedAnimation);
    final scale = Tween<double>(begin: 0.98, end: 1.0).animate(curvedAnimation);

    final notificationData = NotificationData(
      id: _nextId++,
      autoDismiss: effectiveAutoDismiss,
      message: message,
      backgroundColor: getSnackBarBackgroundColor(type),
      icon: getSnackBarIcon(type),
      animationController: animationController,
      curvedAnimation: curvedAnimation,
      opacity: opacity,
      offset: offset,
      scale: scale,
      onDismiss: (notification) => _dismissNotification(notification),
    );

    _notifications.add(notificationData);

    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          bottom: 40.0,
          left: 20.0,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < _notifications.length; i++) ...[
                  if (i > 0) const Gap(12),
                  AnimatedNotificationWidget(
                    key: ValueKey(_notifications[i].id),
                    notification: _notifications[i],
                  ),
                ],
              ],
            ),
          ),
        ),
      );
      overlay.insert(_overlayEntry!);
    } else {
      _overlayEntry!.markNeedsBuild();
    }

    animationController.forward();

    if (effectiveAutoDismiss) {
      Future.delayed(Duration(milliseconds: duration), () {
        if (_notifications.contains(notificationData)) {
          _dismissNotification(notificationData);
        }
      });
    }
  }

  void _enqueueErrorDialog(BuildContext fallbackContext, String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      return;
    }

    if (trimmed == _visibleErrorMessage || _errorQueue.contains(trimmed)) {
      return;
    }

    if (_showingErrorDialog) {
      _errorQueue.add(trimmed);
      return;
    }

    _showingErrorDialog = true;
    _visibleErrorMessage = trimmed;
    _showErrorDialog(fallbackContext, trimmed);
  }

  Future<void> _showErrorDialog(
      BuildContext fallbackContext, String message) async {
    final dialogContext = _resolveDialogContext(fallbackContext);
    if (dialogContext == null) {
      _clearErrorQueue();
      return;
    }

    final acknowledged = await showDialog<bool>(
      context: dialogContext,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: DialogBox.ok(
            context: context,
            heading: 'Error',
            messageText: message,
            severity: DialogSeverity.error,
            showClose: false,
            maxMessageHeight: 280,
            autofocusOk: true,
          ),
        );
      },
    );

    _visibleErrorMessage = null;

    if (acknowledged == true) {
      if (_errorQueue.isEmpty) {
        _showingErrorDialog = false;
        return;
      }
      final next = _errorQueue.removeAt(0);
      _visibleErrorMessage = next;
      // Show the next message on the following frame so the previous route is gone.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(fallbackContext, next);
      });
      return;
    }

    // Route was removed (logout, dispose) — drop remaining messages from this session.
    _clearErrorQueue();
  }

  BuildContext? _resolveDialogContext(BuildContext fallbackContext) {
    if (GetIt.I.isRegistered<GlobalKey<NavigatorState>>()) {
      final navContext = GetIt.I<GlobalKey<NavigatorState>>().currentContext;
      if (navContext != null && navContext.mounted) {
        return navContext;
      }
    }
    if (fallbackContext.mounted) {
      return fallbackContext;
    }
    return null;
  }

  void _clearErrorQueue() {
    _errorQueue.clear();
    _visibleErrorMessage = null;
    _showingErrorDialog = false;
  }

  void _dismissNotification(NotificationData notification) {
    if (notification.dismissing || !_notifications.contains(notification)) {
      return;
    }
    notification.dismissing = true;

    notification.animationController.reverse().then((_) {
      _notifications.remove(notification);
      notification.dispose();
      if (_notifications.isEmpty) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      } else {
        _overlayEntry?.markNeedsBuild();
      }
    });
  }
}

class AnimatedNotificationWidget extends StatelessWidget {
  final NotificationData notification;

  const AnimatedNotificationWidget({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final card = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF2B2D31),
        shadowColor: Colors.black.withValues(alpha: 0.2),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: notification.autoDismiss
              ? _buildAutoDismissContent(context)
              : _buildPersistentContent(context),
        ),
      ),
    );

    final content = notification.autoDismiss
        ? Dismissible(
            key: ValueKey(notification.id),
            direction: DismissDirection.up,
            onDismissed: (_) => notification.onDismiss(notification),
            child: card,
          )
        : card;

    return AnimatedBuilder(
      animation: notification.curvedAnimation,
      child: content,
      builder: (context, child) {
        return FadeTransition(
          opacity: notification.opacity,
          child: SlideTransition(
            position: notification.offset,
            child: ScaleTransition(
              scale: notification.scale,
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAutoDismissContent(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          notification.icon,
          color: notification.backgroundColor,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            notification.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersistentContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              notification.icon,
              color: notification.backgroundColor,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notification.message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            key: ValueKey('snackbar-ok-${notification.id}'),
            onPressed: () => notification.onDismiss(notification),
            style: TextButton.styleFrom(
              foregroundColor: notification.backgroundColor,
              minimumSize: const Size(100, 40),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationData {
  final int id;
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final AnimationController animationController;
  final CurvedAnimation curvedAnimation;
  final Animation<double> opacity;
  final Animation<Offset> offset;
  final Animation<double> scale;
  final void Function(NotificationData notification) onDismiss;
  final bool autoDismiss;
  bool dismissing = false;

  NotificationData({
    required this.id,
    required this.message,
    required this.autoDismiss,
    required this.icon,
    required this.backgroundColor,
    required this.animationController,
    required this.curvedAnimation,
    required this.opacity,
    required this.offset,
    required this.scale,
    required this.onDismiss,
  });

  void dispose() {
    curvedAnimation.dispose();
    animationController.dispose();
  }
}
