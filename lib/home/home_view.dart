import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:imprest_cash/home/imprest_placeholder_page.dart';
import 'package:imprest_cash/shared/components/dynamic_menu.dart';
import 'package:imprest_cash/shared/widgets/appbar.dart';
import 'package:imprest_cash/theme/colors.dart';

/// Imprest dashboard, laid out like the Accounting dashboard:
/// menu on the left, brand panel on the right.
///
/// Menu groups follow the order people work in: fund setup, daily
/// payments, then finance cash controls. Items open placeholder
/// pages for now; funds, vouchers, and posting come in later phases.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  List<MenuSection> _menuData() {
    MenuItem item(String shortcut, String label) {
      return MenuItem(
        shortcut: shortcut,
        label: label,
        navigateTo: () => ImprestPlaceholderPage(title: label),
      );
    }

    return [
      MenuSection(
        title: 'Funds',
        items: [
          item('F', 'Fund List'),
          item('N', 'New Fund'),
        ],
      ),
      MenuSection(
        title: 'Payments',
        items: [
          item('P', 'Payment Voucher'),
          item('H', 'Payment History'),
        ],
      ),
      MenuSection(
        title: 'Cash Control',
        items: [
          item('R', 'Replenishment'),
          item('C', 'Physical Count'),
          item('U', 'Return Unused Cash'),
          item('X', 'Close Fund'),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppCustomAppbar(
        title: 'Imprest Cash',
        sessionLabel: 'Waiting for session',
      ),
      body: Row(
        children: [
          Expanded(
            flex: 8,
            child: Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Imprest Cash',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.appThemeColorLight,
                      ),
                    ),
                    Gap(10),
                    Text(
                      'V 1.0.0',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: DynamicMenu(
                    title: 'Main Menu',
                    showAppBar: false,
                    backgroundColor: Colors.white,
                    menuData: _menuData(),
                    onMenuItemSelected: (item) {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
