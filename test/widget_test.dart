import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:imprest_cash/main.dart';
import 'package:imprest_cash/shared/widgets/snackbar.dart';

void main() {
  setUp(() async {
    await GetIt.I.reset();
    GetIt.I.registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);
    GetIt.I.registerLazySingleton<NotificationManager>(
        () => NotificationManager());
  });

  testWidgets('Imprest dashboard renders Accounting-style menu',
      (tester) async {
    await tester.pumpWidget(const ImprestApp());

    expect(find.text('Imprest Cash'), findsWidgets);
    expect(find.text('Waiting for session'), findsOneWidget);
    expect(find.text('Main Menu'), findsOneWidget);
    expect(find.text('Funds'), findsOneWidget);
    expect(find.text('Payments'), findsOneWidget);
    expect(find.text('Cash Control'), findsOneWidget);
    expect(find.text('Fund List'), findsOneWidget);
    expect(find.text('Payment Voucher'), findsOneWidget);
    expect(find.text('Replenishment'), findsOneWidget);
    expect(find.text('Close Fund'), findsOneWidget);

    // Old shell form is gone.
    expect(find.text('Payee'), findsNothing);
    expect(find.text('Fund (placeholder)'), findsNothing);
  });

  testWidgets('Menu item opens placeholder page', (tester) async {
    await tester.pumpWidget(const ImprestApp());

    await tester.tap(find.text('Fund List'));
    await tester.pumpAndSettle();

    expect(find.text('This screen is not built yet.'), findsOneWidget);
  });
}
