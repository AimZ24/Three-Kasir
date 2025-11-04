import 'package:flutter/material.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:kasirsuper/features/home/home.dart';
import 'package:kasirsuper/features/home/pages/pages.dart';
import 'package:kasirsuper/features/settings/settings.dart';
import 'package:kasirsuper/features/product/pages/form/page.dart';
import 'package:kasirsuper/features/product/pages/index/page.dart';
import 'package:kasirsuper/features/transaction/pages/index/page.dart';
import 'package:kasirsuper/features/transaction/pages/detail/page.dart';
import 'package:kasirsuper/features/settings/pages/printer/page.dart';
import 'package:kasirsuper/features/settings/pages/receipt/page.dart';
import 'package:kasirsuper/features/settings/pages/privacy/page.dart';
import 'package:kasirsuper/features/settings/pages/sales/page.dart';

Route<dynamic> routes(settings) {
  switch (settings.name) {
    case MainPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const MainPage(),
      );
    case ProfilePage.routeName:
      return MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      );
    case AddEditProductPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const AddEditProductPage(),
      );
    case ProductPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const ProductPage(),
      );
    case TransactionPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const TransactionPage(),
      );
    case TransactionDetailPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const TransactionDetailPage(),
        settings: settings,
      );

    case PrinterSetupPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const PrinterSetupPage(),
      );
    case SalesDataPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const SalesDataPage(),
      );
    case ReceiptSettingsPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const ReceiptSettingsPage(),
      );
    case PrivacyPolicyPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const PrivacyPolicyPage(),
      );
    default:
      return MaterialPageRoute(builder: (context) {
        return const Scaffold(
          body: Center(
            child: RegularText(
              'Page Not Found',
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
  }
}
