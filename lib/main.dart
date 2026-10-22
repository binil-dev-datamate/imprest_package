import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:imprest_cash/home/home_view.dart';
import 'package:imprest_cash/shared/widgets/snackbar.dart';
import 'package:imprest_cash/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // Snackbar (copied from Accounting) resolves the navigator and the
  // NotificationManager through GetIt.
  if (!GetIt.I.isRegistered<GlobalKey<NavigatorState>>()) {
    GetIt.I.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);
  }
  if (!GetIt.I.isRegistered<NotificationManager>()) {
    GetIt.I.registerLazySingleton<NotificationManager>(
        () => NotificationManager());
  }
  runApp(const ImprestApp());
}

class ImprestApp extends StatelessWidget {
  const ImprestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imprest Cash',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.accountingTheme,
      home: const HomeView(),
    );
  }
}
